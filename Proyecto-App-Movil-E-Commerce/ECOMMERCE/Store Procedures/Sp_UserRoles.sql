Use DB_ECOMMERCE
GO


-- 1. LISTAR ROLES ASIGNADOS A USUARIOS
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[List_UserRoles]
AS
BEGIN
	SELECT 
		UR.userRoleId,
		UR.userRoleUserId,
		U.userName,
		U.userEmail,
		UR.userRoleRoleId,
		R.roleName,
		UR.userRoleCreatorId,
		UR.userRoleCreationDate
	FROM [SQM_SECURITY].[Tbl_UserRoles] UR
	INNER JOIN [SQM_SECURITY].[Tbl_Users] U ON UR.userRoleUserId = U.userId
	INNER JOIN [SQM_SECURITY].[Tbl_Roles] R ON UR.userRoleRoleId = R.roleId
	WHERE UR.userRoleStatusId = 1
	ORDER BY U.userName ASC
END
GO

-- 2. FILTRAR ROLES DE USUARIOS (Búsqueda por Nombre, Email, Rol o ID)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Filt_list_UserRoles] (
	@Filt NVARCHAR(100)
)
AS
BEGIN
	SELECT 
		UR.userRoleId,
		UR.userRoleUserId,
		U.userName,
		U.userEmail,
		UR.userRoleRoleId,
		R.roleName,
		UR.userRoleCreatorId,
		UR.userRoleCreationDate
	FROM [SQM_SECURITY].[Tbl_UserRoles] UR
	INNER JOIN [SQM_SECURITY].[Tbl_Users] U ON UR.userRoleUserId = U.userId
	INNER JOIN [SQM_SECURITY].[Tbl_Roles] R ON UR.userRoleRoleId = R.roleId
	WHERE UR.userRoleStatusId = 1
	  AND (
		U.userName LIKE '%' + @Filt + '%'
		OR U.userEmail LIKE '%' + @Filt + '%'
		OR R.roleName LIKE '%' + @Filt + '%'
		OR (UR.userRoleId = TRY_CAST(@Filt AS INT))
		OR (UR.userRoleUserId = TRY_CAST(@Filt AS INT))
	  )
END
GO

-- 3. INSERTAR / REACTIVAR ROL A UN USUARIO
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Insert_list_UserRoles] (
	@userRoleUserId INT NULL,
	@userRoleRoleId INT NULL,
	@userRoleCreatorId INT NULL,
	@userRoleCreationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado BIT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@userRoleCreationDate IS NULL)
		BEGIN
			SET @userRoleCreationDate = GETDATE()
		END

		IF(@userRoleUserId IS NULL OR @userRoleRoleId IS NULL OR @userRoleCreatorId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 0
			RETURN
		END

		-- Validar la integridad de que existan el Usuario y el Rol en sus tablas maestras
		IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userRoleUserId)
		BEGIN
			SET @Mensaje = 'El usuario especificado no existe'
			SET @Resultado = 0
			RETURN
		END

		IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Roles] WHERE roleId = @userRoleRoleId AND roleStatusId = 1)
		BEGIN
			SET @Mensaje = 'El rol especificado no existe o esta inactivo'
			SET @Resultado = 0
			RETURN
		END

		-- Evitar duplicidad de un rol activo sobre un mismo usuario
		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_UserRoles] WHERE userRoleUserId = @userRoleUserId AND userRoleRoleId = @userRoleRoleId AND userRoleStatusId = 1)
		BEGIN
			SET @Mensaje = 'El usuario ya cuenta con este rol activo'
			SET @Resultado = 0
			RETURN
		END

		-- Reactivación automática si ya existía la relación pero estaba en borrado lógico (statusId = 0)
		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_UserRoles] WHERE userRoleUserId = @userRoleUserId AND userRoleRoleId = @userRoleRoleId AND userRoleStatusId = 0)
		BEGIN
			BEGIN TRANSACTION [trx_reactiva_userrole]
			UPDATE [SQM_SECURITY].[Tbl_UserRoles]
			SET
				userRoleStatusId = 1,
				userRoleCreatorId = @userRoleCreatorId,
				userRoleCreationDate = @userRoleCreationDate
			WHERE userRoleUserId = @userRoleUserId AND userRoleRoleId = @userRoleRoleId AND userRoleStatusId = 0
			COMMIT TRANSACTION [trx_reactiva_userrole]

			SET @Mensaje = 'Asignacion de rol reactivada con exito para el usuario'
			SET @Resultado = 1
			RETURN
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION [trx_insert_userrole]
			INSERT INTO [SQM_SECURITY].[Tbl_UserRoles] (
				userRoleUserId,
				userRoleRoleId,
				userRoleCreatorId,
				userRoleCreationDate,
				userRoleStatusId
			)
			VALUES (
				@userRoleUserId,
				@userRoleRoleId,
				@userRoleCreatorId,
				@userRoleCreationDate,
				1
			)
			COMMIT TRANSACTION [trx_insert_userrole]

			SET @Mensaje = 'Rol asignado al usuario con exito'
			SET @Resultado = 1
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRANSACTION END
		SET @Mensaje = 'Error: ' + ERROR_MESSAGE()
		SET @Resultado = 0
	END CATCH
END
GO

-- 4. ACTUALIZAR ROL ASIGNADO A UN USUARIO (Ej: Cambiarle su rol de cliente a administrador)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Update_list_UserRoles] (
	@userRoleId INT,
	@userRoleUserId INT NULL,
	@userRoleRoleId INT NULL,
	@userRoleCreatorId INT NULL,
	@userRoleCreationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado BIT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@userRoleCreationDate IS NULL)
		BEGIN
			SET @userRoleCreationDate = GETDATE()
		END

		IF(@userRoleId IS NULL OR @userRoleUserId IS NULL OR @userRoleRoleId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 0
			RETURN
		END

		-- Validar que no cause colisión transaccional con otra asignación activa idéntica
		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_UserRoles] 
				  WHERE userRoleUserId = @userRoleUserId 
				    AND userRoleRoleId = @userRoleRoleId 
					AND userRoleStatusId = 1 
					AND userRoleId <> @userRoleId)
		BEGIN
			SET @Mensaje = 'El usuario ya posee ese rol en otro registro activo'
			SET @Resultado = 0
			RETURN
		END

		BEGIN TRANSACTION [trx_update_userrole]
		UPDATE [SQM_SECURITY].[Tbl_UserRoles]
		SET
			userRoleUserId = @userRoleUserId,
			userRoleRoleId = @userRoleRoleId,
			userRoleCreatorId = @userRoleCreatorId,
			userRoleCreationDate = @userRoleCreationDate,
			userRoleStatusId = 1
		WHERE userRoleId = @userRoleId
		COMMIT TRANSACTION [trx_update_userrole]

		SET @Mensaje = 'Asignacion de usuario-rol modificada con exito'
		SET @Resultado = 1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRANSACTION END
		SET @Mensaje = 'Error: ' + ERROR_MESSAGE()
		SET @Resultado = 0
	END CATCH
END
GO

-- 5. ELIMINAR ROL A UN USUARIO (Revocación por Borrado Lógico)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Delete_list_UserRoles] (
	@userRoleId INT,
	@userRoleCreatorId INT NULL, -- Auditoría de quién remueve el permiso
	@userRoleCreationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado BIT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@userRoleCreationDate IS NULL)
		BEGIN
			SET @userRoleCreationDate = GETDATE()
		END

		IF(@userRoleId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 0
			RETURN
		END

		IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_UserRoles] WHERE userRoleStatusId = 1 AND userRoleId = @userRoleId)
		BEGIN
			SET @Mensaje = 'La asignacion no existe o ya ha sido removida'
			SET @Resultado = 0
			RETURN
		END

		BEGIN TRANSACTION [trx_delete_userrole]
		UPDATE [SQM_SECURITY].[Tbl_UserRoles]
		SET
			userRoleStatusId = 0,
			userRoleCreatorId = @userRoleCreatorId, -- Se actualiza con el ID de auditoría actual
			userRoleCreationDate = @userRoleCreationDate
		WHERE userRoleId = @userRoleId
		COMMIT TRANSACTION [trx_delete_userrole]

		SET @Mensaje = 'Rol revocado del usuario con exito'
		SET @Resultado = 1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRANSACTION END
		SET @Mensaje = 'Error: ' + ERROR_MESSAGE()
		SET @Resultado = 0
	END CATCH
END
GO
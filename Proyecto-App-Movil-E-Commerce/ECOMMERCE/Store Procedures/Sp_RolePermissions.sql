USE [DB_ECOMMERCE]
GO

-- 1. LISTAR TODA LA MATRIZ DE CONFIGURACIÓN
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[List_RolePermissions]
AS
BEGIN
	SELECT 
		rolePermissionId,
		rolePermissionRoleId,
		R.roleName,
		rolePermissionPermissionId,
		P.permissionName,
		P.permissionModule,
		rolePermissionCreatorId,
		rolePermissionCreationDate
	FROM [SQM_SECURITY].[Tbl_RolePermissions] RP
	INNER JOIN [SQM_SECURITY].[Tbl_Roles] R ON RP.rolePermissionRoleId = R.roleId
	INNER JOIN [SQM_SECURITY].[Tbl_Permissions] P ON RP.rolePermissionPermissionId = P.permissionId
	WHERE rolePermissionStatusId = 1
	ORDER BY R.roleName ASC, P.permissionModule ASC
END
GO

-- 2. FILTRAR MATRIZ ROL-PERMISO (Búsqueda Inteligente Dinámica)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Filt_list_RolePermissions] (
	@Filt NVARCHAR(100)
)
AS
BEGIN
	SELECT 
		rolePermissionId,
		rolePermissionRoleId,
		R.roleName,
		rolePermissionPermissionId,
		P.permissionName,
		P.permissionModule,
		rolePermissionCreatorId,
		rolePermissionCreationDate
	FROM [SQM_SECURITY].[Tbl_RolePermissions] RP
	INNER JOIN [SQM_SECURITY].[Tbl_Roles] R ON RP.rolePermissionRoleId = R.roleId
	INNER JOIN [SQM_SECURITY].[Tbl_Permissions] P ON RP.rolePermissionPermissionId = P.permissionId
	WHERE rolePermissionStatusId = 1
	  AND (
		R.roleName LIKE '%' + @Filt + '%'
		OR P.permissionName LIKE '%' + @Filt + '%'
		OR P.permissionModule LIKE '%' + @Filt + '%'
		OR (rolePermissionId = TRY_CAST(@Filt AS INT))
		OR (rolePermissionRoleId = TRY_CAST(@Filt AS INT))
	  )
END
GO

-- 3. ACTUALIZAR ACCESO EN LA MATRIZ (Cambiar un permiso viejo por uno nuevo en el mapeo)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Update_list_RolePermissions] (
	@rolePermissionId INT,
	@rolePermissionRoleId INT NULL,
	@rolePermissionPermissionId INT NULL,
	@rolePermissionCreatorId INT NULL, -- Registra quién hizo el cambio de matriz
	@rolePermissionCreationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado BIT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@rolePermissionCreationDate IS NULL)
		BEGIN
			SET @rolePermissionCreationDate = GETDATE()
		END

		IF(@rolePermissionId IS NULL OR @rolePermissionRoleId IS NULL OR @rolePermissionPermissionId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 0
			RETURN
		END

		-- Validar que el nuevo cruce no cause conflicto/duplicidad con otro ya activo
		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_RolePermissions] 
				  WHERE rolePermissionRoleId = @rolePermissionRoleId 
				    AND rolePermissionPermissionId = @rolePermissionPermissionId 
					AND rolePermissionStatusId = 1 
					AND rolePermissionId <> @rolePermissionId)
		BEGIN
			SET @Mensaje = 'Este rol ya cuenta con ese permiso activo en otro registro de la matriz'
			SET @Resultado = 0
			RETURN
		END

		BEGIN TRANSACTION [trx_update_roleperm]
		UPDATE [SQM_SECURITY].[Tbl_RolePermissions]
		SET
			rolePermissionRoleId = @rolePermissionRoleId,
			rolePermissionPermissionId = @rolePermissionPermissionId,
			rolePermissionCreatorId = @rolePermissionCreatorId,
			rolePermissionCreationDate = @rolePermissionCreationDate,
			rolePermissionStatusId = 1
		WHERE rolePermissionId = @rolePermissionId
		COMMIT TRANSACTION [trx_update_roleperm]

		SET @Mensaje = 'Matriz de Rol-Permiso actualizada con exito'
		SET @Resultado = 1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRANSACTION END
		SET @Mensaje = 'Error: ' + ERROR_MESSAGE()
		SET @Resultado = 0
	END CATCH
END
GO

-- 4. INSERTAR / REACTIVAR RELACIÓN EN LA MATRIZ
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Insert_list_RolePermissions] (
	@rolePermissionRoleId INT NULL,
	@rolePermissionPermissionId INT NULL,
	@rolePermissionCreatorId INT NULL,
	@rolePermissionCreationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado BIT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@rolePermissionCreationDate IS NULL)
		BEGIN
			SET @rolePermissionCreationDate = GETDATE()
		END

		IF(@rolePermissionRoleId IS NULL OR @rolePermissionPermissionId IS NULL OR @rolePermissionCreatorId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 0
			RETURN
		END

		-- Validar la integridad de que existan el Rol y el Permiso en las tablas maestras vivas
		IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Roles] WHERE roleId = @rolePermissionRoleId AND roleStatusId = 1)
		BEGIN
			SET @Mensaje = 'El rol especificado no existe o esta inactivo'
			SET @Resultado = 0
			RETURN
		END

		IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Permissions] WHERE permissionId = @rolePermissionPermissionId AND permissionStatusId = 1)
		BEGIN
			SET @Mensaje = 'El permiso especificado no existe o esta inactivo'
			SET @Resultado = 0
			RETURN
		END

		-- Evitar duplicidad de un permiso activo asignado al mismo rol
		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_RolePermissions] 
				  WHERE rolePermissionRoleId = @rolePermissionRoleId 
				    AND rolePermissionPermissionId = @rolePermissionPermissionId 
					AND rolePermissionStatusId = 1)
		BEGIN
			SET @Mensaje = 'El rol ya cuenta con este permiso asignado de forma activa'
			SET @Resultado = 0
			RETURN
		END

		-- Reactivación automática si ya existía la relación previa dada de baja (statusId = 0)
		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_RolePermissions] 
				  WHERE rolePermissionRoleId = @rolePermissionRoleId 
				    AND rolePermissionPermissionId = @rolePermissionPermissionId 
					AND rolePermissionStatusId = 0)
		BEGIN
			BEGIN TRANSACTION [trx_reactiva_roleperm]
			UPDATE [SQM_SECURITY].[Tbl_RolePermissions]
			SET
				rolePermissionStatusId = 1,
				rolePermissionCreatorId = @rolePermissionCreatorId,
				rolePermissionCreationDate = @rolePermissionCreationDate
			WHERE rolePermissionRoleId = @rolePermissionRoleId 
			  AND rolePermissionPermissionId = @rolePermissionPermissionId 
			  AND rolePermissionStatusId = 0
			COMMIT TRANSACTION [trx_reactiva_roleperm]

			SET @Mensaje = 'Acceso de permiso reactivado con exito para este rol'
			SET @Resultado = 1
			RETURN
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION [trx_insert_roleperm]
			INSERT INTO [SQM_SECURITY].[Tbl_RolePermissions] (
				rolePermissionRoleId,
				rolePermissionPermissionId,
				rolePermissionCreatorId,
				rolePermissionCreationDate,
				rolePermissionStatusId
			)
			VALUES (
				@rolePermissionRoleId,
				@rolePermissionPermissionId,
				@rolePermissionCreatorId,
				@rolePermissionCreationDate,
				1
			)
			COMMIT TRANSACTION [trx_insert_roleperm]

			SET @Mensaje = 'Permiso asignado al rol con exito en la matriz'
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

-- 5. ELIMINAR RELACIÓN EN LA MATRIZ (Borrado Lógico)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Delete_list_RolePermissions] (
	@rolePermissionId INT,
	@rolePermissionCreatorId INT NULL, -- Registra al auditor que revoca el permiso
	@rolePermissionCreationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado BIT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@rolePermissionCreationDate IS NULL)
		BEGIN
			SET @rolePermissionCreationDate = GETDATE()
		END

		IF(@rolePermissionId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 0
			RETURN
		END

		IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_RolePermissions] 
					  WHERE rolePermissionStatusId = 1 AND rolePermissionId = @rolePermissionId)
		BEGIN
			SET @Mensaje = 'El registro de la matriz no existe o ya esta eliminado'
			SET @Resultado = 0
			RETURN
		END

		BEGIN TRANSACTION [trx_delete_roleperm]
		UPDATE [SQM_SECURITY].[Tbl_RolePermissions]
		SET
			rolePermissionStatusId = 0,
			rolePermissionCreatorId = @rolePermissionCreatorId,
			rolePermissionCreationDate = @rolePermissionCreationDate
		WHERE rolePermissionId = @rolePermissionId
		COMMIT TRANSACTION [trx_delete_roleperm]

		SET @Mensaje = 'Permiso revocado del rol con exito (Matriz actualizada)'
		SET @Resultado = 1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRANSACTION END
		SET @Mensaje = 'Error: ' + ERROR_MESSAGE()
		SET @Resultado = 0
	END CATCH
END
GO



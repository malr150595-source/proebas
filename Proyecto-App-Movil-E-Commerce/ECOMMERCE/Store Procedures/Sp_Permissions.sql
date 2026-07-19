USE [DB_ECOMMERCE]
GO

-- 1. LISTAR PERMISOS
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[List_Permissions]
AS
BEGIN
	SELECT 
		permissionId,
		permissionName,
		permissionDescription,
		permissionModule,
		permissionCreatorId,
		permissionCreationDate
	FROM [SQM_SECURITY].[Tbl_Permissions]
	WHERE permissionStatusId = 1
	ORDER BY permissionModule ASC, permissionName ASC
END
GO

-- 2. FILTRAR PERMISOS
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Filt_list_Permissions] (
	@Filt NVARCHAR(100)
)
AS
BEGIN
	SELECT 
		permissionId,
		permissionName,
		permissionDescription,
		permissionModule,
		permissionCreatorId,
		permissionCreationDate
	FROM [SQM_SECURITY].[Tbl_Permissions]
	WHERE permissionStatusId = 1
	  AND (
		permissionName LIKE '%' + @Filt + '%'
		OR permissionModule LIKE '%' + @Filt + '%'
		OR (permissionId = TRY_CAST(@Filt AS INT))
	  )
END
GO

-- 3. INSERTAR / REACTIVAR PERMISOS
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Insert_list_Permissions] (
	@permissionName VARCHAR(100) NULL,
	@permissionDescription VARCHAR(200) NULL,
	@permissionModule VARCHAR(50) NULL,
	@permissionCreatorId INT NULL,
	@permissionCreationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado BIT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@permissionCreationDate IS NULL)
		BEGIN
			SET @permissionCreationDate = GETDATE()
		END

		IF(@permissionName IS NULL OR @permissionDescription IS NULL OR @permissionModule IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 0
			RETURN
		END

		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Permissions] WHERE permissionName = @permissionName AND permissionStatusId = 1)
		BEGIN
			SET @Mensaje = 'Ya existe un permiso con esa clave'
			SET @Resultado = 0
			RETURN
		END

		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Permissions] WHERE permissionName = @permissionName AND permissionStatusId = 0)
		BEGIN
			BEGIN TRANSACTION [trx_reactivacion_permisos]
			UPDATE [SQM_SECURITY].[Tbl_Permissions]
			SET
				permissionStatusId = 1,
				permissionCreatorId = @permissionCreatorId, -- Se asume mapeo histórico
				permissionCreationDate = @permissionCreationDate,
				permissionDescription = @permissionDescription,
				permissionModule = @permissionModule
			WHERE permissionName = @permissionName AND permissionStatusId = 0
			COMMIT TRANSACTION [trx_reactivacion_permisos]
			
			SET @Mensaje = 'Ya existia el permiso, se activo nuevamente'
			SET @Resultado = 1
			RETURN
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION [trx_insert_permisos]
			INSERT INTO [SQM_SECURITY].[Tbl_Permissions] (
				permissionName,
				permissionDescription,
				permissionModule,
				permissionCreatorId,
				permissionCreationDate,
				permissionStatusId
			)
			VALUES (
				@permissionName,
				@permissionDescription,
				@permissionModule,
				@permissionCreatorId,
				@permissionCreationDate,
				1
			)
			COMMIT TRANSACTION [trx_insert_permisos]
			
			SET @Mensaje = 'Permiso ingresado con exito'
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

-- 1. LISTAR MATRIZ DE PERMISOS POR UN ROL ESPECÍFICO
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[List_PermissionsByRole] (
	@roleId INT
)
AS
BEGIN
	SELECT 
		RP.rolePermissionId,
		RP.rolePermissionRoleId,
		R.roleName,
		RP.rolePermissionPermissionId,
		P.permissionName,
		P.permissionDescription,
		P.permissionModule
	FROM [SQM_SECURITY].[Tbl_RolePermissions] RP
	INNER JOIN [SQM_SECURITY].[Tbl_Roles] R ON RP.rolePermissionRoleId = R.roleId
	INNER JOIN [SQM_SECURITY].[Tbl_Permissions] P ON RP.rolePermissionPermissionId = P.permissionId
	WHERE RP.rolePermissionStatusId = 1 
	  AND R.roleStatusId = 1 
	  AND P.permissionStatusId = 1
	  AND RP.rolePermissionRoleId = @roleId
END
GO

-- 2. ASIGNAR O REACTIVAR UN PERMISO A UN ROL
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Assign_PermissionToRole] (
	@roleId INT NULL,
	@permissionId INT NULL,
	@creatorId INT NULL,
	@creationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado BIT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@creationDate IS NULL)
		BEGIN
			SET @creationDate = GETDATE()
		END

		IF(@roleId IS NULL OR @permissionId IS NULL OR @creatorId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 0
			RETURN
		END

		-- Verificar que existan las entidades maestras vivas
		IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Roles] WHERE roleId = @roleId AND roleStatusId = 1)
		OR NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Permissions] WHERE permissionId = @permissionId AND permissionStatusId = 1)
		BEGIN
			SET @Mensaje = 'El Rol o Permiso especificado no existe o esta inactivo'
			SET @Resultado = 0
			RETURN
		END

		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_RolePermissions] WHERE rolePermissionRoleId = @roleId AND rolePermissionPermissionId = @permissionId AND rolePermissionStatusId = 1)
		BEGIN
			SET @Mensaje = 'El rol ya cuenta con ese permiso de forma activa'
			SET @Resultado = 0
			RETURN
		END

		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_RolePermissions] WHERE rolePermissionRoleId = @roleId AND rolePermissionPermissionId = @permissionId AND rolePermissionStatusId = 0)
		BEGIN
			BEGIN TRANSACTION [trx_reactiva_matriz]
			UPDATE [SQM_SECURITY].[Tbl_RolePermissions]
			SET
				rolePermissionStatusId = 1,
				rolePermissionCreatorId = @creatorId,
				rolePermissionCreationDate = @creationDate
			WHERE rolePermissionRoleId = @roleId AND rolePermissionPermissionId = @permissionId
			COMMIT TRANSACTION [trx_reactiva_matriz]
			
			SET @Mensaje = 'Acceso restaurado con exito para este rol'
			SET @Resultado = 1
			RETURN
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION [trx_insert_matriz]
			INSERT INTO [SQM_SECURITY].[Tbl_RolePermissions] (
				rolePermissionRoleId,
				rolePermissionPermissionId,
				rolePermissionCreatorId,
				rolePermissionCreationDate,
				rolePermissionStatusId
			)
			VALUES (
				@roleId,
				@permissionId,
				@creatorId,
				@creationDate,
				1
			)
			COMMIT TRANSACTION [trx_insert_matriz]
			
			SET @Mensaje = 'Permiso asignado al rol con exito'
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

-- 3. REVOCAR PERMISO DE UN ROL (Borrado Lógico de Relación)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Revoke_PermissionFromRole] (
	@roleId INT NULL,
	@permissionId INT NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado BIT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@roleId IS NULL OR @permissionId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 0
			RETURN
		END

		IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_RolePermissions] WHERE rolePermissionRoleId = @roleId AND rolePermissionPermissionId = @permissionId AND rolePermissionStatusId = 1)
		BEGIN
			SET @Mensaje = 'No existe una relacion activa que remover'
			SET @Resultado = 0
			RETURN
		END

		BEGIN TRANSACTION [trx_delete_matriz]
		UPDATE [SQM_SECURITY].[Tbl_RolePermissions]
		SET rolePermissionStatusId = 0
		WHERE rolePermissionRoleId = @roleId AND rolePermissionPermissionId = @permissionId
		COMMIT TRANSACTION [trx_delete_matriz]
		
		SET @Mensaje = 'Permiso removido del rol con exito'
		SET @Resultado = 1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRANSACTION END
		SET @Mensaje = 'Error: ' + ERROR_MESSAGE()
		SET @Resultado = 0
	END CATCH
END
GO
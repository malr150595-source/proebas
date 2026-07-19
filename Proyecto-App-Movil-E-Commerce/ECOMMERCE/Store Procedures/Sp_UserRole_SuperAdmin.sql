USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Insert_Assign_UserRole_SuperAdmin] (
	@userRoleUserId INT,
	@userRoleRoleId INT,
	@superAdminUserId INT, -- ID del Administrador Global que audita y realiza la acción
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		-- Validaciones de nulidad
		IF (@userRoleUserId IS NULL OR @userRoleRoleId IS NULL OR @superAdminUserId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios para realizar la asignación.';
			SET @Resultado = 400;
			RETURN;
		END

		-- Validar estrictamente que el ejecutor sea un 'Administrador Global' activo (roleId = 1)
		IF NOT EXISTS (
			SELECT 1 FROM [SQM_SECURITY].[Tbl_UserRoles]
			WHERE userRoleUserId = @superAdminUserId AND userRoleRoleId = 1 AND userRoleStatusId = 1
		)
		BEGIN
			SET @Mensaje = 'Operación denegada: Solo el Administrador Global tiene estos privilegios.';
			SET @Resultado = 401;
			RETURN;
		END

		-- Validar existencia del usuario destino
		IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @userRoleUserId)
		BEGIN
			SET @Mensaje = 'El usuario destino no existe en el sistema.';
			SET @Resultado = 404;
			RETURN;
		END

		-- Validar existencia del rol a asignar
		IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Roles] WHERE roleId = @userRoleRoleId AND roleStatusId = 1)
		BEGIN
			SET @Mensaje = 'El rol especificado no existe o está inactivo.';
			SET @Resultado = 404;
			RETURN;
		END

		BEGIN TRANSACTION [trx_superadmin_assign];

			-- Desactivar lógicamente cualquier rol anterior activo de ese usuario específico
			UPDATE [SQM_SECURITY].[Tbl_UserRoles]
			SET userRoleStatusId = 0
			WHERE userRoleUserId = @userRoleUserId AND userRoleStatusId = 1;

			-- Insertar la nueva asignación de rol
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
				@superAdminUserId, 
				GETDATE(), 
				1
			);

		COMMIT TRANSACTION [trx_superadmin_assign];

		SET @Mensaje = 'Rol asignado y actualizado por el Administrador Global con éxito.';
		SET @Resultado = 200;

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION [trx_superadmin_assign];

		SET @Mensaje = 'Error crítico en servidor de base de datos: ' + ERROR_MESSAGE();
		SET @Resultado = 500;
	END CATCH
END
GO
USE [DB_ECOMMERCE]
GO

-- 1. LISTAR ROLES
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[List_Roles]
AS
BEGIN
	SELECT 
		roleId,
		roleName,
		roleDescription,
		roleCreatorId,
		roleCreationDate,
		roleModificatorId,
		roleModificationDate
	FROM [SQM_SECURITY].[Tbl_Roles]
	WHERE roleStatusId = 1
	ORDER BY roleName ASC
END
GO

-- 2. FILTRAR ROLES (Filtración Dinámica)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Filt_list_Roles] (
	@Filt NVARCHAR(100)
)
AS
BEGIN
	SELECT 
		roleId,
		roleName,
		roleDescription,
		roleCreatorId,
		roleCreationDate,
		roleModificatorId,
		roleModificationDate
	FROM [SQM_SECURITY].[Tbl_Roles]
	WHERE roleStatusId = 1
	  AND (
		roleName LIKE '%' + @Filt + '%'
		OR roleDescription LIKE '%' + @Filt + '%'
		OR (roleId = TRY_CAST(@Filt AS INT))
	  )
END
GO

-- 3. INSERTAR / REACTIVAR ROLES
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Insert_list_Roles] (
	@roleName VARCHAR(50) NULL,
	@roleDescription VARCHAR(150) NULL,
	@roleCreatorId INT NULL,
	@roleCreationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado INT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@roleCreationDate IS NULL)
		BEGIN
			SET @roleCreationDate = GETDATE()
		END

		IF(@roleName IS NULL OR @roleDescription IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 400
			RETURN
		END

		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Roles] WHERE roleName = @roleName AND roleStatusId = 1)
		BEGIN
			SET @Mensaje = 'Ya existe un rol con ese nombre'
			SET @Resultado = 400
			RETURN
		END

		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Roles] WHERE roleName = @roleName AND roleStatusId = 0)
		BEGIN
			BEGIN TRANSACTION [trx_reactivacion_roles]
			UPDATE [SQM_SECURITY].[Tbl_Roles]
			SET
				roleStatusId = 1,
				roleModificatorId = @roleCreatorId,
				roleModificationDate = @roleCreationDate,
				roleDescription = @roleDescription
			WHERE roleName = @roleName AND roleStatusId = 0
			COMMIT TRANSACTION [trx_reactivacion_roles]
			
			SET @Mensaje = 'Ya existia el rol, se activo nuevamente con los nuevos datos'
			SET @Resultado = 201
			RETURN
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION [trx_insert_roles]
			INSERT INTO [SQM_SECURITY].[Tbl_Roles] (
				roleName,
				roleDescription,
				roleCreatorId,
				roleCreationDate,
				roleStatusId
			)
			VALUES (
				@roleName,
				@roleDescription,
				@roleCreatorId,
				@roleCreationDate,
				1
			)
			COMMIT TRANSACTION [trx_insert_roles]
			
			SET @Mensaje = 'Rol ingresado con exito'
			SET @Resultado = 200
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRANSACTION END
		SET @Mensaje = 'Error: ' + ERROR_MESSAGE()
		SET @Resultado = 500
	END CATCH
END
GO

-- 4. ACTUALIZAR ROLES
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Update_list_Roles] (
	@roleId INT,
	@roleName VARCHAR(50) NULL,
	@roleDescription VARCHAR(150) NULL,
	@roleModificatorId INT NULL,
	@roleModificationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado INT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@roleModificationDate IS NULL)
		BEGIN
			SET @roleModificationDate = GETDATE()
		END

		IF(@roleName IS NULL OR @roleDescription IS NULL OR @roleId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 400
			RETURN
		END

		IF EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Roles] WHERE roleName = @roleName AND roleStatusId = 1 AND roleId <> @roleId)
		BEGIN
			SET @Mensaje = 'Ya existe otro rol con ese nombre'
			SET @Resultado = 400
			RETURN
		END

		BEGIN TRANSACTION [trx_update_roles]
		UPDATE [SQM_SECURITY].[Tbl_Roles]
		SET
			roleName = @roleName,
			roleDescription = @roleDescription,
			roleModificatorId = @roleModificatorId,
			roleModificationDate = @roleModificationDate,
			roleStatusId = 1
		WHERE roleId = @roleId
		COMMIT TRANSACTION [trx_update_roles]
		
		SET @Mensaje = 'Rol actualizado con exito'
		SET @Resultado = 200
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRANSACTION END
		SET @Mensaje = 'Error: ' + ERROR_MESSAGE()
		SET @Resultado = 500
	END CATCH
END
GO

-- 5. ELIMINAR ROLES (Borrado Lógico)
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[Delete_list_Roles] (
	@roleId INT,
	@roleModificatorId INT NULL,
	@roleModificationDate DATETIME NULL,
	@Mensaje NVARCHAR(250) OUTPUT,
	@Resultado INT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF(@roleModificationDate IS NULL)
		BEGIN
			SET @roleModificationDate = GETDATE()
		END

		IF(@roleId IS NULL)
		BEGIN
			SET @Mensaje = 'Faltan datos obligatorios'
			SET @Resultado = 400
			RETURN
		END

		IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Roles] WHERE roleStatusId = 1 AND roleId = @roleId)
		BEGIN
			SET @Mensaje = 'No existe el rol o ya esta eliminado'
			SET @Resultado = 400
			RETURN
		END

		BEGIN TRANSACTION [trx_delete_roles]
		UPDATE [SQM_SECURITY].[Tbl_Roles]
		SET
			roleModificatorId = @roleModificatorId,
			roleModificationDate = @roleModificationDate,
			roleStatusId = 0
		WHERE roleId = @roleId
		COMMIT TRANSACTION [trx_delete_roles]
		
		SET @Mensaje = 'Rol eliminado con exito'
		SET @Resultado = 200
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 BEGIN ROLLBACK TRANSACTION END
		SET @Mensaje = 'Error: ' + ERROR_MESSAGE()
		SET @Resultado = 500
	END CATCH
END
GO
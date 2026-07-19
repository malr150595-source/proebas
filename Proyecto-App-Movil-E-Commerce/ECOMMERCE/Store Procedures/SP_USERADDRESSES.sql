USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROC [SQM_GENERAL].[List_UserAddresses]
AS 
BEGIN 
    SET NOCOUNT ON;
    SELECT 
        U.userAddressId,
        U.userAddressUserId,
        U.userAddressCountryId,
        U.userAddressZIPCode,
        U.userAddressDescription,
        U.userAddressIsPrincipal,
        U.userAddressCreatorId,
        U.userAddressCreationDate,
        U.userAddressModificatorId,
        U.userAddressModificationDate
    FROM [SQM_GENERAL].[Tbl_UserAddress] AS U
    WHERE U.userAddressStatusId = 1;
END
GO

CREATE OR ALTER PROC [SQM_GENERAL].[Filt_List_UserAddresses](
    @CRITERIO NVARCHAR(100) = NULL
)
AS 
BEGIN 
    SET NOCOUNT ON;
    SELECT 
        U.userAddressId,
        U.userAddressUserId,
        U.userAddressCountryId,
        U.userAddressZIPCode,
        U.userAddressDescription,
        U.userAddressIsPrincipal,
        U.userAddressCreatorId,
        U.userAddressCreationDate,
        U.userAddressModificatorId,
        U.userAddressModificationDate
    FROM [SQM_GENERAL].[Tbl_UserAddress] AS U
    WHERE U.userAddressStatusId = 1
      AND (
            @CRITERIO IS NULL
            OR U.userAddressDescription LIKE '%' + @CRITERIO + '%'
            OR CAST(U.userAddressZIPCode AS NVARCHAR(20)) LIKE '%' + @CRITERIO + '%'
            OR (ISNUMERIC(@CRITERIO) = 1 AND U.userAddressUserId = TRY_CAST(@CRITERIO AS INT))
          )
    ORDER BY U.userAddressUserId ASC;
END
GO

CREATE OR ALTER PROC [SQM_GENERAL].[Insert_UserAddresses](
    @UserAddressUserId INT,
    @UserAddressCountryId INT,
    @UserAddressZIPCode INT,
    @UserAddressDescription NVARCHAR(500),
    @UserAddressIsPrincipal BIT,
    @UserAddressCreationDate DATETIME NULL,
    @UserAddressCreatorId INT,
    @MENSAJE NVARCHAR(255) OUTPUT,
    @RESULTADO INT OUTPUT
)
AS 
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@UserAddressCreationDate IS NULL)
        BEGIN
            SET @UserAddressCreationDate = GETDATE()
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @UserAddressUserId AND userStatusId = 1)
        BEGIN
            SET @MENSAJE = 'EL USUARIO AL QUE INTENTA ASIGNAR LA DIRECCIÓN NO EXISTE O ESTÁ INACTIVO.';
            SET @RESULTADO = 400;
            RETURN;
        END

        IF (
            @UserAddressUserId IS NULL
            OR @UserAddressCountryId IS NULL
            OR @UserAddressZIPCode IS NULL
            OR ISNULL(TRIM(@UserAddressDescription), '') = ''
            OR @UserAddressIsPrincipal IS NULL
        )
        BEGIN
            SET @MENSAJE = 'Faltan datos Obligatorios';
            SET @RESULTADO = 400;
            RETURN;
        END

        BEGIN TRANSACTION;

        IF (@UserAddressIsPrincipal = 1)
        BEGIN
            UPDATE [SQM_GENERAL].[Tbl_UserAddress]
            SET userAddressIsPrincipal = 0
            WHERE userAddressUserId = @UserAddressUserId AND userAddressStatusId = 1;
        END

        INSERT INTO [SQM_GENERAL].[Tbl_UserAddress] (
            userAddressUserId,
            userAddressCountryId,
            userAddressZIPCode,
            userAddressDescription,
            userAddressIsPrincipal,
            userAddressCreatorId,
            userAddressCreationDate,
            userAddressStatusId
        ) VALUES (
            @UserAddressUserId,
            @UserAddressCountryId,
            @UserAddressZIPCode,
            TRIM(@UserAddressDescription),
            @UserAddressIsPrincipal,
            @UserAddressCreatorId,
            @UserAddressCreationDate,
            1
        );

        COMMIT TRANSACTION;
        SET @MENSAJE = 'DIRECCIÓN REGISTRADA EXITOSAMENTE.';
        SET @RESULTADO = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @MENSAJE = 'ERROR AL REGISTRAR LA DIRECCIÓN: ' + ERROR_MESSAGE();
        SET @RESULTADO = 500;
    END CATCH
END
GO

CREATE OR ALTER PROC [SQM_GENERAL].[Update_UserAddresses](
    @UserAddressId INT,
    @UserAddressUserId INT,
    @UserAddressCountryId INT,
    @UserAddressZIPCode INT,
    @UserAddressDescription NVARCHAR(500),
    @UserAddressIsPrincipal BIT,
    @UserAddressModificatorId INT,
    @UserAddressModificationDate DATETIME NULL,
    @MENSAJE NVARCHAR(255) OUTPUT,
    @RESULTADO INT OUTPUT
)
AS 
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@UserAddressModificationDate IS NULL)
        BEGIN
            SET @UserAddressModificationDate = GETDATE()
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_UserAddress] WHERE userAddressId = @UserAddressId AND userAddressStatusId = 1)
        BEGIN
            SET @MENSAJE = 'LA DIRECCIÓN SELECCIONADA NO EXISTE O FUE ELIMINADA.';
            SET @RESULTADO = 400;
            RETURN;
        END

        BEGIN TRANSACTION;

        IF (@UserAddressIsPrincipal = 1)
        BEGIN
            UPDATE [SQM_GENERAL].[Tbl_UserAddress]
            SET userAddressIsPrincipal = 0
            WHERE userAddressUserId = @UserAddressUserId AND userAddressStatusId = 1 AND userAddressId <> @UserAddressId;
        END

        UPDATE [SQM_GENERAL].[Tbl_UserAddress]
        SET 
            userAddressUserId = @UserAddressUserId,
            userAddressCountryId = @UserAddressCountryId,
            userAddressZIPCode = @UserAddressZIPCode,
            userAddressDescription = TRIM(@UserAddressDescription),
            userAddressIsPrincipal = @UserAddressIsPrincipal,
            userAddressModificatorId = @UserAddressModificatorId,
            userAddressModificationDate = @UserAddressModificationDate,
            userAddressStatusId = 1
        WHERE userAddressId = @UserAddressId AND userAddressStatusId = 1;

        COMMIT TRANSACTION;
        SET @MENSAJE = 'DIRECCIÓN ACTUALIZADA EXITOSAMENTE.';
        SET @RESULTADO = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @MENSAJE = 'ERROR AL ACTUALIZAR LA DIRECCIÓN: ' + ERROR_MESSAGE();
        SET @RESULTADO = 500;
    END CATCH
END
GO

CREATE OR ALTER PROC [SQM_GENERAL].[Delete_UserAddresses](
    @UserAddressId INT,
    @UserAddressModificatorId INT,
    @UserAddressModificationDate DATETIME NULL,
    @MENSAJE NVARCHAR(255) OUTPUT,
    @RESULTADO INT OUTPUT
)
AS 
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@UserAddressModificationDate IS NULL)
        BEGIN
            SET @UserAddressModificationDate = GETDATE()
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_UserAddress] WHERE userAddressId = @UserAddressId AND userAddressStatusId = 1)
        BEGIN
            SET @MENSAJE = 'LA DIRECCIÓN NO EXISTE O YA HA SIDO ELIMINADA.';
            SET @RESULTADO = 400;
            RETURN;
        END

        BEGIN TRANSACTION;

        UPDATE [SQM_GENERAL].[Tbl_UserAddress]
        SET 
            userAddressStatusId = 0,
            userAddressModificatorId = @UserAddressModificatorId,
            userAddressModificationDate = @UserAddressModificationDate
        WHERE userAddressId = @UserAddressId;

        COMMIT TRANSACTION;
        SET @MENSAJE = 'DIRECCIÓN ELIMINADA EXITOSAMENTE.';
        SET @RESULTADO = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @MENSAJE = 'ERROR AL ELIMINAR LA DIRECCIÓN: ' + ERROR_MESSAGE();
        SET @RESULTADO = 500;
    END CATCH
END
GO
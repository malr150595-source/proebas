USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_Providers]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        p.providerId AS ProveedorId,
        p.providerName AS ProveedorNombre,
        p.providerDescription AS ProveedorDescripcion,
        p.providerCreatorId AS ProveedorCreadorId,
        p.providerCreationDate AS ProveedorCreadorFecha,
        p.providerModificatorId AS ProveedorIdModificacion,
        p.providerModificationDate AS ProveedorModificacionFecha
    FROM SQM_CATALOGS.Tbl_Providers AS p
    WHERE providerStatusId = 1
    ORDER BY p.providerId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_list_Providers]
(
    @Filtro NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        p.providerId AS ProveedorId,
        p.providerName AS ProveedorNombre,
        p.providerDescription AS ProveedorDescripcion,
        p.providerCreatorId AS ProveedorCreadorId,
        p.providerCreationDate AS ProveedorCreadorFecha,
        p.providerModificatorId AS ProveedorIdModificacion,
        p.providerModificationDate AS ProveedorModificacionFecha
    FROM SQM_CATALOGS.Tbl_Providers AS p
    WHERE providerStatusId = 1
      AND (
        providerName LIKE '%' + @Filtro + '%'
        OR providerId = TRY_CAST(@Filtro AS INT)
      )
    ORDER BY p.providerId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_Providers]
(
    @ProviderName VARCHAR(50) NULL,
    @ProviderDescription VARCHAR(100) NULL,
    @ProviderCreatorId INT NULL,
    @ProviderCreationDate DATETIME NULL,
    @Mensaje NVARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@ProviderCreationDate IS NULL)
            SET @ProviderCreationDate = GETDATE();

        IF (ISNULL(TRIM(@ProviderName), '') = ''
        OR ISNULL(TRIM(@ProviderDescription), '') = '')
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios ¡revise!';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Providers]
        WHERE UPPER(TRIM(providerName)) = UPPER(TRIM(@ProviderName))
        AND providerStatusId = 1)
        BEGIN
                SET @Mensaje = 'Ya existe'
                SET @Resultado = 400
                RETURN;
        END
  
        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Providers]
        WHERE providerName = TRIM(@ProviderName)
        AND providerStatusId = 0)
        BEGIN
            BEGIN TRANSACTION [trx_reactivation_provider]
                UPDATE [SQM_CATALOGS].[Tbl_Providers]
                SET providerStatusId = 1,
                    providerModificatorId = @ProviderCreatorId,
                    providerModificationDate = @ProviderCreationDate
                WHERE providerName = @ProviderName AND providerStatusId = 0;
            COMMIT TRANSACTION [trx_reactivation_provider];

            SET @Mensaje = 'Datos existentes, se han activado de nuevo';
            SET @Resultado = 201;
            RETURN;
        END

        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_insert_provider]
                INSERT INTO [SQM_CATALOGS].[Tbl_Providers] (
                    providerName,
                    providerDescription,
                    providerCreatorId,
                    providerCreationDate,
                    providerStatusId
                )
                VALUES (
                    TRIM(@ProviderName),
                    @ProviderDescription,
                    @ProviderCreatorId,
                    @ProviderCreationDate,
                    1
                );
            COMMIT TRANSACTION [trx_insert_provider];

            SET @Mensaje = 'Proveedor ingresado con éxito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al insertar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_Providers]
(
    @ProviderId INT NULL,
    @ProviderName VARCHAR(50) NULL,
    @ProviderDescription VARCHAR(100) NULL,
    @ProviderModificatorId INT NULL,
    @ProviderModificationDate DATETIME NULL,
    @Mensaje NVARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@ProviderModificationDate IS NULL)
            BEGIN
                SET @ProviderModificationDate = GETDATE();
            END; 

        IF (@ProviderId IS NULL 
        OR ISNULL(TRIM(@ProviderName), '') = ''
        OR ISNULL(TRIM(@ProviderDescription), '') = ''
        )
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Providers] 
        WHERE UPPER(TRIM(providerName)) = UPPER(TRIM(@ProviderName))
        AND providerStatusId = 1 
        AND providerId <> @ProviderId)
        BEGIN
            SET @Mensaje = 'Ya existe un registro con nombre idéntico en otro proveedor';
            SET @Resultado = 400;
            RETURN;
        END
  
        BEGIN TRANSACTION [trx_update_provider]
            UPDATE [SQM_CATALOGS].[Tbl_Providers]
            SET providerName = @ProviderName,
                providerDescription = @ProviderDescription,
                providerModificatorId = @ProviderModificatorId,
                providerModificationDate = @ProviderModificationDate,
                providerStatusId = 1
            WHERE providerId = @ProviderId AND providerStatusId = 1;
        COMMIT TRANSACTION [trx_update_provider];

        SET @Mensaje = 'Proveedor actualizado con éxito';
        SET @Resultado = 200;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_Providers]
(
    @ProviderId INT NULL,
    @ProviderModificatorId INT NULL,
    @ProviderModificationDate DATETIME NULL,
    @Mensaje NVARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@ProviderModificationDate IS NULL)
            SET @ProviderModificationDate = GETDATE();

        IF (@ProviderId IS NULL)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Providers] 
        WHERE providerStatusId = 1 
        AND providerId = @ProviderId)
        BEGIN
            SET @Mensaje = 'No existe un registro o ya está eliminado';
            SET @Resultado = 400;
            RETURN;
        END
  
        BEGIN TRANSACTION [trx_delete_provider]
            UPDATE [SQM_CATALOGS].[Tbl_Providers]
            SET providerModificatorId = @ProviderModificatorId,
                providerModificationDate = @ProviderModificationDate,
                providerStatusId = 0
            WHERE providerId = @ProviderId AND providerStatusId = 1;
        COMMIT TRANSACTION [trx_delete_provider];

        SET @Mensaje = 'Proveedor eliminado con éxito';
        SET @Resultado = 200;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO
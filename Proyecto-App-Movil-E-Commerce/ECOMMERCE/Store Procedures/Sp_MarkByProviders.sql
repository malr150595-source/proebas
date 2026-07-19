USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_MarkByProviders]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        m.markByProviderId AS MacarporProveedorId,
        m.markByProviderMarkId AS MarcaporProveedorIdMarca,
        p.providerName AS NombreProvedor,
        m.markByProviderProviderId AS MarcaporProveedorIdProveedor,
        ms.markName AS markName,
        m.markByProviderCreatorId AS MarcaporProveedorIdCreador,
        m.markByProviderCreationDate AS MarcaporProveedorFechaCreacion,
        m.markByProviderModificatorId AS MarcaporProveedorIdModificador,
        m.markByProviderModificationDate AS MarcaporProveedorFechaModificacion -- CORREGIDO: Alias duplicado
    FROM [SQM_CATALOGS].[Tbl_MarkByProviders] AS m 
    INNER JOIN [SQM_CATALOGS].[Tbl_Providers] AS p ON p.providerId = m.markByProviderProviderId AND p.providerStatusId = 1
    INNER JOIN [SQM_CATALOGS].[Tbl_Marks] AS ms ON ms.markId = m.markByProviderMarkId
    WHERE m.markByProviderStatusId = 1 AND ms.markStatusId = 1
    ORDER BY m.markByProviderId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_list_MarkByProviders]
(
    @Filt NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        m.markByProviderId AS MacarporProveedorId,
        m.markByProviderMarkId AS MarcaporProveedorIdMarca,
        p.providerName AS NombreProvedor,
        m.markByProviderProviderId AS MarcaporProveedorIdProveedor,
        ms.markName AS markName,
        m.markByProviderCreatorId AS MarcaporProveedorIdCreador,
        m.markByProviderCreationDate AS MarcaporProveedorFechaCreacion,
        m.markByProviderModificatorId AS MarcaporProveedorIdModificador,
        m.markByProviderModificationDate AS MarcaporProveedorFechaModificacion -- CORREGIDO: Alias duplicado
    FROM [SQM_CATALOGS].[Tbl_MarkByProviders] AS m 
    INNER JOIN [SQM_CATALOGS].[Tbl_Providers] AS p ON p.providerId = m.markByProviderProviderId AND p.providerStatusId = 1
    INNER JOIN [SQM_CATALOGS].[Tbl_Marks] AS ms ON ms.markId = m.markByProviderMarkId AND ms.markStatusId = 1
    WHERE m.markByProviderStatusId = 1
      AND (
        p.providerName LIKE '%' + @Filt + '%' 
        OR ms.markName LIKE '%' + @Filt + '%'
        OR m.markByProviderId = TRY_CAST(@Filt AS INT)
      )
    ORDER BY m.markByProviderId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_MarkByProviders]
(
    @MarkByProviderMarkId INT NULL,
    @MarkByProviderProviderId INT NULL,
    @MarkByProviderCreatorId INT NULL,
    @MarkByProviderCreationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@MarkByProviderCreationDate IS NULL)
            SET @MarkByProviderCreationDate = GETDATE();

        IF (ISNULL(@MarkByProviderProviderId, 0) <= 0 OR ISNULL(@MarkByProviderMarkId, 0) <= 0)
        BEGIN 
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_MarkByProviders]
                  WHERE markByProviderProviderId = @MarkByProviderProviderId 
                    AND markByProviderMarkId = @MarkByProviderMarkId
                    AND markByProviderStatusId = 0)
        BEGIN 
            BEGIN TRANSACTION [trx_reactivation_MarkByProviders]
                UPDATE [SQM_CATALOGS].[Tbl_MarkByProviders]
                SET markByProviderStatusId = 1,
                    markByProviderModificatorId = @MarkByProviderCreatorId,
                    markByProviderModificationDate = @MarkByProviderCreationDate
                WHERE markByProviderMarkId = @MarkByProviderMarkId 
                  AND markByProviderStatusId = 0
                  AND markByProviderProviderId = @MarkByProviderProviderId;
            COMMIT TRANSACTION [trx_reactivation_MarkByProviders];

            SET @Mensaje = 'Ya existia, se volvio a activar ¡Revisa!';
            SET @Resultado = 200;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_insert_maskbyproviders]
                INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders] (
                    markByProviderMarkId,
                    markByProviderProviderId,
                    markByProviderCreatorId,
                    markByProviderCreationDate,
                    markByProviderStatusId
                )
                VALUES (
                    @MarkByProviderMarkId,
                    @MarkByProviderProviderId,
                    @MarkByProviderCreatorId,
                    @MarkByProviderCreationDate,
                    1
                );
            COMMIT TRANSACTION [trx_insert_maskbyproviders];

            SET @Mensaje = 'Datos ingresado exitosamente';
            SET @Resultado = 201;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al crear: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_MarkByProviders]
(
    @MarkByProviderId INT,
    @MarkByProviderMarkId INT NULL,
    @MarkByProviderProviderId INT NULL,
    @MarkByProviderModificatorId INT NULL,
    @MarkByProviderModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@MarkByProviderModificationDate IS NULL)
            SET @MarkByProviderModificationDate = GETDATE();

        IF (@MarkByProviderProviderId IS NULL OR @MarkByProviderMarkId IS NULL OR @MarkByProviderId IS NULL)
        BEGIN 
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_MarkByProviders]
                  WHERE markByProviderProviderId = @MarkByProviderProviderId 
                    AND markByProviderMarkId = @MarkByProviderMarkId
                    AND markByProviderStatusId = 1
                    AND markByProviderId <> @MarkByProviderId)
        BEGIN 
            SET @Mensaje = 'Ya existia un registro igual,¡Revisa!';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_update_maskbyproviders]
                UPDATE [SQM_CATALOGS].[Tbl_MarkByProviders]
                SET markByProviderMarkId = @MarkByProviderMarkId,
                    markByProviderProviderId = @MarkByProviderProviderId,
                    markByProviderModificatorId = @MarkByProviderModificatorId,
                    markByProviderModificationDate = @MarkByProviderModificationDate
                WHERE markByProviderId = @MarkByProviderId;
            COMMIT TRANSACTION [trx_update_maskbyproviders];

            SET @Mensaje = 'Datos actualizado exitosamente';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al actualizar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_MarkByProviders]
(
    @MarkByProviderId INT,
    @MarkByProviderModificatorId INT NULL,
    @MarkByProviderModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT -- CORREGIDO: De BIT a INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@MarkByProviderModificationDate IS NULL)
            SET @MarkByProviderModificationDate = GETDATE();

        IF (ISNULL(@MarkByProviderId,0) <= 0)
        BEGIN 
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_MarkByProviders]
                      WHERE markByProviderId = @MarkByProviderId AND markByProviderStatusId = 1)
        BEGIN 
            SET @Mensaje = 'Ese registro no existe,¡Revisa!';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_delete_maskbyproviders]
                UPDATE [SQM_CATALOGS].[Tbl_MarkByProviders]
                SET markByProviderStatusId = 0,
                    markByProviderModificatorId = @MarkByProviderModificatorId,
                    markByProviderModificationDate = @MarkByProviderModificationDate
                WHERE markByProviderId = @MarkByProviderId;
            COMMIT TRANSACTION [trx_delete_maskbyproviders];

            SET @Mensaje = 'Datos eliminado exitosamente';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al eliminar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO
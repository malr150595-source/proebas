USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_StockMovements]
(
    @stockMovementType INT = NULL,
    @stockMovementOrderId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        stockMovementId,
        stockMovementType,
        stockMovementOrderId,
        stockMovementReference,
        stockMovementDate,
        stockMovementCreatorId,
        stockMovementCreationDate,
        stockMovementModifierId,
        stockMovementModificationDate,
        stockMovementStatusId
    FROM [SQM_GENERAL].[Tbl_StockMovements]
    WHERE (@stockMovementType IS NULL OR stockMovementType = @stockMovementType)
      AND (@stockMovementOrderId IS NULL OR stockMovementOrderId = @stockMovementOrderId)
      AND stockMovementStatusId = 1
    ORDER BY stockMovementId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_StockMovements]
(
    @Filt VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FiltInt INT = TRY_CAST(@Filt AS INT);

    SELECT 
        stockMovementId,
        stockMovementType,
        stockMovementOrderId,
        stockMovementReference,
        stockMovementDate,
        stockMovementCreatorId,
        stockMovementCreationDate,
        stockMovementModifierId,
        stockMovementModificationDate,
        stockMovementStatusId
    FROM [SQM_GENERAL].[Tbl_StockMovements]
    WHERE stockMovementStatusId = 1
      AND (
            (@FiltInt IS NOT NULL AND stockMovementId = @FiltInt)
            OR stockMovementReference LIKE '%' + @Filt + '%'
          )
    ORDER BY stockMovementId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_StockMovements]
(
    @stockMovementType INT,
    @stockMovementOrderId INT = NULL,
    @stockMovementReference NVARCHAR(100) = NULL,
    @stockMovementDate DATETIME = NULL,
    @stockMovementCreatorId INT,
    @stockMovementStatusId INT,
    @stockMovementCreationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @stockMovementDate IS NULL SET @stockMovementDate = GETDATE();
        IF @stockMovementCreationDate IS NULL SET @stockMovementCreationDate = GETDATE();

        IF (@stockMovementType IS NULL OR @stockMovementCreatorId IS NULL OR @stockMovementStatusId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El tipo de movimiento, el usuario creador y el estado son parámetros obligatorios.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_StockMovementTypes] WHERE stockMovementTypeId = @stockMovementType)
        BEGIN
            SET @Mensaje = 'Error: El tipo de movimiento especificado no existe en el sistema.';
            SET @Resultado = 404;
            RETURN;
        END

        IF (@stockMovementOrderId IS NOT NULL)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_PaymentOrders] WHERE orderId = @stockMovementOrderId)
            BEGIN
                SET @Mensaje = 'Error: La orden de pago referenciada no existe.';
                SET @Resultado = 404;
                RETURN;
            END
        END

        BEGIN TRANSACTION [trx_insert_stock_movements];

        INSERT INTO [SQM_GENERAL].[Tbl_StockMovements]
        (
            stockMovementType,
            stockMovementOrderId,
            stockMovementReference,
            stockMovementDate,
            stockMovementCreatorId,
            stockMovementCreationDate,
            stockMovementModifierId,
            stockMovementModificationDate,
            stockMovementStatusId
        )
        VALUES
        (
            @stockMovementType,
            @stockMovementOrderId,
            TRIM(@stockMovementReference),
            @stockMovementDate,
            @stockMovementCreatorId,
            @stockMovementCreationDate,
            NULL,
            NULL,
            @stockMovementStatusId
        );

        COMMIT TRANSACTION [trx_insert_stock_movements];

        SET @Mensaje = 'Movimiento de stock registrado exitosamente.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al registrar el movimiento de stock: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_StockMovements]
(
    @stockMovementId INT,
    @stockMovementType INT,
    @stockMovementOrderId INT = NULL,
    @stockMovementReference NVARCHAR(100) = NULL,
    @stockMovementDate DATETIME,
    @stockMovementStatusId INT,
    @stockMovementModifierId INT,
    @stockMovementModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @stockMovementModificationDate IS NULL SET @stockMovementModificationDate = GETDATE();

        IF (@stockMovementId IS NULL OR @stockMovementType IS NULL OR @stockMovementDate IS NULL OR @stockMovementStatusId IS NULL OR @stockMovementModifierId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: Faltan parámetros obligatorios para actualizar el movimiento de stock.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_StockMovements] WHERE stockMovementId = @stockMovementId)
        BEGIN
            SET @Mensaje = 'Error: El movimiento de stock especificado no existe en el sistema.';
            SET @Resultado = 404;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_StockMovementTypes] WHERE stockMovementTypeId = @stockMovementType)
        BEGIN
            SET @Mensaje = 'Error: El tipo de movimiento especificado no existe.';
            SET @Resultado = 404;
            RETURN;
        END

        IF (@stockMovementOrderId IS NOT NULL)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_PaymentOrders] WHERE orderId = @stockMovementOrderId)
            BEGIN
                SET @Mensaje = 'Error: La orden de pago vinculada no existe.';
                SET @Resultado = 404;
                RETURN;
            END
        END

        BEGIN TRANSACTION [trx_update_stock_movements];

        UPDATE [SQM_GENERAL].[Tbl_StockMovements]
        SET 
            stockMovementType = @stockMovementType,
            stockMovementOrderId = @stockMovementOrderId,
            stockMovementReference = TRIM(@stockMovementReference),
            stockMovementDate = @stockMovementDate,
            stockMovementModifierId = @stockMovementModifierId,
            stockMovementModificationDate = @stockMovementModificationDate,
            stockMovementStatusId = @stockMovementStatusId
        WHERE stockMovementId = @stockMovementId;

        COMMIT TRANSACTION [trx_update_stock_movements];

        SET @Mensaje = 'Movimiento de stock actualizado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al actualizar el movimiento de stock: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_StockMovements]
(
    @stockMovementId INT,
    @stockMovementModifierId INT,
    @stockMovementModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @stockMovementModificationDate IS NULL SET @stockMovementModificationDate = GETDATE();

        IF (@stockMovementId IS NULL OR @stockMovementModifierId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID del movimiento y el usuario modificador son requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_StockMovements] WHERE stockMovementId = @stockMovementId AND stockMovementStatusId <> 0)
        BEGIN
            SET @Mensaje = 'Error: El movimiento de stock ya no se encuentra activo o fue descartado.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_stock_movements];

        UPDATE [SQM_GENERAL].[Tbl_StockMovements]
        SET 
            stockMovementStatusId = 0,
            stockMovementModifierId = @stockMovementModifierId,
            stockMovementModificationDate = @stockMovementModificationDate
        WHERE stockMovementId = @stockMovementId;

        COMMIT TRANSACTION [trx_delete_stock_movements];

        SET @Mensaje = 'Movimiento de stock removido correctamente.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al eliminar el movimiento de stock: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO
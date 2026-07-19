USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_StockMovementDetails]
(
    @stockMovementDetailMovementId INT = NULL,
    @stockMovementDetailStockId INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        stockMovementDetailId,
        stockMovementDetailMovementId,
        stockMovementDetailOrderDetailId,
        stockMovementDetailStockId,
        stockMovementDetailQuantity,
        stockMovementDetailFactoryDate,
        stockMovementDetailExpirationDate,
        stockMovementDetailCreatorId,
        stockMovementDetailCreationDate,
        stockMovementDetailModifierId,
        stockMovementDetailModificationDate,
        stockMovementDetailStatusId
    FROM [SQM_GENERAL].[Tbl_StockMovementDetails]
    WHERE (@stockMovementDetailMovementId IS NULL OR stockMovementDetailMovementId = @stockMovementDetailMovementId)
      AND (@stockMovementDetailStockId IS NULL OR stockMovementDetailStockId = @stockMovementDetailStockId)
      AND stockMovementDetailStatusId = 1
    ORDER BY stockMovementDetailId ASC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_StockMovementDetails]
(
    @Filt INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        stockMovementDetailId,
        stockMovementDetailMovementId,
        stockMovementDetailOrderDetailId,
        stockMovementDetailStockId,
        stockMovementDetailQuantity,
        stockMovementDetailFactoryDate,
        stockMovementDetailExpirationDate,
        stockMovementDetailCreatorId,
        stockMovementDetailCreationDate,
        stockMovementDetailModifierId,
        stockMovementDetailModificationDate,
        stockMovementDetailStatusId
    FROM [SQM_GENERAL].[Tbl_StockMovementDetails]
    WHERE stockMovementDetailStatusId = 1
      AND (
            stockMovementDetailId = @Filt 
            OR stockMovementDetailMovementId = @Filt 
            OR stockMovementDetailStockId = @Filt
          )
    ORDER BY stockMovementDetailId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_StockMovementDetails]
(
    @stockMovementDetailMovementId INT,
    @stockMovementDetailOrderDetailId INT = NULL,
    @stockMovementDetailStockId INT = NULL,
    @stockMovementDetailQuantity INT,
    @stockMovementDetailFactoryDate DATE = NULL,
    @stockMovementDetailExpirationDate DATE = NULL,
    @stockMovementDetailCreatorId INT,
    @stockMovementDetailCreationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @stockMovementDetailCreationDate IS NULL SET @stockMovementDetailCreationDate = GETDATE();

        IF (@stockMovementDetailMovementId IS NULL OR @stockMovementDetailQuantity IS NULL OR @stockMovementDetailCreatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID del movimiento, la cantidad y el creador son campos obligatorios.';
            SET @Resultado = 400;
            RETURN;
        END

        IF (@stockMovementDetailQuantity <= 0)
        BEGIN
            SET @Mensaje = 'Error: La cantidad del detalle de movimiento debe ser mayor a cero.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_StockMovements] WHERE stockMovementId = @stockMovementDetailMovementId)
        BEGIN
            SET @Mensaje = 'Error: El movimiento de inventario principal especificado no existe.';
            SET @Resultado = 404;
            RETURN;
        END

        IF (@stockMovementDetailOrderDetailId IS NOT NULL)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails] WHERE orderDetailId = @stockMovementDetailOrderDetailId)
            BEGIN
                SET @Mensaje = 'Error: El detalle de orden de pago referenciado no existe.';
                SET @Resultado = 404;
                RETURN;
            END
        END

        IF (@stockMovementDetailStockId IS NOT NULL)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Stocks] WHERE stockId = @stockMovementDetailStockId)
            BEGIN
                SET @Mensaje = 'Error: El registro de stock/inventario referenciado no existe.';
                SET @Resultado = 404;
                RETURN;
            END
        END

        BEGIN TRANSACTION [trx_insert_movement_details];

        INSERT INTO [SQM_GENERAL].[Tbl_StockMovementDetails]
        (
            stockMovementDetailMovementId,
            stockMovementDetailOrderDetailId,
            stockMovementDetailStockId,
            stockMovementDetailQuantity,
            stockMovementDetailFactoryDate,
            stockMovementDetailExpirationDate,
            stockMovementDetailCreatorId,
            stockMovementDetailCreationDate,
            stockMovementDetailModifierId,
            stockMovementDetailModificationDate,
            stockMovementDetailStatusId
        )
        VALUES
        (
            @stockMovementDetailMovementId,
            @stockMovementDetailOrderDetailId,
            @stockMovementDetailStockId,
            @stockMovementDetailQuantity,
            @stockMovementDetailFactoryDate,
            @stockMovementDetailExpirationDate,
            @stockMovementDetailCreatorId,
            @stockMovementDetailCreationDate,
            NULL,
            NULL,
            1
        );

        COMMIT TRANSACTION [trx_insert_movement_details];

        SET @Mensaje = 'Detalle de movimiento de stock registrado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al registrar detalle de movimiento: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_StockMovementDetails]
(
    @stockMovementDetailId INT,
    @stockMovementDetailQuantity INT,
    @stockMovementDetailFactoryDate DATE = NULL,
    @stockMovementDetailExpirationDate DATE = NULL,
    @stockMovementDetailModifierId INT,
    @stockMovementDetailModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @stockMovementDetailModificationDate IS NULL SET @stockMovementDetailModificationDate = GETDATE();

        IF (@stockMovementDetailId IS NULL OR @stockMovementDetailQuantity IS NULL OR @stockMovementDetailModifierId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID del detalle, la cantidad y el usuario modificador son requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        IF (@stockMovementDetailQuantity <= 0)
        BEGIN
            SET @Mensaje = 'Error: La cantidad de artículos debe ser mayor a cero.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_StockMovementDetails] WHERE stockMovementDetailId = @stockMovementDetailId AND stockMovementDetailStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El detalle de movimiento especificado no existe o se encuentra inactivo.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_update_movement_details];

        UPDATE [SQM_GENERAL].[Tbl_StockMovementDetails]
        SET 
            stockMovementDetailQuantity = @stockMovementDetailQuantity,
            stockMovementDetailFactoryDate = @stockMovementDetailFactoryDate,
            stockMovementDetailExpirationDate = @stockMovementDetailExpirationDate,
            stockMovementDetailModifierId = @stockMovementDetailModifierId,
            stockMovementDetailModificationDate = @stockMovementDetailModificationDate
        WHERE stockMovementDetailId = @stockMovementDetailId AND stockMovementDetailStatusId = 1;

        COMMIT TRANSACTION [trx_update_movement_details];

        SET @Mensaje = 'Detalle de movimiento de stock actualizado correctamente.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al actualizar detalle de movimiento: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_StockMovementDetails]
(
    @stockMovementDetailId INT,
    @stockMovementDetailModifierId INT,
    @stockMovementDetailModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @stockMovementDetailModificationDate IS NULL SET @stockMovementDetailModificationDate = GETDATE();

        IF (@stockMovementDetailId IS NULL OR @stockMovementDetailModifierId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID del detalle y el usuario modificador son obligatorios.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_StockMovementDetails] WHERE stockMovementDetailId = @stockMovementDetailId AND stockMovementDetailStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El detalle seleccionado no existe o ya fue descartado.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_movement_details];

        UPDATE [SQM_GENERAL].[Tbl_StockMovementDetails]
        SET 
            stockMovementDetailStatusId = 0,
            stockMovementDetailModifierId = @stockMovementDetailModifierId,
            stockMovementDetailModificationDate = @stockMovementDetailModificationDate
        WHERE stockMovementDetailId = @stockMovementDetailId AND stockMovementDetailStatusId = 1;

        COMMIT TRANSACTION [trx_delete_movement_details];

        SET @Mensaje = 'Detalle de movimiento de stock removido de forma lógica.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al eliminar detalle de movimiento: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO
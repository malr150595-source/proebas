USE DB_ECOMMERCE
GO

-- 1. LISTAR DETALLES DE UNA ÓRDEN ESPECÍFICA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_PaymentOrderDetails]
(
    @orderDetailOrderId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        orderDetailId,
        orderDetailOrderId,
        orderDetailProductVariableId,
        orderDetailPrice,
        orderDetailQuantity,
        orderDetailDiscount,
        orderDetailSubTotal,
        orderDetailTAX,
        orderDetailTotal,
        orderDetailCurrencyId,
        orderDetailCreatorId,
        orderDetailCreationDate,
        orderDetailModificatorId,
        orderDetailModificationDate,
        orderDetailStatusId
    FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails]
    WHERE orderDetailOrderId = @orderDetailOrderId 
      AND orderDetailStatusId = 1
    ORDER BY orderDetailId ASC;
END
GO

-- 2. FILTRAR / BUSCAR UN DETALLE DE ÓRDEN ESPECÍFICO (Por ID de Detalle o Producto)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_PaymentOrderDetails]
(
    @Filt INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        orderDetailId,
        orderDetailOrderId,
        orderDetailProductVariableId,
        orderDetailPrice,
        orderDetailQuantity,
        orderDetailDiscount,
        orderDetailSubTotal,
        orderDetailTAX,
        orderDetailTotal,
        orderDetailCurrencyId,
        orderDetailCreatorId,
        orderDetailCreationDate,
        orderDetailModificatorId,
        orderDetailModificationDate,
        orderDetailStatusId
    FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails]
    WHERE orderDetailStatusId = 1
      AND (
            orderDetailId = @Filt 
            OR orderDetailOrderId = @Filt 
            OR orderDetailProductVariableId = @Filt
          )
    ORDER BY orderDetailId DESC;
END
GO

-- 3. INSERTAR UN ARTÍCULO AL DETALLE DE LA ÓRDEN (CON CÁLCULOS AUTOMÁTICOS)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_PaymentOrderDetails]
(
    @orderDetailOrderId INT,
    @orderDetailProductVariableId INT,
    @orderDetailPrice DECIMAL(18,2),
    @orderDetailQuantity INT,
    @orderDetailDiscount DECIMAL(18,2) = 0.00,
    @orderDetailCurrencyId INT,
    @orderDetailCreatorId INT,
    @orderDetailCreationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Variables para el cálculo exacto de impuestos y totales
    DECLARE @CalculoSubTotal DECIMAL(18,2);
    DECLARE @CalculoTAX DECIMAL(18,2);
    DECLARE @CalculoTotal DECIMAL(18,2);
    DECLARE @PorcentajeIVA DECIMAL(5,2) = 0.15; -- Estandarizado al 15% de IVA local

    BEGIN TRY
        IF @orderDetailCreationDate IS NULL SET @orderDetailCreationDate = GETDATE();
        IF @orderDetailDiscount IS NULL SET @orderDetailDiscount = 0.00;

        -- 1. Validaciones de campos obligatorios (NOT NULL)
        IF (@orderDetailOrderId IS NULL OR @orderDetailProductVariableId IS NULL OR 
            @orderDetailPrice IS NULL OR @orderDetailQuantity IS NULL OR 
            @orderDetailCurrencyId IS NULL OR @orderDetailCreatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: Faltan parámetros obligatorios para registrar el artículo de la orden.';
            SET @Resultado = 400;
            RETURN;
        END

        IF (@orderDetailQuantity <= 0)
        BEGIN
            SET @Mensaje = 'Error: La cantidad solicitada del producto debe ser mayor a cero.';
            SET @Resultado = 400;
            RETURN;
        END

        -- 2. Validar que la orden principal exista en el sistema
        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_PaymentOrders] WHERE orderId = @orderDetailOrderId)
        BEGIN
            SET @Mensaje = 'Error: La orden de pago especificada no existe.';
            SET @Resultado = 404;
            RETURN;
        END

        -- 3. Fórmulas Matemáticas de Seguridad Financiera
        -- Subtotal = (Precio * Cantidad) - Descuento Directo
        SET @CalculoSubTotal = (@orderDetailPrice * @orderDetailQuantity) - @orderDetailDiscount;
        IF (@CalculoSubTotal < 0) SET @CalculoSubTotal = 0.00;
        
        SET @CalculoTAX   = @CalculoSubTotal * @PorcentajeIVA;
        SET @CalculoTotal = @CalculoSubTotal + @CalculoTAX;

        BEGIN TRANSACTION [trx_insert_order_details];

        INSERT INTO [SQM_GENERAL].[Tbl_PaymentOrderDetails]
        (
            orderDetailOrderId,
            orderDetailProductVariableId,
            orderDetailPrice,
            orderDetailQuantity,
            orderDetailDiscount,
            orderDetailSubTotal,
            orderDetailTAX,
            orderDetailTotal,
            orderDetailCurrencyId,
            orderDetailCreatorId,
            orderDetailCreationDate,
            orderDetailModificatorId,
            orderDetailModificationDate,
            orderDetailStatusId
        )
        VALUES
        (
            @orderDetailOrderId,
            @orderDetailProductVariableId,
            @orderDetailPrice,
            @orderDetailQuantity,
            @orderDetailDiscount,
            @CalculoSubTotal,
            @CalculoTAX,
            @CalculoTotal,
            @orderDetailCurrencyId,
            @orderDetailCreatorId,
            @orderDetailCreationDate,
            NULL,
            NULL,
            1 -- Estado Activo por defecto
        );

        COMMIT TRANSACTION [trx_insert_order_details];

        SET @Mensaje = 'Artículo agregado al detalle de la orden con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al insertar detalle de orden: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

-- 4. ACTUALIZAR CANTIDAD O DESCUENTO DE UN ARTÍCULO EN LA ÓRDEN
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_PaymentOrderDetails]
(
    @orderDetailId INT,
    @orderDetailQuantity INT,
    @orderDetailDiscount DECIMAL(18,2) = 0.00,
    @orderDetailModificatorId INT,
    @orderDetailModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @PrecioOriginal DECIMAL(18,2);
    DECLARE @CalculoSubTotal DECIMAL(18,2);
    DECLARE @CalculoTAX DECIMAL(18,2);
    DECLARE @CalculoTotal DECIMAL(18,2);
    DECLARE @PorcentajeIVA DECIMAL(5,2) = 0.15;

    BEGIN TRY
        IF @orderDetailModificationDate IS NULL SET @orderDetailModificationDate = GETDATE();
        IF @orderDetailDiscount IS NULL SET @orderDetailDiscount = 0.00;

        -- Validaciones base de parámetros de entrada
        IF (@orderDetailId IS NULL OR @orderDetailQuantity IS NULL OR @orderDetailModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID de detalle, cantidad y usuario modificador son obligatorios.';
            SET @Resultado = 400;
            RETURN;
        END

        IF (@orderDetailQuantity <= 0)
        BEGIN
            SET @Mensaje = 'Error: La cantidad de artículos debe ser mayor a cero.';
            SET @Resultado = 400;
            RETURN;
        END

        -- Buscar el registro activo y extraer el precio unitario pactado originalmente
        SELECT @PrecioOriginal = orderDetailPrice 
        FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails] 
        WHERE orderDetailId = @orderDetailId AND orderDetailStatusId = 1;

        IF (@PrecioOriginal IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El artículo de la orden no existe o ya fue removido.';
            SET @Resultado = 404;
            RETURN;
        END

        -- Recalcular la estructura económica de la línea con los nuevos valores de entrada
        SET @CalculoSubTotal = (@PrecioOriginal * @orderDetailQuantity) - @orderDetailDiscount;
        IF (@CalculoSubTotal < 0) SET @CalculoSubTotal = 0.00;
        
        SET @CalculoTAX   = @CalculoSubTotal * @PorcentajeIVA;
        SET @CalculoTotal = @CalculoSubTotal + @CalculoTAX;

        BEGIN TRANSACTION [trx_update_order_details];

        UPDATE [SQM_GENERAL].[Tbl_PaymentOrderDetails]
        SET 
            orderDetailQuantity = @orderDetailQuantity,
            orderDetailDiscount = @orderDetailDiscount,
            orderDetailSubTotal = @CalculoSubTotal,
            orderDetailTAX = @CalculoTAX,
            orderDetailTotal = @CalculoTotal,
            orderDetailModificatorId = @orderDetailModificatorId,
            orderDetailModificationDate = @orderDetailModificationDate
        WHERE orderDetailId = @orderDetailId AND orderDetailStatusId = 1;

        COMMIT TRANSACTION [trx_update_order_details];

        SET @Mensaje = 'Línea de detalle de orden actualizada y recalculada con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al actualizar detalle de orden: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

-- 5. ELIMINAR / REMOVER UN ARTÍCULO DEL DETALLE (BAJA LÓGICA)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_PaymentOrderDetails]
(
    @orderDetailId INT,
    @orderDetailModificatorId INT,
    @orderDetailModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @orderDetailModificationDate IS NULL SET @orderDetailModificationDate = GETDATE();

        IF (@orderDetailId IS NULL OR @orderDetailModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID del detalle y el usuario modificador son requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        -- Verificar si el elemento existe activo
        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_PaymentOrderDetails] WHERE orderDetailId = @orderDetailId AND orderDetailStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El artículo seleccionado no existe en la orden o ya fue descartado.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_order_details];

        UPDATE [SQM_GENERAL].[Tbl_PaymentOrderDetails]
        SET 
            orderDetailStatusId = 0,
            orderDetailModificatorId = @orderDetailModificatorId,
            orderDetailModificationDate = @orderDetailModificationDate
        WHERE orderDetailId = @orderDetailId AND orderDetailStatusId = 1;

        COMMIT TRANSACTION [trx_delete_order_details];

        SET @Mensaje = 'Artículo removido del detalle de la orden correctamente.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al eliminar detalle de orden: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO
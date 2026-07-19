USE DB_ECOMMERCE
GO

-- 1. LISTAR TODAS LAS ÓRDENES (General o por Usuario si se requiere en el Backend)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_PaymentOrders]
(
    @orderUserId INT = NULL -- Opcional: Si se pasa, filtra solo las órdenes de ese cliente
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        O.orderId,
        O.orderUserId,
        O.orderDeliveryAddress,
        O.orderPaymentMethodId,
        O.orderSubtotal,
        O.orderDiscount,
        O.orderShipping,
        O.orderTAX,
        O.orderTotal,
        O.orderCurrencyId,
        O.orderCreatorId,
        O.orderCreationDate,
        O.orderModificatorId,
        O.orderModificationDate,
        O.orderStatusId
    FROM [SQM_GENERAL].[Tbl_PaymentOrders] O
    WHERE (@orderUserId IS NULL OR O.orderUserId = @orderUserId)
    ORDER BY O.orderId DESC; -- Las más recientes primero
END
GO

-- 2. FILTRAR / OBTENER UNA ÓRDEN ESPECÍFICA POR ID
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_PaymentOrders]
(
    @Filt INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        orderId,
        orderUserId,
        orderDeliveryAddress,
        orderPaymentMethodId,
        orderSubtotal,
        orderDiscount,
        orderShipping,
        orderTAX,
        orderTotal,
        orderCurrencyId,
        orderCreatorId,
        orderCreationDate,
        orderModificatorId,
        orderModificationDate,
        orderStatusId
    FROM [SQM_GENERAL].[Tbl_PaymentOrders]
    WHERE orderId = @Filt
    ORDER BY orderId DESC;
END
GO

-- 3. INSERTAR UNA NUEVA ÓRDEN DE PAGO (CON CÁLCULOS AUTOMÁTICOS DE SEGURIDAD)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_PaymentOrders]
(
    @orderUserId INT,
    @orderDeliveryAddress INT,
    @orderPaymentMethodId INT,
    @orderSubtotal DECIMAL(18,2),
    @orderDiscount DECIMAL(18,2) = 0.00,
    @orderShipping DECIMAL(18,2) = 0.00,
    @orderCurrencyId INT,
    @orderCreatorId INT,
    @orderStatusId INT, -- Normalmente iniciará con el ID de 'Pendiente de Pago' o 'Procesando'
    @orderCreationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Variables para el cálculo exacto en base de datos
    DECLARE @CalculoTAX DECIMAL(18,2);
    DECLARE @CalculoTotal DECIMAL(18,2);
    DECLARE @PorcentajeIVA DECIMAL(5,2) = 0.15; -- Supongamos 15% de impuesto (ajustar si varía)

    BEGIN TRY
        IF @orderCreationDate IS NULL SET @orderCreationDate = GETDATE();
        IF @orderDiscount IS NULL SET @orderDiscount = 0.00;
        IF @orderShipping IS NULL SET @orderShipping = 0.00;

        -- 1. Validaciones de campos obligatorios (NOT NULL)
        IF (@orderUserId IS NULL OR @orderDeliveryAddress IS NULL OR @orderPaymentMethodId IS NULL OR 
            @orderSubtotal IS NULL OR @orderCurrencyId IS NULL OR @orderCreatorId IS NULL OR @orderStatusId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: Faltan parámetros obligatorios para registrar la orden de pago.';
            SET @Resultado = 400;
            RETURN;
        END

        IF (@orderSubtotal < 0)
        BEGIN
            SET @Mensaje = 'Error: El subtotal de la orden no puede ser un valor negativo.';
            SET @Resultado = 400;
            RETURN;
        END

        -- 2. Recalcular Totales de Forma Segura en el Servidor
        -- Formula: Total = (Subtotal - Descuento) + Envío + Impuestos de ese neto anterior
        DECLARE @NetoGravable DECIMAL(18,2) = @orderSubtotal - @orderDiscount;
        IF (@NetoGravable < 0) SET @NetoGravable = 0.00;

        SET @CalculoTAX   = @NetoGravable * @PorcentajeIVA;
        SET @CalculoTotal = @NetoGravable + @orderShipping + @CalculoTAX;

        BEGIN TRANSACTION [trx_insert_orders];

        INSERT INTO [SQM_GENERAL].[Tbl_PaymentOrders]
        (
            orderUserId,
            orderDeliveryAddress,
            orderPaymentMethodId,
            orderSubtotal,
            orderDiscount,
            orderShipping,
            orderTAX,
            orderTotal,
            orderCurrencyId,
            orderCreatorId,
            orderCreationDate,
            orderModificatorId,
            orderModificationDate,
            orderStatusId
        )
        VALUES
        (
            @orderUserId,
            @orderDeliveryAddress,
            @orderPaymentMethodId,
            @orderSubtotal,
            @orderDiscount,
            @orderShipping,
            @CalculoTAX,    -- Grabamos el impuesto calculado por la BD
            @CalculoTotal,  -- Grabamos el total calculado por la BD
            @orderCurrencyId,
            @orderCreatorId,
            @orderCreationDate,
            NULL,
            NULL,
            @orderStatusId
        );

        COMMIT TRANSACTION [trx_insert_orders];

        SET @Mensaje = 'Orden de pago registrada exitosamente.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al registrar la orden: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

-- 4. ACTUALIZAR INFORMACIÓN DE LA ÓRDEN (Dirección, Envío o Montos si hay cambios)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_PaymentOrders]
(
    @orderId INT,
    @orderDeliveryAddress INT,
    @orderShipping DECIMAL(18,2),
    @orderStatusId INT,
    @orderModificatorId INT,
    @orderModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @SubtotalOriginal DECIMAL(18,2);
    DECLARE @DiscountOriginal DECIMAL(18,2);
    DECLARE @CalculoTAX DECIMAL(18,2);
    DECLARE @CalculoTotal DECIMAL(18,2);
    DECLARE @PorcentajeIVA DECIMAL(5,2) = 0.15;

    BEGIN TRY
        IF @orderModificationDate IS NULL SET @orderModificationDate = GETDATE();

        -- Validaciones de parámetros de entrada
        IF (@orderId IS NULL OR @orderDeliveryAddress IS NULL OR @orderShipping IS NULL OR @orderStatusId IS NULL OR @orderModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: Faltan parámetros obligatorios para actualizar la orden.';
            SET @Resultado = 400;
            RETURN;
        END

        -- Verificar que la orden exista
        SELECT 
            @SubtotalOriginal = orderSubtotal, 
            @DiscountOriginal = orderDiscount 
        FROM [SQM_GENERAL].[Tbl_PaymentOrders] 
        WHERE orderId = @orderId;

        IF (@SubtotalOriginal IS NULL)
        BEGIN
            SET @Mensaje = 'Error: La orden especificada no existe en el sistema.';
            SET @Resultado = 404;
            RETURN;
        END

        -- Volver a calcular totales integrando el nuevo costo de envío
        DECLARE @NetoGravable DECIMAL(18,2) = @SubtotalOriginal - @DiscountOriginal;
        IF (@NetoGravable < 0) SET @NetoGravable = 0.00;

        SET @CalculoTAX   = @NetoGravable * @PorcentajeIVA;
        SET @CalculoTotal = @NetoGravable + @orderShipping + @CalculoTAX;

        BEGIN TRANSACTION [trx_update_orders];

        UPDATE [SQM_GENERAL].[Tbl_PaymentOrders]
        SET 
            orderDeliveryAddress = @orderDeliveryAddress,
            orderShipping = @orderShipping,
            orderTAX = @CalculoTAX,
            orderTotal = @CalculoTotal,
            orderStatusId = @orderStatusId,
            orderModificatorId = @orderModificatorId,
            orderModificationDate = @orderModificationDate
        WHERE orderId = @orderId;

        COMMIT TRANSACTION [trx_update_orders];

        SET @Mensaje = 'Orden de pago actualizada con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al actualizar la orden: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

-- 5. CAMBIAR ÚNICAMENTE EL ESTADO DE LA ÓRDEN (Flujo de venta: de Pendiente a Pagada, etc.)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_OrderStatus]
(
    @orderId INT,
    @orderStatusId INT, -- Nuevo ID de estado del catálogo (ej: Entregado, Cancelado, etc.)
    @orderModificatorId INT,
    @orderModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @orderModificationDate IS NULL SET @orderModificationDate = GETDATE();

        IF (@orderId IS NULL OR @orderStatusId IS NULL OR @orderModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: ID de orden, nuevo estado y usuario modificador son requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        -- Verificar que la orden exista
        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_PaymentOrders] WHERE orderId = @orderId)
        BEGIN
            SET @Mensaje = 'Error: La orden de pago seleccionada no existe.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_update_order_status];

        UPDATE [SQM_GENERAL].[Tbl_PaymentOrders]
        SET 
            orderStatusId = @orderStatusId,
            orderModificatorId = @orderModificatorId,
            orderModificationDate = @orderModificationDate
        WHERE orderId = @orderId;

        COMMIT TRANSACTION [trx_update_order_status];

        SET @Mensaje = 'Estado de la orden actualizado exitosamente.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al cambiar el estado de la orden: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO
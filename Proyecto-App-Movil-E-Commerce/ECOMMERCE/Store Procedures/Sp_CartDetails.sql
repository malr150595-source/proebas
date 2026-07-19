USE DB_ECOMMERCE
GO

-- 1. LISTAR DETALLES DE UN CARRITO ESPECÍFICO (Con INNER JOIN)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_CartDetails]
(
    @cartDetailCartId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        cd.cartDetailId,
        cd.cartDetailCartId,
        cd.cartDetailProductVariableId,
        pv.productVariableValue AS [productVariableValueRef], -- Campo del INNER JOIN
        cd.cartDetailPrice,
        cd.cartDetailQuantity,
        cd.cartDetailDiscount,
        cd.cartDetailSubTotal,
        cd.cartDetailTAX,
        cd.cartDetailTotal,
        cd.cartDetailCurrencyId,
        curr.currencyName AS [currencyNameRef],                 -- Campo del INNER JOIN
        cd.cartDetailCreatorId,
        cd.cartDetailCreationDate,
        cd.cartDetailModificatorId,
        cd.cartDetailModificationDate
    FROM [SQM_GENERAL].[Tbl_CartDetails] cd
    INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] pv ON cd.cartDetailProductVariableId = pv.productVariableId
    INNER JOIN [SQM_GENERAL].[Tbl_Currencies] curr ON cd.cartDetailCurrencyId = curr.currencyId
    WHERE cd.cartDetailCartId = @cartDetailCartId 
      AND cd.cartDetailStatusId = 1
    ORDER BY cd.cartDetailId ASC;
END;
GO

-- 2. FILTRAR O BUSCAR UN ÍTEM ESPECÍFICO DENTRO DE LOS CARRITOS
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_CartDetails]
(
    @Filt INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        cd.cartDetailId,
        cd.cartDetailCartId,
        cd.cartDetailProductVariableId,
        pv.productVariableValue AS [productVariableValueRef], -- Campo del INNER JOIN
        cd.cartDetailPrice,
        cd.cartDetailQuantity,
        cd.cartDetailDiscount,
        cd.cartDetailSubTotal,
        cd.cartDetailTAX,
        cd.cartDetailTotal,
        cd.cartDetailCurrencyId,
        curr.currencyName AS [currencyNameRef],                 -- Campo del INNER JOIN
        cd.cartDetailCreatorId,
        cd.cartDetailCreationDate,
        cd.cartDetailModificatorId,
        cd.cartDetailModificationDate
    FROM [SQM_GENERAL].[Tbl_CartDetails] cd
    INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] pv ON cd.cartDetailProductVariableId = pv.productVariableId
    INNER JOIN [SQM_GENERAL].[Tbl_Currencies] curr ON cd.cartDetailCurrencyId = curr.currencyId
    WHERE cd.cartDetailStatusId = 1
      AND (
            cd.cartDetailId = @Filt 
            OR cd.cartDetailCartId = @Filt 
            OR cd.cartDetailProductVariableId = @Filt
          )
    ORDER BY cd.cartDetailId DESC;
END;
GO

-- 3. INSERTAR ÍTEM AL CARRITO (CON CÁLCULOS AUTOMÁTICOS INTEGRADOS)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_CartDetails]
(
    @cartDetailCartId INT,
    @cartDetailProductVariableId INT,
    @cartDetailPrice DECIMAL(18,2),
    @cartDetailQuantity INT,
    @cartDetailDiscount DECIMAL(18,2) = 0.00,
    @cartDetailCurrencyId INT,
    @cartDetailCreatorId INT,
    @cartDetailCreationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @CalculoSubTotal DECIMAL(18,2);
    DECLARE @CalculoTAX DECIMAL(18,2);
    DECLARE @CalculoTotal DECIMAL(18,2);
    DECLARE @PorcentajeIVA DECIMAL(5,2) = 0.15; 

    BEGIN TRY
        IF @cartDetailCreationDate IS NULL SET @cartDetailCreationDate = GETDATE();
        IF @cartDetailDiscount IS NULL SET @cartDetailDiscount = 0.00;

        IF (@cartDetailCartId IS NULL OR @cartDetailProductVariableId IS NULL OR @cartDetailPrice IS NULL OR @cartDetailQuantity IS NULL OR @cartDetailCurrencyId IS NULL OR @cartDetailCreatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: Faltan datos obligatorios para registrar el detalle del carrito.';
            SET @Resultado = 400;
            RETURN;
        END

        IF (@cartDetailQuantity <= 0)
        BEGIN
            SET @Mensaje = 'Error: La cantidad de productos debe ser mayor a cero.';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_CartDetails] WHERE cartDetailCartId = @cartDetailCartId AND cartDetailProductVariableId = @cartDetailProductVariableId AND cartDetailStatusId = 1)
        BEGIN
            SET @Mensaje = 'Advertencia: El producto ya se encuentra en el carrito. Utilice actualizar cantidad.';
            SET @Resultado = 400;
            RETURN;
        END

        SET @CalculoSubTotal = (@cartDetailPrice * @cartDetailQuantity) - @cartDetailDiscount;
        SET @CalculoTAX      = @CalculoSubTotal * @PorcentajeIVA;
        SET @CalculoTotal    = @CalculoSubTotal + @CalculoTAX;

        BEGIN TRANSACTION [trx_insert_cartdetails];

        INSERT INTO [SQM_GENERAL].[Tbl_CartDetails]
        (
            cartDetailCartId,
            cartDetailProductVariableId,
            cartDetailPrice,
            cartDetailQuantity,
            cartDetailDiscount,
            cartDetailSubTotal,
            cartDetailTAX,
            cartDetailTotal,
            cartDetailCurrencyId,
            cartDetailCreatorId,
            cartDetailCreationDate,
            cartDetailModificatorId,
            cartDetailModificationDate,
            cartDetailStatusId
        )
        VALUES
        (
            @cartDetailCartId,
            @cartDetailProductVariableId,
            @cartDetailPrice,
            @cartDetailQuantity,
            @cartDetailDiscount,
            @CalculoSubTotal,
            @CalculoTAX,
            @CalculoTotal,
            @cartDetailCurrencyId,
            @cartDetailCreatorId,
            @cartDetailCreationDate,
            NULL,
            NULL,
            1
        );

        COMMIT TRANSACTION [trx_insert_cartdetails];

        SET @Mensaje = 'Producto agregado al carrito exitosamente.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al insertar detalle: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 4. ACTUALIZAR CANTIDAD O DESCUENTO DE UN ÍTEM EN EL CARRITO
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_CartDetails]
(
    @cartDetailId INT,
    @cartDetailQuantity INT,
    @cartDetailDiscount DECIMAL(18,2) = 0.00,
    @cartDetailModificatorId INT,
    @cartDetailModificationDate DATETIME = NULL,
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
        IF @cartDetailModificationDate IS NULL SET @cartDetailModificationDate = GETDATE();
        IF @cartDetailDiscount IS NULL SET @cartDetailDiscount = 0.00;

        IF (@cartDetailId IS NULL OR @cartDetailQuantity IS NULL OR @cartDetailModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: ID del detalle, cantidad y modificador son requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        IF (@cartDetailQuantity <= 0)
        BEGIN
            SET @Mensaje = 'Error: La cantidad debe ser mayor a cero.';
            SET @Resultado = 400;
            RETURN;
        END

        SELECT @PrecioOriginal = cartDetailPrice 
        FROM [SQM_GENERAL].[Tbl_CartDetails] 
        WHERE cartDetailId = @cartDetailId AND cartDetailStatusId = 1;

        IF (@PrecioOriginal IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ítem del carrito no existe o ya fue eliminado.';
            SET @Resultado = 404;
            RETURN;
        END

        SET @CalculoSubTotal = (@PrecioOriginal * @cartDetailQuantity) - @cartDetailDiscount;
        SET @CalculoTAX      = @CalculoSubTotal * @PorcentajeIVA;
        SET @CalculoTotal    = @CalculoSubTotal + @CalculoTAX;

        BEGIN TRANSACTION [trx_update_cartdetails];

        UPDATE [SQM_GENERAL].[Tbl_CartDetails]
        SET 
            cartDetailQuantity = @cartDetailQuantity,
            cartDetailDiscount = @cartDetailDiscount,
            cartDetailSubTotal = @CalculoSubTotal,
            cartDetailTAX = @CalculoTAX,
            cartDetailTotal = @CalculoTotal,
            cartDetailModificatorId = @cartDetailModificatorId,
            cartDetailModificationDate = @cartDetailModificationDate
        WHERE cartDetailId = @cartDetailId AND cartDetailStatusId = 1;

        COMMIT TRANSACTION [trx_update_cartdetails];

        SET @Mensaje = 'Cantidad y totales del carrito actualizados.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al actualizar detalle: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 5. QUITAR / ELIMINAR UN ÍTEM DEL CARRITO (BAJA LÓGICA)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_CartDetails]
(
    @cartDetailId INT,
    @cartDetailModificatorId INT,
    @cartDetailModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @cartDetailModificationDate IS NULL SET @cartDetailModificationDate = GETDATE();

        IF (@cartDetailId IS NULL OR @cartDetailModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: ID del detalle y usuario modificador requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_CartDetails] WHERE cartDetailId = @cartDetailId AND cartDetailStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El elemento no existe en el carrito o ya fue removido.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_cartdetails];

        UPDATE [SQM_GENERAL].[Tbl_CartDetails]
        SET 
            cartDetailStatusId = 0,
            cartDetailModificatorId = @cartDetailModificatorId,
            cartDetailModificationDate = @cartDetailModificationDate
        WHERE cartDetailId = @cartDetailId AND cartDetailStatusId = 1;

        COMMIT TRANSACTION [trx_delete_cartdetails];

        SET @Mensaje = 'Producto removido del carrito con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al eliminar detalle: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO
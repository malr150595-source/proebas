USE DB_ECOMMERCE
GO

CREATE OR ALTER FUNCTION [SQM_GENERAL].[Fn_Validar_Stock](
    @ProductVariableID INT,
    @CantidadRequerida INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @StockActual INT;
    DECLARE @TieneStock BIT;

    -- Sumamos el stock disponible total de la variante de producto activa
    SELECT @StockActual = ISNULL(SUM(stockQuantity), 0)
    FROM [SQM_GENERAL].[Tbl_Stocks] 
    WHERE stockProductVariableId = @ProductVariableID
      AND stockStatusId = 1;

    IF @StockActual >= @CantidadRequerida
        SET @TieneStock = 1;
    ELSE
        SET @TieneStock = 0;

    RETURN @TieneStock;
END;
GO
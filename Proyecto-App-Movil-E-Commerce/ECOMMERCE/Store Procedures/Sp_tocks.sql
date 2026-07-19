USE DB_ECOMMERCE
GO

-- 1. LISTADO (Con INNER JOIN para ver el nombre/valor de la variante)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_Stocks]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        s.stockId AS [stockId],
        s.stockProductVariableId AS [stockProductVariableId],
        pv.productVariableValue AS [productVariableValueRef], -- Campo del INNER JOIN
        s.stockQuantity AS [stockQuantity],
        s.stockFactoryDate AS [stockFactoryDate],
        s.stockExpirationDate AS [stockExpirationDate],
        s.stockCreatorId AS [stockCreatorId],
        s.stockCreationDate AS [stockCreationDate],
        s.stockModificatorId AS [stockModificatorId],
        s.stockModificationDate AS [stockModificationDate]
    FROM [SQM_GENERAL].[Tbl_Stocks] s
    INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] pv ON s.stockProductVariableId = pv.productVariableId
    WHERE s.stockStatusId = 1
    ORDER BY s.stockId DESC;
END;
GO

-- 2. FILTRADO / BÚSQUEDA
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_Stocks](
    @Filt VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        s.stockId AS [stockId],
        s.stockProductVariableId AS [stockProductVariableId],
        pv.productVariableValue AS [productVariableValueRef], -- Campo del INNER JOIN
        s.stockQuantity AS [stockQuantity],
        s.stockFactoryDate AS [stockFactoryDate],
        s.stockExpirationDate AS [stockExpirationDate],
        s.stockCreatorId AS [stockCreatorId],
        s.stockCreationDate AS [stockCreationDate],
        s.stockModificatorId AS [stockModificatorId],
        s.stockModificationDate AS [stockModificationDate]
    FROM [SQM_GENERAL].[Tbl_Stocks] s
    INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] pv ON s.stockProductVariableId = pv.productVariableId
    WHERE s.stockStatusId = 1
      AND (
           pv.productVariableValue LIKE '%' + @Filt + '%'
           OR (s.stockId = TRY_CAST(@Filt AS INT))
           OR (s.stockProductVariableId = TRY_CAST(@Filt AS INT))
           OR (s.stockQuantity = TRY_CAST(@Filt AS INT))
          )
    ORDER BY s.stockId DESC;
END;
GO

-- 3. INSERCIÓN (Con Reactivación Automática y Control de Lotes por Fecha)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_Stocks](
    @stockProductVariableId INT NULL,
    @stockQuantity INT NULL,
    @stockFactoryDate DATE NULL,
    @stockExpirationDate DATE NULL,
    @stockCreatorId INT NULL,
    @stockCreationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@stockCreationDate IS NULL)
        BEGIN
            SET @stockCreationDate = GETDATE();
        END
 
        -- Validaciones de Campos Obligatorios
        IF(ISNULL(@stockProductVariableId, 0) <= 0 
           OR @stockQuantity IS NULL 
           OR @stockFactoryDate IS NULL 
           OR @stockExpirationDate IS NULL
           OR ISNULL(@stockCreatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios o los IDs numéricos son incorrectos';
            SET @Resultado = 400;
            RETURN;
        END

        -- Validación de negocio básica para las fechas
        IF(@stockFactoryDate > @stockExpirationDate)
        BEGIN
            SET @Mensaje = 'La fecha de fabricación no puede ser mayor a la fecha de vencimiento';
            SET @Resultado = 400;
            RETURN;
        END

        -- Comprobar si ya existe un stock idéntico activo para la misma variante y lote de fecha
        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_Stocks]
                  WHERE stockProductVariableId = @stockProductVariableId
                    AND stockFactoryDate = @stockFactoryDate
                    AND stockExpirationDate = @stockExpirationDate
                    AND stockStatusId = 1)
        BEGIN
            SET @Mensaje = 'Ya existe un lote activo registrado con estas mismas fechas para esta variante';
            SET @Resultado = 400;
            RETURN;
        END

        -- Reactivación automática si existía inactivo con las mismas especificaciones de lote
        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_Stocks]
                  WHERE stockProductVariableId = @stockProductVariableId
                    AND stockFactoryDate = @stockFactoryDate
                    AND stockExpirationDate = @stockExpirationDate
                    AND stockStatusId = 0)
        BEGIN
            BEGIN TRANSACTION [trx_reactivate_stock]
                UPDATE [SQM_GENERAL].[Tbl_Stocks]
                SET stockQuantity = @stockQuantity, -- Actualiza la cantidad con la nueva ingresada
                    stockStatusId = 1,
                    stockModificatorId = @stockCreatorId,
                    stockModificationDate = @stockCreationDate
                WHERE stockProductVariableId = @stockProductVariableId 
                  AND stockFactoryDate = @stockFactoryDate
                  AND stockExpirationDate = @stockExpirationDate
                  AND stockStatusId = 0;
            COMMIT TRANSACTION [trx_reactivate_stock];
            SET @Mensaje = 'El registro de stock existía de forma inactiva (mismo lote), se reactivó y actualizó su cantidad';
            SET @Resultado = 201;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_insert_stock]
                INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (
                    stockProductVariableId,
                    stockQuantity,
                    stockFactoryDate,
                    stockExpirationDate,
                    stockCreatorId,
                    stockCreationDate,
                    stockStatusId
                )
                VALUES (
                    @stockProductVariableId,
                    @stockQuantity,
                    @stockFactoryDate,
                    @stockExpirationDate,
                    @stockCreatorId,
                    @stockCreationDate,
                    1
                );
            COMMIT TRANSACTION [trx_insert_stock];
            SET @Mensaje = 'Stock ingresado con éxito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN 
            ROLLBACK TRANSACTION;
        END
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 4. ACTUALIZACIÓN (Validación contra terceros)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_Stocks](
    @stockId INT,
    @stockProductVariableId INT NULL,
    @stockQuantity INT NULL,
    @stockFactoryDate DATE NULL,
    @stockExpirationDate DATE NULL,
    @stockModificatorId INT NULL,
    @stockModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@stockModificationDate IS NULL)
        BEGIN
            SET @stockModificationDate = GETDATE();
        END

        IF(ISNULL(@stockId, 0) <= 0
           OR ISNULL(@stockProductVariableId, 0) <= 0
           OR @stockQuantity IS NULL
           OR @stockFactoryDate IS NULL
           OR @stockExpirationDate IS NULL
           OR ISNULL(@stockModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios o los IDs numéricos son incorrectos';
            SET @Resultado = 400;
            RETURN;
        END

        -- Evitar duplicados de lote en otros registros activos al actualizar
        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_Stocks]
                  WHERE stockProductVariableId = @stockProductVariableId
                    AND stockFactoryDate = @stockFactoryDate
                    AND stockExpirationDate = @stockExpirationDate
                    AND stockStatusId = 1 
                    AND stockId <> @stockId)
        BEGIN
            SET @Mensaje = 'Las especificaciones de este lote ya pertenecen a otro registro de stock activo ¡Revise!';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_update_stock]
                UPDATE [SQM_GENERAL].[Tbl_Stocks]
                SET stockProductVariableId = @stockProductVariableId,
                    stockQuantity = @stockQuantity,
                    stockFactoryDate = @stockFactoryDate,
                    stockExpirationDate = @stockExpirationDate,
                    stockModificatorId = @stockModificatorId,
                    stockModificationDate = @stockModificationDate,
                    stockStatusId = 1
                WHERE stockId = @stockId;
            COMMIT TRANSACTION [trx_update_stock];
            SET @Mensaje = 'Registro de stock actualizado con éxito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 5. ELIMINACIÓN (Borrado Lógico)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_Stocks](
    @stockId INT,
    @stockModificatorId INT NULL,
    @stockModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@stockModificationDate IS NULL)
        BEGIN
            SET @stockModificationDate = GETDATE();
        END

        IF(ISNULL(@stockId, 0) <= 0 OR ISNULL(@stockModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Los datos numéricos no pueden ser menores o iguales a 0';
            SET @Resultado = 400;
            RETURN;
        END
 
        IF NOT EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_Stocks]
                      WHERE stockId = @stockId AND stockStatusId = 1)
        BEGIN
            SET @Mensaje = 'El registro no existe o ya está inactivo';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_delete_stock]
                UPDATE [SQM_GENERAL].[Tbl_Stocks]
                SET stockModificatorId = @stockModificatorId,
                    stockModificationDate = @stockModificationDate,
                    stockStatusId = 0
                WHERE stockId = @stockId;
            COMMIT TRANSACTION [trx_delete_stock];
            SET @Mensaje = 'Registro de stock eliminado con éxito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO
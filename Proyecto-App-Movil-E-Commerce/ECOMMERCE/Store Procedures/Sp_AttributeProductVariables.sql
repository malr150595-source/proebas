USE DB_ECOMMERCE
GO

-- 1. LISTADO (Con INNER JOIN para nombres amigables)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_AttributeProductVariables]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        apv.attributeProductVariableId AS [attributeProductVariableId],
        apv.attributeProductVariableProductVariableId AS [attributeProductVariableProductVariableId],
        pv.productVariableValue AS [productVariableValueRef], -- Del INNER JOIN (ej: "Camiseta L")
        apv.attributeProductVariableAttributeProductId AS [attributeProductVariableAttributeProductId],
        attr.attributeProductName AS [attributeProductName],   -- Del INNER JOIN (ej: "Talla" o "Color")
        apv.attributeProductVariableValue AS [attributeProductVariableValue],
        apv.attributeProductVariableCreatorId AS [attributeProductVariableCreatorId],
        apv.attributeProductVariableCreationDate AS [attributeProductVariableCreationDate],
        apv.attributeProductVariableModificatorId AS [attributeProductVariableModificatorId],
        apv.attributeProductVariableModificationDate AS [attributeProductVariableModificationDate]
    FROM [SQM_GENERAL].[Tbl_AttributeProductVariables] apv
    INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] pv ON apv.attributeProductVariableProductVariableId = pv.productVariableId
    INNER JOIN [SQM_GENERAL].[Tbl_AttributeProducts] attr ON apv.attributeProductVariableAttributeProductId = attr.attributeProductId
    WHERE apv.attributeProductVariableStatusId = 1
    ORDER BY apv.attributeProductVariableId DESC;
END;
GO

-- 2. FILTRADO / BÚSQUEDA (Con INNER JOIN y soporte de búsqueda por texto extendido)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_AttributeProductVariables](
    @Filt VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        apv.attributeProductVariableId AS [attributeProductVariableId],
        apv.attributeProductVariableProductVariableId AS [attributeProductVariableProductVariableId],
        pv.productVariableValue AS [productVariableValueRef],
        apv.attributeProductVariableAttributeProductId AS [attributeProductVariableAttributeProductId],
        attr.attributeProductName AS [attributeProductName],
        apv.attributeProductVariableValue AS [attributeProductVariableValue],
        apv.attributeProductVariableCreatorId AS [attributeProductVariableCreatorId],
        apv.attributeProductVariableCreationDate AS [attributeProductVariableCreationDate],
        apv.attributeProductVariableModificatorId AS [attributeProductVariableModificatorId],
        apv.attributeProductVariableModificationDate AS [attributeProductVariableModificationDate]
    FROM [SQM_GENERAL].[Tbl_AttributeProductVariables] apv
    INNER JOIN [SQM_GENERAL].[Tbl_ProductVariables] pv ON apv.attributeProductVariableProductVariableId = pv.productVariableId
    INNER JOIN [SQM_GENERAL].[Tbl_AttributeProducts] attr ON apv.attributeProductVariableAttributeProductId = attr.attributeProductId
    WHERE apv.attributeProductVariableStatusId = 1
      AND (
           apv.attributeProductVariableValue LIKE '%' + @Filt + '%' 
           OR pv.productVariableValue LIKE '%' + @Filt + '%'
           OR attr.attributeProductName LIKE '%' + @Filt + '%'
           OR (apv.attributeProductVariableId = TRY_CAST(@Filt AS INT))
           OR (apv.attributeProductVariableProductVariableId = TRY_CAST(@Filt AS INT))
           OR (apv.attributeProductVariableAttributeProductId = TRY_CAST(@Filt AS INT))
          )
    ORDER BY apv.attributeProductVariableId DESC;
END;
GO

-- 3. INSERCIÓN (Con Reactivación Automática y códigos de respuesta INT)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_AttributeProductVariables](
    @attributeProductVariableProductVariableId INT NULL,
    @attributeProductVariableAttributeProductId INT NULL,
    @attributeProductVariableValue VARCHAR(50) NULL,
    @attributeProductVariableCreatorId INT NULL,
    @attributeProductVariableCreationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT -- Cambiado a INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@attributeProductVariableCreationDate IS NULL)
        BEGIN
            SET @attributeProductVariableCreationDate = GETDATE();
        END
 
        IF(ISNULL(@attributeProductVariableProductVariableId, 0) <= 0 
           OR ISNULL(@attributeProductVariableAttributeProductId, 0) <= 0
           OR ISNULL(TRIM(@attributeProductVariableValue), '') = ''
           OR ISNULL(@attributeProductVariableCreatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios o los IDs numéricos son incorrectos';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
                  WHERE attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId
                    AND attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId
                    AND attributeProductVariableStatusId = 1)
        BEGIN
            SET @Mensaje = 'Ya existe este atributo activo asignado a la variante de producto seleccionada';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
                  WHERE attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId
                    AND attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId
                    AND attributeProductVariableStatusId = 0)
        BEGIN
            BEGIN TRANSACTION [trx_reactivate_attrvariables]
                UPDATE [SQM_GENERAL].[Tbl_AttributeProductVariables]
                SET attributeProductVariableValue = TRIM(@attributeProductVariableValue),
                    attributeProductVariableStatusId = 1,
                    attributeProductVariableModificatorId = @attributeProductVariableCreatorId,
                    attributeProductVariableModificationDate = @attributeProductVariableCreationDate
                WHERE attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId 
                  AND attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId
                  AND attributeProductVariableStatusId = 0;
            COMMIT TRANSACTION [trx_reactivate_attrvariables];
            SET @Mensaje = 'El registro ya existía de forma inactiva, se reactivó con éxito';
            SET @Resultado = 201;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_insert_attrvariables]
                INSERT INTO [SQM_GENERAL].[Tbl_AttributeProductVariables] (
                    attributeProductVariableProductVariableId,
                    attributeProductVariableAttributeProductId,
                    attributeProductVariableValue,
                    attributeProductVariableCreatorId,
                    attributeProductVariableCreationDate,
                    attributeProductVariableStatusId
                )
                VALUES (
                    @attributeProductVariableProductVariableId,
                    @attributeProductVariableAttributeProductId,
                    TRIM(@attributeProductVariableValue),
                    @attributeProductVariableCreatorId,
                    @attributeProductVariableCreationDate,
                    1
                );
            COMMIT TRANSACTION [trx_insert_attrvariables];
            SET @Mensaje = 'Datos de atributo de variable ingresados con éxito';
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
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_AttributeProductVariables](
    @attributeProductVariableId INT,
    @attributeProductVariableProductVariableId INT NULL,
    @attributeProductVariableAttributeProductId INT NULL,
    @attributeProductVariableValue VARCHAR(50) NULL,
    @attributeProductVariableModificatorId INT NULL,
    @attributeProductVariableModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT -- Cambiado a INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@attributeProductVariableModificationDate IS NULL)
        BEGIN
            SET @attributeProductVariableModificationDate = GETDATE();
        END

        IF(ISNULL(@attributeProductVariableId, 0) <= 0
           OR ISNULL(@attributeProductVariableProductVariableId, 0) <= 0
           OR ISNULL(@attributeProductVariableAttributeProductId, 0) <= 0
           OR ISNULL(TRIM(@attributeProductVariableValue), '') = ''
           OR ISNULL(@attributeProductVariableModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios o los IDs numéricos son incorrectos';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
                  WHERE attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId
                    AND attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId 
                    AND attributeProductVariableStatusId = 1 
                    AND attributeProductVariableId <> @attributeProductVariableId)
        BEGIN
            SET @Mensaje = 'Este atributo ya se encuentra asignado a esta variante de producto en otro registro activo ¡Revise!';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_update_attrvariables]
                UPDATE [SQM_GENERAL].[Tbl_AttributeProductVariables]
                SET attributeProductVariableProductVariableId = @attributeProductVariableProductVariableId,
                    attributeProductVariableAttributeProductId = @attributeProductVariableAttributeProductId,
                    attributeProductVariableValue = TRIM(@attributeProductVariableValue),
                    attributeProductVariableModificatorId = @attributeProductVariableModificatorId,
                    attributeProductVariableModificationDate = @attributeProductVariableModificationDate,
                    attributeProductVariableStatusId = 1
                WHERE attributeProductVariableId = @attributeProductVariableId;
            COMMIT TRANSACTION [trx_update_attrvariables];
            SET @Mensaje = 'Datos de atributo de variable actualizados con éxito';
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
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_AttributeProductVariables](
    @attributeProductVariableId INT,
    @attributeProductVariableModificatorId INT NULL,
    @attributeProductVariableModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT -- Cambiado a INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@attributeProductVariableModificationDate IS NULL)
        BEGIN
            SET @attributeProductVariableModificationDate = GETDATE();
        END

        IF(ISNULL(@attributeProductVariableId, 0) <= 0 OR ISNULL(@attributeProductVariableModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Los datos numéricos no pueden ser menores o iguales a 0';
            SET @Resultado = 400;
            RETURN;
        END
 
        IF NOT EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_AttributeProductVariables]
                      WHERE attributeProductVariableId = @attributeProductVariableId AND attributeProductVariableStatusId = 1)
        BEGIN
            SET @Mensaje = 'No existe un dato activo para eliminar o ya se encuentra inactivo';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_delete_attrvariables]
                UPDATE [SQM_GENERAL].[Tbl_AttributeProductVariables]
                SET attributeProductVariableModificatorId = @attributeProductVariableModificatorId,
                    attributeProductVariableModificationDate = @attributeProductVariableModificationDate,
                    attributeProductVariableStatusId = 0
                WHERE attributeProductVariableId = @attributeProductVariableId;
            COMMIT TRANSACTION [trx_delete_attrvariables];
            SET @Mensaje = 'Datos de atributo de variable eliminado con éxito';
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
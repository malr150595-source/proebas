USE DB_ECOMMERCE
GO

-- 1. LISTADO (Solo registros activos)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_AttributeProducts]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        AttributeProductId AS [AtributoProductoId],
        AttributeProductAttributesTypeId AS [AtributoProductoTipoId],
        AttributeProductName AS [AtributoProductoNombre],
        AttributeProductDescription AS [ProductoAtributoDescripcion],
        AttributeProductCreatorId AS [AtributoProductoCreadorId],
        AttributeProductCreationDate AS [AtributoProductoCreacionFecha],
        AttributeProductModificatorId AS [AtributoProductoIdModificador],
        AttributeProductModificationDate AS [AtributoProductoFechaModificacion]
    FROM [SQM_CATALOGS].[Tbl_AttributeProducts]
    WHERE AttributeProductStatusId = 1
    ORDER BY AttributeProductId DESC;
END
GO

-- 2. FILTRADO / BÚSQUEDA DINAMICA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_list_AttributeProducts](
    @Filt VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        AttributeProductId AS [AtributoProductoId],
        AttributeProductAttributesTypeId AS [AtributoProductoTipoId],
        AttributeProductName AS [AtributoProductoNombre],
        AttributeProductDescription AS [ProductoAtributoDescripcion],
        AttributeProductCreatorId AS [AtributoProductoCreadorId],
        AttributeProductCreationDate AS [AtributoProductoCreacionFecha],
        AttributeProductModificatorId AS [AtributoProductoIdModificador],
        AttributeProductModificationDate AS [AtributoProductoFechaModificacion]
    FROM [SQM_CATALOGS].[Tbl_AttributeProducts]
    WHERE AttributeProductStatusId = 1
      AND (
           AttributeProductName LIKE '%' + @Filt + '%' 
           OR AttributeProductDescription LIKE '%' + @Filt + '%'
           OR (AttributeProductId = TRY_CAST(@Filt AS INT))
           OR (AttributeProductAttributesTypeId = TRY_CAST(@Filt AS INT))
          )
    ORDER BY AttributeProductId DESC;
END
GO

-- 3. INSERCIÓN (Con Reactivación Automática)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_AttributeProducts](
    @AtributeProductAttributesTypeId INT NULL,
    @AtributeProductName VARCHAR(50) NULL,
    @AtributeProductDescription VARCHAR(100) NULL,
    @AtributeProductCreatorId INT NULL,
    @AtributeProductCreationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@AtributeProductCreationDate IS NULL)
            SET @AtributeProductCreationDate = GETDATE();
        
        -- CORREGIDO: Validación correcta para tipos de datos String y enteros
        IF (
            ISNULL(@AtributeProductAttributesTypeId, 0) <= 0 
            OR ISNULL(TRIM(@AtributeProductName), '') = ''  
            OR ISNULL(TRIM(@AtributeProductDescription), '') = ''
            OR ISNULL(@AtributeProductCreatorId, 0) <= 0
            )
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_AttributeProducts]
                  WHERE AttributeProductName = @AtributeProductName
                    AND AttributeProductAttributesTypeId = @AtributeProductAttributesTypeId
                    AND AttributeProductStatusId = 1)
        BEGIN
            SET @Mensaje = 'Ya existe un atributo activo con ese nombre para este tipo de atributo';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_AttributeProducts]
                  WHERE AttributeProductName = @AtributeProductName
                    AND AttributeProductAttributesTypeId = @AtributeProductAttributesTypeId
                    AND AttributeProductStatusId = 0)
        BEGIN
            BEGIN TRANSACTION [trx_reactivate_attrproducts]
                UPDATE [SQM_CATALOGS].[Tbl_AttributeProducts]
                SET AttributeProductDescription = @AtributeProductDescription,
                    AttributeProductStatusId = 1,
                    AttributeProductModificatorId = @AtributeProductCreatorId,
                    AttributeProductModificationDate = @AtributeProductCreationDate
                WHERE AttributeProductName = @AtributeProductName 
                  AND AttributeProductAttributesTypeId = @AtributeProductAttributesTypeId
                  AND AttributeProductStatusId = 0;
            COMMIT TRANSACTION [trx_reactivate_attrproducts];
            
            SET @Mensaje = 'El atributo de producto ya existía, se reactivó con éxito';
            SET @Resultado = 201;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_insert_attrproducts]
                INSERT INTO [SQM_CATALOGS].[Tbl_AttributeProducts] (
                    AttributeProductAttributesTypeId,
                    AttributeProductName,
                    AttributeProductDescription,
                    AttributeProductCreatorId,
                    AttributeProductCreationDate,
                    AttributeProductStatusId
                )
                VALUES (
                    @AtributeProductAttributesTypeId,
                    @AtributeProductName,
                    @AtributeProductDescription,
                    @AtributeProductCreatorId,
                    @AtributeProductCreationDate,
                    1
                );
            COMMIT TRANSACTION [trx_insert_attrproducts];
            
            SET @Mensaje = 'Datos de Atributo de Producto ingresados con éxito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al ingresar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

-- 4. ACTUALIZACIÓN (Validación contra terceros)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_AttributeProducts](
    @AtributeProductId INT,
    @AtributeProductAttributesTypeId INT NULL,
    @AtributeProductName VARCHAR(50) NULL,
    @AtributeProductDescription VARCHAR(100) NULL,
    @AtributeProductModificatorId INT NULL,
    @AtributeProductModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@AtributeProductModificationDate IS NULL)
            SET @AtributeProductModificationDate = GETDATE();

        -- CORREGIDO: Validación correcta para tipos de datos String y enteros
        IF (ISNULL(@AtributeProductId, 0) <= 0
            OR ISNULL(@AtributeProductAttributesTypeId, 0) <= 0 
            OR ISNULL(TRIM(@AtributeProductName), '') = ''  
            OR ISNULL(TRIM(@AtributeProductDescription), '') = ''
            OR ISNULL(@AtributeProductModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_AttributeProducts]
                  WHERE AttributeProductName = @AtributeProductName 
                    AND AttributeProductAttributesTypeId = @AtributeProductAttributesTypeId
                    AND AttributeProductStatusId = 1 
                    AND AttributeProductId <> @AtributeProductId)
        BEGIN
            SET @Mensaje = 'Ya existe otro atributo activo con el mismo nombre bajo ese tipo. ¡Revise!';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_update_attrproducts]
                UPDATE [SQM_CATALOGS].[Tbl_AttributeProducts]
                SET AttributeProductAttributesTypeId = @AtributeProductAttributesTypeId,
                    AttributeProductName = @AtributeProductName,
                    AttributeProductDescription = @AtributeProductDescription,
                    AttributeProductModificatorId = @AtributeProductModificatorId,
                    AttributeProductModificationDate = @AtributeProductModificationDate,
                    AttributeProductStatusId = 1
                WHERE AttributeProductId = @AtributeProductId 
                  AND AttributeProductStatusId = 1;
            COMMIT TRANSACTION [trx_update_attrproducts];
            
            SET @Mensaje = 'Datos de Atributo de Producto actualizados con éxito';
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

-- 5. ELIMINACIÓN (Borrado Lógico)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_AttributeProducts](
    @AtributeProductId INT,
    @AtributeProductModificatorId INT NULL,
    @AtributeProductModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@AtributeProductModificationDate IS NULL)
            SET @AtributeProductModificationDate = GETDATE();

        IF (
        ISNULL(@AtributeProductId, 0) <= 0
        OR ISNULL(@AtributeProductId, '') = ''
        OR ISNULL(@AtributeProductModificatorId, 0) <= 0
        OR ISNULL(@AtributeProductModificatorId, '') = ''
        )
        BEGIN
            SET @Mensaje = 'Los numeros no pueden ser negativos, ni 0';
            SET @Resultado = 400;
            RETURN;
        END
 
        IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_AttributeProducts] 
                       WHERE AttributeProductId = @AtributeProductId 
                         AND AttributeProductStatusId = 1)
        BEGIN
            SET @Mensaje = 'No existe un dato para eliminar';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_delete_attrproducts]
                UPDATE [SQM_CATALOGS].[Tbl_AttributeProducts]
                SET AttributeProductModificatorId = @AtributeProductModificatorId,
                    AttributeProductModificationDate = @AtributeProductModificationDate,
                    AttributeProductStatusId = 0
                WHERE AttributeProductId = @AtributeProductId;
            COMMIT TRANSACTION [trx_delete_attrproducts];
            
            SET @Mensaje = 'Atributo de Producto eliminado con éxito';
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
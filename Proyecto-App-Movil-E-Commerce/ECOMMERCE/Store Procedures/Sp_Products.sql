USE DB_ECOMMERCE
GO

-- 1. LISTADO (Solo registros activos)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_Products]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        p.productId AS [ProductId],
        p.productName AS [ProductName],
        p.productDescription AS [ProductDescription],
        p.productProductIdentificatorId AS [ProductProductIdentificatorId],
        c.categoryName AS [CategoryName],
        sc.subCategoryName AS [SubCategoryName],
        s.segmentName AS [SegmentName],
        p.productMarkByProviderId AS [ProductMarkByProviderId],
        m.markName AS [MarkName],
        prov.providerName AS [ProviderName],
        p.productCreatorId AS [ProductCreatorId],
        p.productCreationDate AS [ProductCreationDate],
        p.productModificatorId AS [ProductModificatorId],
        p.productModificationDate AS [ProductModificationDate]
    FROM [SQM_GENERAL].[Tbl_Products] p
    -- Relación hacia Identificadores, Categorías, Subcategorías y Segmentos
    INNER JOIN [SQM_CATALOGS].[Tbl_ProductIdentificators] pi 
        ON p.productProductIdentificatorId = pi.productIdentificatorId
    INNER JOIN [SQM_CATALOGS].[Tbl_Categories] c 
        ON pi.productIdentificatorCategoryId = c.categoryId
    INNER JOIN [SQM_CATALOGS].[Tbl_SubCategories] sc 
        ON pi.productIdentificatorSubCategoryId = sc.subCategoryId
    INNER JOIN [SQM_CATALOGS].[Tbl_Segments] s 
        ON pi.productIdentificatorSegmentId = s.segmentId
    -- Relación hacia Marcas por Proveedor, Marcas y Proveedores
    INNER JOIN [SQM_CATALOGS].[Tbl_MarkByProviders] mbp 
        ON p.productMarkByProviderId = mbp.markByProviderId
    INNER JOIN [SQM_CATALOGS].[Tbl_Marks] m 
        ON mbp.markByProviderMarkId = m.markId
    INNER JOIN [SQM_CATALOGS].[Tbl_Providers] prov 
        ON mbp.markByProviderProviderId = prov.providerId
    WHERE p.productStatusId = 1
    ORDER BY p.productId DESC;
END;
GO

-- 2. FILTRADO / BÚSQUEDA DINÁMICA CON INNER JOIN
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_List_Products](
    @Filt VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        p.productId AS [ProductId],
        p.productName AS [ProductName],
        p.productDescription AS [ProductDescription],
        p.productProductIdentificatorId AS [ProductProductIdentificatorId],
        c.categoryName AS [CategoryName],
        sc.subCategoryName AS [SubCategoryName],
        s.segmentName AS [SegmentName],
        p.productMarkByProviderId AS [ProductMarkByProviderId],
        m.markName AS [MarkName],
        prov.providerName AS [ProviderName],
        p.productCreatorId AS [ProductCreatorId],
        p.productCreationDate AS [ProductCreationDate],
        p.productModificatorId AS [ProductModificatorId],
        p.productModificationDate AS [ProductModificationDate]
    FROM [SQM_GENERAL].[Tbl_Products] p
    -- Relación hacia Identificadores, Categorías, Subcategorías y Segmentos
    INNER JOIN [SQM_CATALOGS].[Tbl_ProductIdentificators] pi 
        ON p.productProductIdentificatorId = pi.productIdentificatorId
    INNER JOIN [SQM_CATALOGS].[Tbl_Categories] c 
        ON pi.productIdentificatorCategoryId = c.categoryId
    INNER JOIN [SQM_CATALOGS].[Tbl_SubCategories] sc 
        ON pi.productIdentificatorSubCategoryId = sc.subCategoryId
    INNER JOIN [SQM_CATALOGS].[Tbl_Segments] s 
        ON pi.productIdentificatorSegmentId = s.segmentId
    -- Relación hacia Marcas por Proveedor, Marcas y Proveedores
    INNER JOIN [SQM_CATALOGS].[Tbl_MarkByProviders] mbp 
        ON p.productMarkByProviderId = mbp.markByProviderId
    INNER JOIN [SQM_CATALOGS].[Tbl_Marks] m 
        ON mbp.markByProviderMarkId = m.markId
    INNER JOIN [SQM_CATALOGS].[Tbl_Providers] prov 
        ON mbp.markByProviderProviderId = prov.providerId
    WHERE p.productStatusId = 1
      AND (
            p.productName LIKE '%' + @Filt + '%'
            OR p.productDescription LIKE '%' + @Filt + '%' 
            OR c.categoryName LIKE '%' + @Filt + '%'
            OR m.markName LIKE '%' + @Filt + '%'
            OR p.productId = TRY_CAST(@Filt AS INT)
          )
    ORDER BY p.productId DESC;
END;
GO

-- 3. INSERCIÓN (Con Reactivación Automática)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_Products](
    @ProductName VARCHAR(50) NULL,
    @ProductDescription VARCHAR(200) NULL,
    @ProductProductIdentificatorId INT NULL,
    @ProductMarkByProviderId INT NULL,
    @ProductCreatorId INT NULL,
    @ProductCreationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;  
    BEGIN TRY
        IF (@ProductCreationDate IS NULL)
            SET @ProductCreationDate = GETDATE();
 
        IF (ISNULL(TRIM(@ProductName), '') = '' 
            OR ISNULL(TRIM(@ProductDescription), '') = ''
            OR ISNULL(@ProductProductIdentificatorId, 0) <= 0
            OR ISNULL(@ProductMarkByProviderId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'No se pueden ingresar datos vacíos o menores o iguales a 0';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productName = TRIM(@ProductName) AND productStatusId = 0)
        BEGIN
            BEGIN TRANSACTION [trx_reactivate_products]
                UPDATE [SQM_GENERAL].[Tbl_Products]
                SET productDescription = TRIM(@ProductDescription),
                    productProductIdentificatorId = @ProductProductIdentificatorId,
                    productMarkByProviderId = @ProductMarkByProviderId,
                    productStatusId = 1,
                    productModificatorId = @ProductCreatorId,
                    productModificationDate = @ProductCreationDate
                WHERE productName = TRIM(@ProductName) 
                  AND productStatusId = 0;
            COMMIT TRANSACTION [trx_reactivate_products];

            SET @Mensaje = 'El producto ya existía de forma inactiva, se reactivó con éxito';
            SET @Resultado = 201;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productName = TRIM(@ProductName) AND productStatusId = 1)
        BEGIN
            SET @Mensaje = 'Ya hay un producto activo con ese nombre ¡Revise!';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_insert_products]
            INSERT INTO [SQM_GENERAL].[Tbl_Products] (
                productName,
                productDescription,
                productProductIdentificatorId,
                productMarkByProviderId,
                productCreatorId,
                productCreationDate,
                productStatusId
            )
            VALUES (
                TRIM(@ProductName),
                TRIM(@ProductDescription),
                @ProductProductIdentificatorId,
                @ProductMarkByProviderId,
                @ProductCreatorId,
                @ProductCreationDate,
                1
            );
        COMMIT TRANSACTION [trx_insert_products];

        SET @Mensaje = 'Datos de Producto ingresados con éxito';
        SET @Resultado = 200;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 4. ACTUALIZACIÓN
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_Products](
    @ProductId INT,
    @ProductName VARCHAR(50) NULL,
    @ProductDescription VARCHAR(200) NULL,
    @ProductProductIdentificatorId INT NULL,
    @ProductMarkByProviderId INT NULL,
    @ProductModificatorId INT NULL,
    @ProductModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        IF (@ProductModificationDate IS NULL)
            SET @ProductModificationDate = GETDATE();

        IF (ISNULL(TRIM(@ProductName), '') = '' OR ISNULL(TRIM(@ProductDescription), '') = '') 
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF (ISNULL(@ProductMarkByProviderId, 0) <= 0
            OR ISNULL(@ProductProductIdentificatorId, 0) <= 0
            OR ISNULL(@ProductModificatorId, 0) <= 0
            OR ISNULL(@ProductId, 0) <= 0) 
        BEGIN
            SET @Mensaje = 'Los IDs numéricos no pueden ser menores o iguales a 0';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productName = TRIM(@ProductName) AND productStatusId = 1 AND productId <> @ProductId)
        BEGIN
            SET @Mensaje = 'Datos existentes en otro producto, no se puede actualizar';
            SET @Resultado = 400;
            RETURN;
        END
 
        BEGIN TRANSACTION [trx_update_products]
            UPDATE [SQM_GENERAL].[Tbl_Products]
            SET productName = TRIM(@ProductName),
                productDescription = TRIM(@ProductDescription),
                productProductIdentificatorId = @ProductProductIdentificatorId,
                productMarkByProviderId = @ProductMarkByProviderId,
                productModificatorId = @ProductModificatorId,
                productModificationDate = @ProductModificationDate,
                productStatusId = 1
            WHERE productId = @ProductId;
        COMMIT TRANSACTION [trx_update_products];

        SET @Mensaje = 'Datos de Producto actualizados con éxito';
        SET @Resultado = 200;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 5. ELIMINACIÓN (Borrado Lógico)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_Products](
    @ProductId INT,
    @ProductModificatorId INT NULL,
    @ProductModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        IF (@ProductModificationDate IS NULL)
            SET @ProductModificationDate = GETDATE();

        IF (ISNULL(@ProductId, 0) <= 0 OR ISNULL(@ProductModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Los datos no pueden ser iguales o menores a 0';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Products] WHERE productId = @ProductId AND productStatusId = 1)
        BEGIN
            SET @Mensaje = 'El producto no existe o ya está eliminado';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_products]
            UPDATE [SQM_GENERAL].[Tbl_Products]
            SET productModificatorId = @ProductModificatorId,
                productModificationDate = @ProductModificationDate,
                productStatusId = 0
            WHERE productId = @ProductId;
        COMMIT TRANSACTION [trx_delete_products];

        SET @Mensaje = 'Producto eliminado con éxito';
        SET @Resultado = 200;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO
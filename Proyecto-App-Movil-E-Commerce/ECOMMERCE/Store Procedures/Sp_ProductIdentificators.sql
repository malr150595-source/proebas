USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_ProductIdentificators]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        p.productIdentificatorId AS Id,
        p.productIdentificatorCategoryId AS IdCategoria,
        c.categoryName AS NombreCategoria,
        p.productIdentificatorSubCategoryId AS IdSubCategoria,
        sc.subCategoryName AS NombreSubCategoria,
        p.productIdentificatorSegmentId AS IdSegmento,
        so.segmentName AS NombreSegmento,
        p.productIdentificatorCreatorId AS IdCreador,
        p.productIdentificatorCreationDate AS FechaCreacion,
        p.productIdentificatorModificatorId AS IdModificador,
        p.productIdentificatorModificationDate AS FechaModificacion
    FROM [SQM_CATALOGS].[Tbl_ProductIdentificators] AS p
    INNER JOIN [SQM_CATALOGS].[Tbl_Categories] AS c ON p.productIdentificatorCategoryId = c.categoryId
    INNER JOIN [SQM_CATALOGS].[Tbl_SubCategories] AS sc ON sc.subCategoryId = p.productIdentificatorSubCategoryId
    INNER JOIN [SQM_CATALOGS].[Tbl_Segments] AS so ON so.segmentId = p.productIdentificatorSegmentId
    WHERE p.productIdentificatorStatusId = 1
    order by p.productIdentificatorId desc
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_List_ProductIdentificators]
(
    @filtro NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        p.productIdentificatorId AS Id,
        p.productIdentificatorCategoryId AS IdCategoria,
        c.categoryName AS NombreCategoria,
        p.productIdentificatorSubCategoryId AS IdSubCategoria,
        sc.subCategoryName AS NombreSubCategoria,
        p.productIdentificatorSegmentId AS IdSegmento,
        so.segmentName AS NombreSegmento,
        p.productIdentificatorCreatorId AS IdCreador,
        p.productIdentificatorCreationDate AS FechaCreacion,
        p.productIdentificatorModificatorId AS IdModificador,
        p.productIdentificatorModificationDate AS FechaModificacion
    FROM [SQM_CATALOGS].[Tbl_ProductIdentificators] AS p
    INNER JOIN [SQM_CATALOGS].[Tbl_Categories] AS c ON p.productIdentificatorCategoryId = c.categoryId
    INNER JOIN [SQM_CATALOGS].[Tbl_SubCategories] AS sc ON sc.subCategoryId = p.productIdentificatorSubCategoryId
    INNER JOIN [SQM_CATALOGS].[Tbl_Segments] AS so ON so.segmentId = p.productIdentificatorSegmentId
    WHERE p.productIdentificatorStatusId = 1 
      AND (
        c.categoryName LIKE '%' + @filtro + '%'
        OR sc.subCategoryName LIKE '%' + @filtro + '%'
        OR so.segmentName LIKE '%' + @filtro + '%'
        OR p.productIdentificatorId = TRY_CAST(@filtro AS INT)
      )
      order by p.productIdentificatorId desc
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_ProductIdentificators]
(
    @ProductIdentificatorCategoryId INT,
    @ProductIdentificatorSubCategoryId INT,
    @ProductIdentificatorSegmentId INT,
    @ProductIdentificatorCreatorId INT,
    @ProductIdentificatorCreationDate DATETIME = NULL,
    @Mensaje NVARCHAR(100) OUTPUT,
    @Resultado INT OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@ProductIdentificatorCreationDate IS NULL)
            SET @ProductIdentificatorCreationDate = GETDATE();
        
        IF (@ProductIdentificatorCategoryId IS NULL OR @ProductIdentificatorSubCategoryId IS NULL OR @ProductIdentificatorSegmentId IS NULL)
        BEGIN 
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        DECLARE @ExistingId INT, @ExistingStatus INT;
        SELECT @ExistingId = productIdentificatorId, @ExistingStatus = productIdentificatorStatusId 
        FROM [SQM_CATALOGS].[Tbl_ProductIdentificators]
        WHERE productIdentificatorCategoryId = @ProductIdentificatorCategoryId
          AND productIdentificatorSubCategoryId = @ProductIdentificatorSubCategoryId
          AND productIdentificatorSegmentId = @ProductIdentificatorSegmentId;

        IF (@ExistingId IS NOT NULL)
        BEGIN
            IF (@ExistingStatus = 0)
            BEGIN
                BEGIN TRANSACTION [trx_reactivate_ProdId]
                    UPDATE [SQM_CATALOGS].[Tbl_ProductIdentificators]
                    SET productIdentificatorStatusId = 1,
                        productIdentificatorModificatorId = @ProductIdentificatorCreatorId,
                        productIdentificatorModificationDate = @ProductIdentificatorCreationDate
                    WHERE productIdentificatorId = @ExistingId;
                COMMIT TRANSACTION [trx_reactivate_ProdId];
                
                SET @Mensaje = 'Registro existente reactivado correctamente';
                SET @Resultado = 200;
                RETURN;
            END
            ELSE
            BEGIN
                SET @Mensaje = 'El identificador de producto ya existe actualmente';
                SET @Resultado = 400;
                RETURN;
            END
        END

        BEGIN TRANSACTION [trx_insert_ProdId]
            INSERT INTO [SQM_CATALOGS].[Tbl_ProductIdentificators] (
                productIdentificatorCategoryId,
                productIdentificatorSubCategoryId,
                productIdentificatorSegmentId,
                productIdentificatorCreatorId,
                productIdentificatorCreationDate,
                productIdentificatorStatusId
            )
            VALUES (
                @ProductIdentificatorCategoryId,
                @ProductIdentificatorSubCategoryId,
                @ProductIdentificatorSegmentId,
                @ProductIdentificatorCreatorId,
                @ProductIdentificatorCreationDate,
                1
            );
        COMMIT TRANSACTION [trx_insert_ProdId];

        SET @Mensaje = 'Datos ingresados correctamente';
        SET @Resultado = 201;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_ProductIdentificators]
(
    @ProductIdentificatorId INT,
    @ProductIdentificatorCategoryId INT,
    @ProductIdentificatorSubCategoryId INT,
    @ProductIdentificatorSegmentId INT,
    @ProductIdentificatorModificatorId INT,
    @ProductIdentificatorModificationDate DATETIME = NULL,
    @Mensaje NVARCHAR(100) OUTPUT,
    @Resultado INT OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@ProductIdentificatorModificationDate IS NULL)
            SET @ProductIdentificatorModificationDate = GETDATE();
        
        IF (@ProductIdentificatorId IS NULL OR @ProductIdentificatorCategoryId IS NULL OR @ProductIdentificatorSubCategoryId IS NULL OR @ProductIdentificatorSegmentId IS NULL)
        BEGIN 
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_update_ProdId]
            UPDATE [SQM_CATALOGS].[Tbl_ProductIdentificators]
            SET productIdentificatorCategoryId = @ProductIdentificatorCategoryId,
                productIdentificatorSubCategoryId = @ProductIdentificatorSubCategoryId,
                productIdentificatorSegmentId = @ProductIdentificatorSegmentId,
                productIdentificatorModificatorId = @ProductIdentificatorModificatorId,
                productIdentificatorModificationDate = @ProductIdentificatorModificationDate
            WHERE productIdentificatorId = @ProductIdentificatorId;
        COMMIT TRANSACTION [trx_update_ProdId];

        SET @Mensaje = 'Datos actualizados correctamente';
        SET @Resultado = 200;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_ProductIdentificators]
(
    @ProductIdentificatorId INT,
    @ProductIdentificatorModificatorId INT,
    @ProductIdentificatorModificationDate DATETIME = NULL,
    @Mensaje NVARCHAR(100) OUTPUT,
    @Resultado INT OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@ProductIdentificatorModificationDate IS NULL)
            SET @ProductIdentificatorModificationDate = GETDATE();

        IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductIdentificators] WHERE productIdentificatorId = @ProductIdentificatorId AND productIdentificatorStatusId = 1)
        BEGIN 
            SET @Mensaje = 'Los datos no existen o ya estan eliminados';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_ProdId]
            UPDATE [SQM_CATALOGS].[Tbl_ProductIdentificators]
            SET productIdentificatorModificatorId = @ProductIdentificatorModificatorId,
                productIdentificatorModificationDate = @ProductIdentificatorModificationDate,
                productIdentificatorStatusId = 0
            WHERE productIdentificatorId = @ProductIdentificatorId;
        COMMIT TRANSACTION [trx_delete_ProdId];

        SET @Mensaje = 'Datos eliminados correctamente';
        SET @Resultado = 200;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO
USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_ProductImages]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        productImageId AS [productImageId],
        productImageProductId AS [productImageProductId],
        productImageURL AS [productImageURL],
        productImageDescription AS [productImageDescription],
        productImageIsPrincipal AS [productImageIsPrincipal],
        productImageCreatorId AS [productImageCreatorId],
        productImageCreationDate AS [productImageCreationDate],
        productImageModificatorId AS [productImageModificatorId],
        productImageModificationDate AS [productImageModificationDate]
    FROM [SQM_GENERAL].[Tbl_ProductImages]
    WHERE productImageStatusId = 1
    ORDER BY productImageId DESC;
END;
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_ProductImages](
    @Filt VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        productImageId AS [productImageId],
        productImageProductId AS [productImageProductId],
        productImageURL AS [productImageURL],
        productImageDescription AS [productImageDescription],
        productImageIsPrincipal AS [productImageIsPrincipal],
        productImageCreatorId AS [productImageCreatorId],
        productImageCreationDate AS [productImageCreationDate],
        productImageModificatorId AS [productImageModificatorId],
        productImageModificationDate AS [productImageModificationDate]
    FROM [SQM_GENERAL].[Tbl_ProductImages]
    WHERE productImageStatusId = 1
      AND (
            productImageURL LIKE '%' + @Filt + '%' 
            OR productImageDescription LIKE '%' + @Filt + '%'
            OR (productImageId = TRY_CAST(@Filt AS INT))
            OR (productImageProductId = TRY_CAST(@Filt AS INT))
          )
    ORDER BY productImageId DESC;
END;
GO

-- --- FUNCIÓN DE INSERTAR ---
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_ProductImages](
    @productImageProductId INT NULL,
    @productImageURL VARCHAR(200) NULL,
    @productImageDescription VARCHAR(100) NULL,
    @productImageIsPrincipal BIT NULL,
    @productImageCreatorId INT NULL,
    @productImageCreationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        IF(@productImageCreationDate IS NULL)
        BEGIN
            SET @productImageCreationDate = GETDATE();
        END
 
        IF(ISNULL(@productImageProductId, 0) <= 0 
           OR ISNULL(TRIM(@productImageURL), '') = '' 
           OR ISNULL(TRIM(@productImageDescription), '') = ''
           OR @productImageIsPrincipal IS NULL
           OR ISNULL(@productImageCreatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios o los IDs numéricos son incorrectos';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductImages]
                  WHERE productImageURL = TRIM(@productImageURL)
                    AND productImageProductId = @productImageProductId
                    AND productImageStatusId = 1)
        BEGIN
            SET @Mensaje = 'Esta URL de imagen ya se encuentra registrada para este producto';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductImages]
                  WHERE productImageURL = TRIM(@productImageURL)
                    AND productImageProductId = @productImageProductId
                    AND productImageStatusId = 0)
        BEGIN
            BEGIN TRANSACTION [trx_reactivate_images]
                UPDATE [SQM_GENERAL].[Tbl_ProductImages]
                SET productImageDescription = TRIM(@productImageDescription),
                    productImageIsPrincipal = @productImageIsPrincipal,
                    productImageStatusId = 1,
                    productImageModificatorId = @productImageCreatorId,
                    productImageModificationDate = @productImageCreationDate
                WHERE productImageURL = TRIM(@productImageURL) 
                  AND productImageProductId = @productImageProductId
                  AND productImageStatusId = 0;
            COMMIT TRANSACTION [trx_reactivate_images];
            SET @Mensaje = 'El registro ya existía de forma inactiva, se reactivó con éxito';
            SET @Resultado = 201;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_insert_images]
                INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] (
                    productImageProductId,
                    productImageURL,
                    productImageDescription,
                    productImageIsPrincipal,
                    productImageCreatorId,
                    productImageCreationDate,
                    productImageStatusId
                )
                VALUES (
                    @productImageProductId,
                    TRIM(@productImageURL),
                    TRIM(@productImageDescription),
                    @productImageIsPrincipal,
                    @productImageCreatorId,
                    @productImageCreationDate,
                    1
                );
            COMMIT TRANSACTION [trx_insert_images];
            SET @Mensaje = 'Datos de imagen de producto ingresados con éxito';
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

-- --- FUNCIÓN DE ACTUALIZAR ---
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_ProductImages](
    @productImageId INT,
    @productImageProductId INT NULL,
    @productImageURL VARCHAR(200) NULL,
    @productImageDescription VARCHAR(100) NULL,
    @productImageIsPrincipal BIT NULL,
    @productImageModificatorId INT NULL,
    @productImageModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        IF(@productImageModificationDate IS NULL)
        BEGIN
            SET @productImageModificationDate = GETDATE();
        END

        IF(ISNULL(@productImageId, 0) <= 0
           OR ISNULL(@productImageProductId, 0) <= 0
           OR ISNULL(TRIM(@productImageURL), '') = ''
           OR ISNULL(TRIM(@productImageDescription), '') = ''
           OR @productImageIsPrincipal IS NULL
           OR ISNULL(@productImageModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios o los IDs numéricos son incorrectos';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductImages]
                  WHERE productImageURL = TRIM(@productImageURL) 
                    AND productImageProductId = @productImageProductId
                    AND productImageStatusId = 1 
                    AND productImageId <> @productImageId)
        BEGIN
            SET @Mensaje = 'La URL de imagen ya existe en otro registro de este producto ¡Revise!';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_update_images]
                UPDATE [SQM_GENERAL].[Tbl_ProductImages]
                SET productImageProductId = @productImageProductId,
                    productImageURL = TRIM(@productImageURL),
                    productImageDescription = TRIM(@productImageDescription),
                    productImageIsPrincipal = @productImageIsPrincipal,
                    productImageModificatorId = @productImageModificatorId,
                    productImageModificationDate = @productImageModificationDate,
                    productImageStatusId = 1
                WHERE productImageId = @productImageId;
            COMMIT TRANSACTION [trx_update_images];
            SET @Mensaje = 'Datos de imagen de producto actualizados con éxito';
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

-- --- FUNCIÓN DE ELIMINAR ---
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_ProductImages](
    @productImageId INT,
    @productImageModificatorId INT NULL,
    @productImageModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        IF(@productImageModificationDate IS NULL)
        BEGIN
            SET @productImageModificationDate = GETDATE();
        END

        IF(ISNULL(@productImageId, 0) <= 0 OR ISNULL(@productImageModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Los datos numéricos no pueden ser iguales o menores a 0';
            SET @Resultado = 400;
            RETURN;
        END
 
        IF NOT EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductImages]
                      WHERE productImageId = @productImageId AND productImageStatusId = 1)
        BEGIN
            SET @Mensaje = 'El registro de imagen no existe o ya está eliminado';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_delete_images]
                UPDATE [SQM_GENERAL].[Tbl_ProductImages]
                SET productImageModificatorId = @productImageModificatorId,
                    productImageModificationDate = @productImageModificationDate,
                    productImageStatusId = 0
                WHERE productImageId = @productImageId;
            COMMIT TRANSACTION [trx_delete_images];
            SET @Mensaje = 'Datos de imagen de producto eliminado con éxito';
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
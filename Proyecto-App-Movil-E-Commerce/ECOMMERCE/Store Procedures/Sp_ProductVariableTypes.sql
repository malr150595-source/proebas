USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_ProductVariableTypes]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        productVariableTypeId AS [productVariableTypeId],
        productVariableTypeName AS [productVariableTypeName],
        productVariableTypeDescription AS [productVariableTypeDescription],
        productVariableTypeCreatorId AS [productVariableTypeCreatorId],
        productVariableTypeCreationDate AS [productVariableTypeCreationDate],
        productVariableTypeModificatorId AS [productVariableTypeModificatorId],
        productVariableTypeModificationDate AS [productVariableTypeModificationDate]
    FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
    WHERE productVariableTypeStatusId = 1
    ORDER BY productVariableTypeId DESC;
END;
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_list_ProductVariableTypes](
    @Filt VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT  
        productVariableTypeId AS [productVariableTypeId],
        productVariableTypeName AS [productVariableTypeName],
        productVariableTypeDescription AS [productVariableTypeDescription],
        productVariableTypeCreatorId AS [productVariableTypeCreatorId],
        productVariableTypeCreationDate AS [productVariableTypeCreationDate],
        productVariableTypeModificatorId AS [productVariableTypeModificatorId],
        productVariableTypeModificationDate AS [productVariableTypeModificationDate]
    FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
    WHERE productVariableTypeStatusId = 1
      AND (
            productVariableTypeName LIKE '%' + @Filt + '%' 
            OR productVariableTypeDescription LIKE '%' + @Filt + '%'
            OR (productVariableTypeId = TRY_CAST(@Filt AS INT))
          )
    ORDER BY productVariableTypeId DESC;
END;
GO

-- 3. INSERCIÓN
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_ProductVariableTypes](
    @productVariableTypeName VARCHAR(50) NULL,
    @productVariableTypeDescription VARCHAR(100) NULL,
    @productVariableTypeCreatorId INT NULL,
    @productVariableTypeCreationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        IF(@productVariableTypeCreationDate IS NULL)
        BEGIN
            SET @productVariableTypeCreationDate = GETDATE();
        END
 
        IF(ISNULL(TRIM(@productVariableTypeName), '') = '' 
           OR ISNULL(TRIM(@productVariableTypeDescription), '') = ''
           OR ISNULL(@productVariableTypeCreatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios o los IDs numéricos son incorrectos';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
                  WHERE productVariableTypeName = TRIM(@productVariableTypeName) AND productVariableTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'Ya existe un tipo de variable de producto activo con ese nombre';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
                  WHERE productVariableTypeName = TRIM(@productVariableTypeName) AND productVariableTypeStatusId = 0)
        BEGIN
            BEGIN TRANSACTION [trx_reactivate_vartypes]
                UPDATE [SQM_CATALOGS].[Tbl_ProductVariableTypes]
                SET productVariableTypeDescription = TRIM(@productVariableTypeDescription),
                    productVariableTypeStatusId = 1,
                    productVariableTypeModificatorId = @productVariableTypeCreatorId,
                    productVariableTypeModificationDate = @productVariableTypeCreationDate
                WHERE productVariableTypeName = TRIM(@productVariableTypeName) 
                  AND productVariableTypeStatusId = 0;
            COMMIT TRANSACTION [trx_reactivate_vartypes];
            SET @Mensaje = 'El registro ya existía de forma inactiva, se reactivó con éxito';
            SET @Resultado = 201;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_insert_vartypes]
                INSERT INTO [SQM_CATALOGS].[Tbl_ProductVariableTypes] (
                    productVariableTypeName,
                    productVariableTypeDescription,
                    productVariableTypeCreatorId,
                    productVariableTypeCreationDate,
                    productVariableTypeStatusId
                )
                VALUES (
                    TRIM(@productVariableTypeName),
                    TRIM(@productVariableTypeDescription),
                    @productVariableTypeCreatorId,
                    @productVariableTypeCreationDate,
                    1
                );
            COMMIT TRANSACTION [trx_insert_vartypes];
            SET @Mensaje = 'Datos de tipo de variable de producto ingresados con éxito';
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

-- 4. ACTUALIZACIÓN
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_ProductVariableTypes](
    @productVariableTypeId INT,
    @productVariableTypeName VARCHAR(50) NULL,
    @productVariableTypeDescription VARCHAR(100) NULL,
    @productVariableTypeModificatorId INT NULL,
    @productVariableTypeModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        IF(@productVariableTypeModificationDate IS NULL)
        BEGIN
            SET @productVariableTypeModificationDate = GETDATE();
        END

        IF(ISNULL(@productVariableTypeId, 0) <= 0
           OR ISNULL(TRIM(@productVariableTypeName), '') = ''
           OR ISNULL(TRIM(@productVariableTypeDescription), '') = ''
           OR ISNULL(@productVariableTypeModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios o los IDs numéricos son menores o iguales a 0';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
                  WHERE productVariableTypeName = TRIM(@productVariableTypeName) 
                    AND productVariableTypeStatusId = 1 
                    AND productVariableTypeId <> @productVariableTypeId)
        BEGIN
            SET @Mensaje = 'El nombre del tipo de variable ya existe en otro registro activo ¡Revise!';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_update_vartypes]
                UPDATE [SQM_CATALOGS].[Tbl_ProductVariableTypes]
                SET productVariableTypeName = TRIM(@productVariableTypeName),
                    productVariableTypeDescription = TRIM(@productVariableTypeDescription),
                    productVariableTypeModificatorId = @productVariableTypeModificatorId,
                    productVariableTypeModificationDate = @productVariableTypeModificationDate,
                    productVariableTypeStatusId = 1
                WHERE productVariableTypeId = @productVariableTypeId;
            COMMIT TRANSACTION [trx_update_vartypes];
            SET @Mensaje = 'Datos de tipo de variable de producto actualizados con éxito';
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

-- 5. ELIMINACIÓN
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_ProductVariableTypes](
    @productVariableTypeId INT,
    @productVariableTypeModificatorId INT NULL,
    @productVariableTypeModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        IF(@productVariableTypeModificationDate IS NULL)
        BEGIN
            SET @productVariableTypeModificationDate = GETDATE();
        END

        IF(ISNULL(@productVariableTypeId, 0) <= 0 OR ISNULL(@productVariableTypeModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Los datos numéricos no pueden ser iguales o menores a 0';
            SET @Resultado = 400;
            RETURN;
        END
 
        IF NOT EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_ProductVariableTypes]
                      WHERE productVariableTypeId = @productVariableTypeId AND productVariableTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'El tipo de variable no existe o ya está eliminado';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_delete_vartypes]
                UPDATE [SQM_CATALOGS].[Tbl_ProductVariableTypes]
                SET productVariableTypeModificatorId = @productVariableTypeModificatorId,
                    productVariableTypeModificationDate = @productVariableTypeModificationDate,
                    productVariableTypeStatusId = 0
                WHERE productVariableTypeId = @productVariableTypeId;
            COMMIT TRANSACTION [trx_delete_vartypes];
            SET @Mensaje = 'Datos de tipo de variable de producto eliminado con éxito';
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
USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_Categories]
AS
BEGIN 
    SET NOCOUNT ON;
    SELECT 
        c.categoryId AS [Id],
        c.categoryName AS [Nombre],
        c.categoryDescription AS [Descripción],
        c.categoryCreatorId AS [Id_Creador],
        c.categoryCreationDate AS [Fecha_Creación],
        c.categoryModificationDate AS [Fecha_Modificación],
        c.categoryModificatorId AS [Id_Modificador]
    FROM [SQM_CATALOGS].[Tbl_Categories] AS c
    WHERE c.categoryStatusId = 1;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[filt_List_Categories](
    @Criterio NVARCHAR(100) = NULL
)
AS
BEGIN 
    SET NOCOUNT ON;
    SELECT 
        c.categoryId AS [Id],
        c.categoryName AS [Nombre],
        c.categoryDescription AS [Descripción],
        c.categoryCreatorId AS [Id_Creador],
        c.categoryCreationDate AS [Fecha_Creación],
        c.categoryModificationDate AS [Fecha_Modificación],
        c.categoryModificatorId AS [Id_Modificador],
        c.categoryStatusId AS [Estado]
    FROM [SQM_CATALOGS].[Tbl_Categories] AS c
    WHERE c.categoryStatusId = 1 
      AND (
            @Criterio IS NULL OR TRIM(@Criterio) = ''
            OR c.categoryName LIKE '%' + @Criterio + '%' 
            OR c.categoryDescription LIKE '%' + @Criterio + '%' 
            -- Solución: TRY_CAST devuelve NULL si no es numérico, evitando el crash
            OR c.categoryId = TRY_CAST(@Criterio AS INT)
          );
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_Categories](
    @categoryName VARCHAR(50) NULL,
    @categoryDescription VARCHAR(100) NULL,
    @categoryCreatorId INT NULL,
    @categoryCreationDate DATETIME NULL,
    @Mensaje NVARCHAR(100) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@categoryCreationDate IS NULL)
        BEGIN 
            SET @categoryCreationDate = GETDATE()
        END

        IF(ISNULL(TRIM(@categoryName), '') = '' OR ISNULL(TRIM(@categoryDescription), '') = '')
        BEGIN 
            SET @Mensaje = 'Faltan datos obligatorios'
            SET @Resultado = 400
            RETURN
        END

        IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Categories]
        WHERE categoryName = TRIM(@categoryName) AND categoryStatusId = 1)
        BEGIN
            SET @Mensaje = 'La categoría ya existe ¡Verifique!'
            SET @Resultado = 400
            RETURN
        END

        IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_Categories]
        WHERE categoryName = TRIM(@categoryName) AND categoryStatusId = 0)
        BEGIN
            BEGIN TRANSACTION;
            UPDATE [SQM_CATALOGS].[Tbl_Categories] 
            SET 
                categoryStatusId = 1,
                categoryModificationDate = @categoryCreationDate,
                categoryModificatorId = @categoryCreatorId,
                categoryDescription = TRIM(@categoryDescription)
            WHERE categoryName = TRIM(@categoryName) AND categoryStatusId = 0;
            COMMIT TRANSACTION;

            SET @Mensaje = 'La categoría ya existe pero se encuentra inactiva, ya esta activada'
            SET @Resultado = 201
            RETURN
        END
        ELSE 
        BEGIN
            BEGIN TRANSACTION;
            INSERT INTO [SQM_CATALOGS].[Tbl_Categories] (
                categoryName, 
                categoryDescription,
                categoryCreatorId,
                categoryCreationDate,
                categoryStatusId
            )
            VALUES (
                TRIM(@categoryName),
                TRIM(@categoryDescription),
                @categoryCreatorId,
                @categoryCreationDate,
                1
            );
            COMMIT TRANSACTION;

            SET @Mensaje = 'Cateogoria ingresasada correctamente'
            SET @Resultado = 200
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al insertar la categoría: ' + ERROR_MESSAGE()
        SET @Resultado = 500
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_Categories](
    @categoryId INT,
    @categoryName VARCHAR(50) NULL,
    @categoryDescription VARCHAR(100) NULL,
    @categoryModificatorId INT,
    @categoryModificationDate DATETIME NULL,
    @Mensaje NVARCHAR(100) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@categoryModificationDate IS NULL)
        BEGIN
            SET @categoryModificationDate = GETDATE()
        END

        IF(@categoryId IS NULL OR ISNULL(TRIM(@categoryName), '') = '')
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios'
            SET @Resultado = 400
            RETURN
        END 

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Categories] WHERE categoryName = TRIM(@categoryName) AND categoryId <> @categoryId AND categoryStatusId = 1)
        BEGIN
            SET @Mensaje = 'No se puede actualizar, elija otro nombre'
            SET @Resultado = 400
            RETURN
        END 
        ELSE
        BEGIN
            BEGIN TRANSACTION;
            UPDATE [SQM_CATALOGS].[Tbl_Categories]
            SET
                categoryName = TRIM(@categoryName),
                categoryDescription = TRIM(@categoryDescription),
                categoryModificatorId = @categoryModificatorId,
                categoryModificationDate = @categoryModificationDate,
                categoryStatusId = 1
            WHERE categoryId = @categoryId;
            COMMIT TRANSACTION;

            SET @Mensaje = 'Categoría actualizada correctamente'
            SET @Resultado = 200
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al actualizar: ' + ERROR_MESSAGE()
        SET @Resultado = 500
    End CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_Categories](
    @categoryId INT,
    @categoryModificatorId INT,
    @categoryModificationDate DATETIME NULL,
    @Mensaje NVARCHAR(100) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@categoryModificationDate IS NULL)
        BEGIN 
            SET @categoryModificationDate = GETDATE()
        END 

        IF NOT EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Categories]
        WHERE categoryId = @categoryId AND categoryStatusId = 1)
        BEGIN 
            SET @Mensaje = 'La categoría no existe o ya se encuentra inactiva'
            SET @Resultado = 400
            RETURN
        END 
        ELSE
        BEGIN
            BEGIN TRANSACTION;
            UPDATE [SQM_CATALOGS].[Tbl_Categories]
            SET 
                categoryStatusId = 0,
                categoryModificatorId = @categoryModificatorId,
                categoryModificationDate = @categoryModificationDate
            WHERE categoryId = @categoryId;
            COMMIT TRANSACTION;

            SET @Mensaje = 'Categoría eliminada correctamente'
            SET @Resultado = 200
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al eliminar la categoría: ' + ERROR_MESSAGE()
        SET @Resultado = 500
    END CATCH
END
GO
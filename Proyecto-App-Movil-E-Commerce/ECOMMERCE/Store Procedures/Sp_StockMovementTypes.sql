USE DB_ECOMMERCE
GO

-- 1. LISTAR TODOS LOS TIPOS DE MOVIMIENTOS ACTIVOS
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_StockMovementTypes]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        stockMovementTypeId,
        stockMovementTypeName,
        stockMovementTypeDescription,
        stockMovementTypeCreatorId,
        stockMovementTypeCreationDate,
        stockMovementTypeModificatorId,
        stockMovementTypeModificationDate
    FROM [SQM_CATALOGS].[Tbl_StockMovementTypes]
    WHERE stockMovementTypeStatusId = 1
    ORDER BY stockMovementTypeName ASC; -- Ordenado alfabéticamente para selectores en el Front-End
END
GO

-- 2. FILTRAR O BUSCAR TIPOS DE MOVIMIENTOS (Por ID o coincidencia en Nombre/Descripción)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_list_StockMovementTypes]
(
    @Filt VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Intentamos convertir a entero por si la búsqueda es por un ID exacto
    DECLARE @FiltInt INT = TRY_CAST(@Filt AS INT);

    SELECT 
        stockMovementTypeId,
        stockMovementTypeName,
        stockMovementTypeDescription,
        stockMovementTypeCreatorId,
        stockMovementTypeCreationDate,
        stockMovementTypeModificatorId,
        stockMovementTypeModificationDate
    FROM [SQM_CATALOGS].[Tbl_StockMovementTypes]
    WHERE stockMovementTypeStatusId = 1
      AND (
            (@FiltInt IS NOT NULL AND stockMovementTypeId = @FiltInt)
            OR stockMovementTypeName LIKE '%' + @Filt + '%'
            OR stockMovementTypeDescription LIKE '%' + @Filt + '%'
          )
    ORDER BY stockMovementTypeName ASC;
END
GO

-- 3. INSERTAR UN NUEVO TIPO DE MOVIMIENTO DE INVENTARIO
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_StockMovementTypes]
(
    @stockMovementTypeName VARCHAR(50),
    @stockMovementTypeDescription VARCHAR(100),
    @stockMovementTypeCreatorId INT,
    @stockMovementTypeCreationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @stockMovementTypeCreationDate IS NULL SET @stockMovementTypeCreationDate = GETDATE();

        -- 1. Validación de campos obligatorios (NOT NULL)
        IF (TRIM(ISNULL(@stockMovementTypeName, '')) = '' OR TRIM(ISNULL(@stockMovementTypeDescription, '')) = '' OR @stockMovementTypeCreatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El nombre, la descripción y el usuario creador son obligatorios.';
            SET @Resultado = 400;
            RETURN;
        END

        -- 2. Evitar nombres duplicados (Ignorando mayúsculas/minúsculas y espacios innecesarios)
        IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_StockMovementTypes] WHERE LOWER(TRIM(stockMovementTypeName)) = LOWER(TRIM(@stockMovementTypeName)) AND stockMovementTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: Ya existe un tipo de movimiento de stock activo con ese nombre.';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_insert_movement_types];

        INSERT INTO [SQM_CATALOGS].[Tbl_StockMovementTypes]
        (
            stockMovementTypeName,
            stockMovementTypeDescription,
            stockMovementTypeCreatorId,
            stockMovementTypeCreationDate,
            stockMovementTypeModificatorId,
            stockMovementTypeModificationDate,
            stockMovementTypeStatusId
        )
        VALUES
        (
            TRIM(@stockMovementTypeName),
            TRIM(@stockMovementTypeDescription),
            @stockMovementTypeCreatorId,
            @stockMovementTypeCreationDate,
            NULL,
            NULL,
            1 -- Estado Activo
        );

        COMMIT TRANSACTION [trx_insert_movement_types];

        SET @Mensaje = 'Tipo de movimiento de stock registrado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al insertar tipo de movimiento: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

-- 4. ACTUALIZAR UN TIPO DE MOVIMIENTO DE INVENTARIO
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_StockMovementTypes]
(
    @stockMovementTypeId INT,
    @stockMovementTypeName VARCHAR(50),
    @stockMovementTypeDescription VARCHAR(100),
    @stockMovementTypeModificatorId INT,
    @stockMovementTypeModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @stockMovementTypeModificationDate IS NULL SET @stockMovementTypeModificationDate = GETDATE();

        -- 1. Validar parámetros de entrada obligatorios
        IF (@stockMovementTypeId IS NULL OR TRIM(ISNULL(@stockMovementTypeName, '')) = '' OR TRIM(ISNULL(@stockMovementTypeDescription, '')) = '' OR @stockMovementTypeModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: Todos los campos son requeridos para la actualización del catálogo.';
            SET @Resultado = 400;
            RETURN;
        END

        -- 2. Verificar existencia del registro
        IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_StockMovementTypes] WHERE stockMovementTypeId = @stockMovementTypeId AND stockMovementTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El registro seleccionado no existe o se encuentra inactivo.';
            SET @Resultado = 404;
            RETURN;
        END

        -- 3. Evitar duplicar el nombre con OTROS registros diferentes al que se está editando
        IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_StockMovementTypes] WHERE LOWER(TRIM(stockMovementTypeName)) = LOWER(TRIM(@stockMovementTypeName)) AND stockMovementTypeId <> @stockMovementTypeId AND stockMovementTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: Ya existe otro tipo de movimiento activo registrado con ese mismo nombre.';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_update_movement_types];

        UPDATE [SQM_CATALOGS].[TAGS].[Tbl_StockMovementTypes] -- Nota: Asegurando tu esquema [SQM_CATALOGS]
        SET 
            stockMovementTypeName = TRIM(@stockMovementTypeName),
            stockMovementTypeDescription = TRIM(@stockMovementTypeDescription),
            stockMovementTypeModificatorId = @stockMovementTypeModificatorId,
            stockMovementTypeModificationDate = @stockMovementTypeModificationDate
        WHERE stockMovementTypeId = @stockMovementTypeId AND stockMovementTypeStatusId = 1;

        COMMIT TRANSACTION [trx_update_movement_types];

        SET @Mensaje = 'Tipo de movimiento de stock actualizado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al actualizar tipo de movimiento: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

-- 5. ELIMINAR UN TIPO DE MOVIMIENTO DE INVENTARIO (BAJA LÓGICA)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_StockMovementTypes]
(
    @stockMovementTypeId INT,
    @stockMovementTypeModificatorId INT,
    @stockMovementTypeModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @stockMovementTypeModificationDate IS NULL SET @stockMovementTypeModificationDate = GETDATE();

        IF (@stockMovementTypeId IS NULL OR @stockMovementTypeModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID del registro y el usuario modificador son requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        -- Verificar que el registro exista antes de desactivar
        IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_StockMovementTypes] WHERE stockMovementTypeId = @stockMovementTypeId AND stockMovementTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El tipo de movimiento de stock no existe o ya fue removido anteriormente.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_movement_types];

        UPDATE [SQM_CATALOGS].[Tbl_StockMovementTypes]
        SET 
            stockMovementTypeStatusId = 0,
            stockMovementTypeModificatorId = @stockMovementTypeModificatorId,
            stockMovementTypeModificationDate = @stockMovementTypeModificationDate
        WHERE stockMovementTypeId = @stockMovementTypeId AND stockMovementTypeStatusId = 1;

        COMMIT TRANSACTION [trx_delete_movement_types];

        SET @Mensaje = 'Tipo de movimiento de stock eliminado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al eliminar tipo de movimiento: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO
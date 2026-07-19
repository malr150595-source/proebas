USE DB_ECOMMERCE
GO

-- 1. LISTADO (Solo registros activos)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_Currencies]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        currencyId           AS IdMoneda,
        currencyName         AS NombreMoneda,
        currencyISO          AS ISOMoneda,
        currencyCode         AS CodigoMoneda,
        currencyDescription  AS DescripcionMoneda,
        currencyCreatorId    AS IdCreador,
        currencyCreationDate AS FechaCreacion,
        currencyModificatorId AS IdModificador,
        currencyModificationDate AS FechaModificacion
    FROM [SQM_CATALOGS].[Tbl_Currencies]
    WHERE currencyStatusId = 1
    ORDER BY currencyId DESC;
END;
GO

-- 2. FILTRADO / BÚSQUEDA DINAMICA
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_list_Currencies](
    @Filt VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        currencyId           AS IdMoneda,
        currencyName         AS NombreMoneda,
        currencyISO          AS ISOMoneda,
        currencyCode         AS CodigoMoneda,
        currencyDescription  AS DescripcionMoneda,
        currencyCreatorId    AS IdCreador,
        currencyCreationDate AS FechaCreacion,
        currencyModificatorId AS IdModificador,
        currencyModificationDate AS FechaModificacion
    FROM [SQM_CATALOGS].[Tbl_Currencies]
    WHERE currencyStatusId = 1
      AND (
           currencyName LIKE '%' + @Filt + '%' 
           OR currencyISO LIKE '%' + @Filt + '%'
           OR currencyCode LIKE '%' + @Filt + '%'
           OR (currencyId = TRY_CAST(@Filt AS INT))
          )
    ORDER BY currencyId DESC;
END;
GO

-- 3. INSERCIÓN (Con Reactivación Automática)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_Currencies](
    @CurrencyName VARCHAR(50) NULL,
    @CurrencyISO CHAR(5) NULL,
    @CurrencyCode INT NULL,
    @CurrencyDescription VARCHAR(100) NULL,
    @CurrencyCreatorId INT NULL,
    @CurrencyCreationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@CurrencyCreationDate IS NULL)
            SET @CurrencyCreationDate = GETDATE();

        IF (ISNULL(@CurrencyName,'') = '' 
            OR ISNULL(@CurrencyISO, '') = '' 
            OR ISNULL(@CurrencyCode, 0) <= 0  
            OR ISNULL(@CurrencyDescription,'')= ''
            OR ISNULL(@CurrencyCreatorId, 0) <= 0)  
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies]
                  WHERE UPPER(TRIM(currencyName)) = UPPER(TRIM(@CurrencyName))
                    AND UPPER(TRIM(currencyISO)) = UPPER(TRIM(@CurrencyISO))
                    AND currencyStatusId = 1)
        BEGIN
            SET @Mensaje = 'Datos existentes';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies]
                  WHERE currencyName = TRIM(@CurrencyName)
                    AND currencyISO = TRIM(@CurrencyISO)
                    AND currencyCode = @CurrencyCode
                    AND currencyStatusId = 0)
        BEGIN
            BEGIN TRANSACTION [trx_insert_currencies]
                UPDATE [SQM_CATALOGS].[Tbl_Currencies]
                SET currencyStatusId = 1,
                    currencyDescription = TRIM(@CurrencyDescription), -- Actualizamos descripción por si acaso cambia
                    currencyModificatorId = @CurrencyCreatorId,
                    currencyModificationDate = @CurrencyCreationDate
                WHERE currencyName = TRIM(@CurrencyName)
                  AND currencyStatusId = 0;
            COMMIT TRANSACTION [trx_insert_currencies];

            SET @Mensaje = 'Dato ya existía, se reactivó con éxito';
            SET @Resultado = 201;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_insert_currencies]
                INSERT INTO [SQM_CATALOGS].[Tbl_Currencies] (
                    currencyName,
                    currencyISO,
                    currencyCode,
                    currencyDescription,
                    currencyCreatorId,
                    currencyCreationDate,
                    currencyStatusId
                )
                VALUES (
                    TRIM(@CurrencyName),
                    TRIM(@CurrencyISO),
                    @CurrencyCode,
                    TRIM(@CurrencyDescription),
                    @CurrencyCreatorId,
                    @CurrencyCreationDate,
                    1
                );
            COMMIT TRANSACTION [trx_insert_currencies];

            SET @Mensaje = 'Datos ingresados con éxito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al insertar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 4. ACTUALIZACIÓN (Validación contra terceros)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_Currencies](
    @CurrencyId INT,
    @CurrencyName VARCHAR(50) NULL,
    @CurrencyISO CHAR(5) NULL,
    @CurrencyCode INT NULL,
    @CurrencyDescription VARCHAR(100) NULL,
    @CurrencyModificatorId INT,
    @CurrencyModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@CurrencyModificationDate IS NULL)
            SET @CurrencyModificationDate = GETDATE();

        IF (ISNULL(@CurrencyId,0) <= 0
            OR ISNULL(TRIM(@CurrencyName),'') = '' 
            OR ISNULL(TRIM(@CurrencyISO), '') = '' 
            OR ISNULL(@CurrencyCode, 0) <= 0  
            OR ISNULL(TRIM(@CurrencyDescription),'')= ''
            OR ISNULL(@CurrencyModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies]
                  WHERE UPPER(TRIM(currencyName)) = UPPER(TRIM(@CurrencyName))
                    AND UPPER(TRIM(currencyISO)) = UPPER(TRIM(@CurrencyISO))
                    AND currencyCode = @CurrencyCode
                    AND currencyStatusId = 1
                    AND currencyId <> @CurrencyId)
        BEGIN
            SET @Mensaje = 'Datos existentes en otra moneda registrada';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_update_currencies]
                UPDATE [SQM_CATALOGS].[Tbl_Currencies]
                SET currencyName = TRIM(@CurrencyName),
                    currencyISO = TRIM(@CurrencyISO),
                    currencyCode = @CurrencyCode,
                    currencyDescription = TRIM(@CurrencyDescription),
                    currencyModificatorId = @CurrencyModificatorId,
                    currencyModificationDate = @CurrencyModificationDate,
                    currencyStatusId = 1
                WHERE currencyId = @CurrencyId;
            COMMIT TRANSACTION [trx_update_currencies];

            SET @Mensaje = 'Datos actualizados con éxito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al actualizar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 5. ELIMINACIÓN (Borrado Lógico)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_Currencies](
    @CurrencyId INT,
    @CurrencyModificatorId INT,
    @CurrencyModificationDate DATETIME NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@CurrencyModificationDate IS NULL)
            SET @CurrencyModificationDate = GETDATE();

        -- CORREGIDO: Removida la validación errónea del datetime contra entero
        IF (ISNULL(@CurrencyId, 0) <= 0 OR ISNULL(@CurrencyModificatorId, 0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Currencies]
                      WHERE currencyId = @CurrencyId
                        AND currencyStatusId = 1)
        BEGIN
            SET @Mensaje = 'No existe un dato para eliminar';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_delete_currencies]
                UPDATE [SQM_CATALOGS].[Tbl_Currencies]
                SET currencyModificatorId = @CurrencyModificatorId,
                    currencyModificationDate = @CurrencyModificationDate,
                    currencyStatusId = 0
                WHERE currencyId = @CurrencyId;
            COMMIT TRANSACTION [trx_delete_currencies];

            SET @Mensaje = 'Datos eliminados con éxito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al eliminar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

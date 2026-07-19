USE DB_ECOMMERCE
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_Marks]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        m.markId AS IdMarca,
        m.markName AS NombreMarca,
        m.markDescription AS DescripcionMarca,
        m.markCreatorId AS CreadorMarcaId,
        m.markCreationDate AS CreadorMarcaFecha,
        m.markModificatorId AS MarcaModificadorId,
        m.markModificationDate AS MarcaModificadorFecha
    FROM [SQM_CATALOGS].[Tbl_Marks] AS m
    WHERE markStatusId = 1
    ORDER BY m.markId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_list_Marks]
(
    @Filt NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        m.markId AS IdMarca,
        m.markName AS NombreMarca,
        m.markDescription AS DescripcionMarca,
        m.markCreatorId AS CreadorMarcaId,
        m.markCreationDate AS CreadorMarcaFecha,
        m.markModificatorId AS MarcaModificadorId,
        m.markModificationDate AS MarcaModificadorFecha
    FROM [SQM_CATALOGS].[Tbl_Marks] AS m
    WHERE markStatusId = 1
      AND (
        markName LIKE '%' + @Filt + '%'
        OR (markId = TRY_CAST(@Filt AS INT))
      )
    ORDER BY m.markId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_list_Marks]
(
    @MarkName VARCHAR(50) NULL,
    @MarkDescription VARCHAR(100) NULL,
    @MarkCreatorId INT NULL,
    @MarkCreationDate DATETIME NULL,
    @Mensaje NVARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@MarkCreationDate IS NULL)
            SET @MarkCreationDate = GETDATE();

        IF (ISNULL(TRIM(@MarkName),'') = '' OR ISNULL(TRIM(@MarkDescription),'') = '')
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END
   
        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Marks] WHERE UPPER(TRIM(markName)) = UPPER(TRIM(@MarkName)) AND markStatusId = 1)
        BEGIN
            SET @Mensaje = 'Ya existe una marca';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Marks] WHERE markName = TRIM(@MarkName) AND markStatusId = 0)
        BEGIN
            BEGIN TRANSACTION [trx_reactivacion_marks]
                UPDATE [SQM_CATALOGS].[Tbl_Marks]
                SET markStatusId = 1,
                    markDescription = @MarkDescription,
                    markModificatorId = @MarkCreatorId,
                    markModificationDate = @MarkCreationDate
                WHERE markName = TRIM(@MarkName) AND markStatusId = 0;
            COMMIT TRANSACTION [trx_reactivacion_marks];

            SET @Mensaje = 'Ya existia, se activo nuevamente';
            SET @Resultado = 200;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_insert_marks]
                INSERT INTO [SQM_CATALOGS].[Tbl_Marks] (
                    markName,
                    markDescription,
                    markCreatorId,
                    markCreationDate,
                    markStatusId
                )
                VALUES (
                    TRIM(@MarkName),
                    @MarkDescription,
                    @MarkCreatorId,
                    @MarkCreationDate,
                    1
                );
            COMMIT TRANSACTION [trx_insert_marks];

            SET @Mensaje = 'Marca ingresada con exito';
            SET @Resultado = 201;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_list_Marks]
(
    @MarkId INT,
    @MarkName VARCHAR(50) NULL,
    @MarkDescription VARCHAR(100) NULL,
    @MarkModificatorId INT NULL,
    @MarkModificationDate DATETIME NULL,
    @Mensaje NVARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT -- CORREGIDO: De BIT a INT para tu MensajeDTOs
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@MarkModificationDate IS NULL)
            SET @MarkModificationDate = GETDATE();

        IF (ISNULL(TRIM(@MarkName),'') = '' OR ISNULL(TRIM(@MarkDescription),'') = '' OR ISNULL(@MarkId,0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END
   
        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Marks] WHERE UPPER(markName) = UPPER(TRIM(@MarkName)) AND markStatusId = 1 AND markId <> @MarkId)
        BEGIN
            SET @Mensaje = 'Ya existe una marca con ese nombre';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_update_marks]
                UPDATE [SQM_CATALOGS].[Tbl_Marks]
                SET markName = @MarkName,
                    markDescription = @MarkDescription,
                    markModificatorId = @MarkModificatorId,
                    markModificationDate = @MarkModificationDate,
                    markStatusId = 1
                WHERE markId = @MarkId;
            COMMIT TRANSACTION [trx_update_marks];

            SET @Mensaje = 'Marca actualizada con exito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_list_Marks]
(
    @MarkId INT,
    @MarkModificatorId INT NULL,
    @MarkModificationDate DATETIME NULL,
    @Mensaje NVARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@MarkModificationDate IS NULL)
            SET @MarkModificationDate = GETDATE();

        IF (ISNULL(@MarkId,0) <= 0)
        BEGIN
            SET @Mensaje = 'Faltan datos obligatorios';
            SET @Resultado = 400;
            RETURN;
        END
   
        IF NOT EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Marks] WHERE markStatusId = 1 AND markId = @MarkId)
        BEGIN
            SET @Mensaje = 'No existe una marca o ya esta eliminada';
            SET @Resultado = 400;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION [trx_delete_marks]
                UPDATE [SQM_CATALOGS].[Tbl_Marks]
                SET markModificatorId = @MarkModificatorId,
                    markModificationDate = @MarkModificationDate,
                    markStatusId = 0
                WHERE markId = @MarkId;
            COMMIT TRANSACTION [trx_delete_marks];

            SET @Mensaje = 'Marca eliminada con exito';
            SET @Resultado = 200;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error: ' + ERROR_MESSAGE();
        SET @Resultado = 500; -- CORREGIDO: Cambiado de 200 a 500 ante excepciones de BD
    END CATCH
END
GO
Use DB_EcommerceAgent
Go

-- CREATE
CREATE OR ALTER PROCEDURE Sp_PlantillasRespuesta_Insert
    @ReglaID INT,
    @TextoRespuesta NVARCHAR(MAX),
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ReglasChatbot WHERE ReglaID = @ReglaID)
    BEGIN
        RAISERROR('La regla asignada no existe.', 16, 1);
        RETURN;
    END

    IF @TextoRespuesta IS NULL OR TRIM(@TextoRespuesta) = ''
    BEGIN
        RAISERROR('El texto de respuesta no puede estar vacío.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO PlantillasRespuesta (ReglaID, TextoRespuesta, Activo)
        VALUES (@ReglaID, TRIM(@TextoRespuesta), ISNULL(@Activo, 1));
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- UPDATE
CREATE OR ALTER PROCEDURE Sp_PlantillasRespuesta_Update
    @PlantillaID INT,
    @ReglaID INT,
    @TextoRespuesta NVARCHAR(MAX),
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM PlantillasRespuesta WHERE PlantillaID = @PlantillaID)
    BEGIN
        RAISERROR('La plantilla de respuesta no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM ReglasChatbot WHERE ReglaID = @ReglaID)
    BEGIN
        RAISERROR('La regla asociada no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE PlantillasRespuesta
        SET ReglaID = @ReglaID,
            TextoRespuesta = TRIM(@TextoRespuesta),
            Activo = @Activo
        WHERE PlantillaID = @PlantillaID;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- DELETE
CREATE OR ALTER PROCEDURE Sp_PlantillasRespuesta_Delete
    @PlantillaID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE PlantillasRespuesta SET Activo = 0 WHERE PlantillaID = @PlantillaID;
END;
GO

-- FILTRAR / BUSCAR
CREATE OR ALTER PROCEDURE Sp_PlantillasRespuesta_Filter
    @ReglaID INT = NULL,
    @TextoContenido NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT PlantillaID, ReglaID, TextoRespuesta, Activo
    FROM PlantillasRespuesta
    WHERE (@ReglaID IS NULL OR ReglaID = @ReglaID)
      AND (@TextoContenido IS NULL OR TextoRespuesta LIKE '%' + TRIM(@TextoContenido) + '%')
      AND Activo = 1;
END;
GO
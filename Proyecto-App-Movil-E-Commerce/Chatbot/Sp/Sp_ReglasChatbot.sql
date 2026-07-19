USE [DB_EcommerceAgent]
GO

-- 1. PROCEDIMIENTO INSERT
CREATE OR ALTER PROCEDURE Sp_ReglasChatbot_Insert
    @NombreRegla VARCHAR(100),
    @AccionDinamica BIT,
    @AccionPython VARCHAR(100) NULL,
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @NombreRegla IS NULL OR TRIM(@NombreRegla) = ''
    BEGIN
        RAISERROR('El nombre de la regla no puede estar vacío.', 16, 1);
        RETURN;
    END

    IF @AccionDinamica = 1 AND (@AccionPython IS NULL OR TRIM(@AccionPython) = '')
    BEGIN
        RAISERROR('Si la regla es dinámica, debe especificar la función en Python.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRAN
            INSERT INTO ReglasChatbot (NombreRegla, AccionDinamica, AccionPython, Activo)
            VALUES (TRIM(@NombreRegla), @AccionDinamica, CASE WHEN @AccionDinamica = 1 THEN TRIM(@AccionPython) ELSE NULL END, ISNULL(@Activo, 1));
            
            SELECT SCOPE_IDENTITY() AS NuevoReglaID;
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

-- 2. PROCEDIMIENTO PARA LEER LAS REGLAS EN FORMATO JSON MODULAR
CREATE OR ALTER PROCEDURE Sp_ObtenerReglasChatbotJSON
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        r.ReglaID AS regla_id,
        r.NombreRegla AS nombre_regla,
        r.AccionDinamica AS accion_dinamica,
        r.AccionPython AS accion_python,
        
        JSON_QUERY(pc.JSON_Palabras) AS palabras_clave,
        JSON_QUERY(pr.JSON_Plantillas) AS plantillas_respuesta

    FROM ReglasChatbot r

    OUTER APPLY (
        SELECT p.PalabraClave
        FROM PalabrasClaveRegla p
        WHERE p.ReglaID = r.ReglaID AND p.Activo = 1
        FOR JSON PATH
    ) pc(JSON_Palabras)

    OUTER APPLY (
        SELECT pl.TextoRespuesta
        FROM PlantillasRespuesta pl
        WHERE pl.ReglaID = r.ReglaID AND pl.Activo = 1
        FOR JSON PATH
    ) pr(JSON_Plantillas)

    WHERE r.Activo = 1;
END;
GO


SELECT * FROM PalabrasClaveRegla WHERE PalabraClave = 'hola';
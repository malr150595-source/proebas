USE [DB_EcommerceAgent]
GO

-- 1. PROCEDIMIENTO INSERT
CREATE OR ALTER PROCEDURE Sp_PalabrasClaveRegla_Insert
    @ReglaID INT,
    @PalabraClave VARCHAR(100),
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ReglasChatbot WHERE ReglaID = @ReglaID)
    BEGIN
        RAISERROR('La regla asociada no existe.', 16, 1);
        RETURN;
    END

    IF @PalabraClave IS NULL OR TRIM(@PalabraClave) = ''
    BEGIN
        RAISERROR('La palabra clave no puede estar vacía.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM PalabrasClaveRegla WHERE ReglaID = @ReglaID AND PalabraClave = LOWER(TRIM(@PalabraClave)) AND Activo = 1)
    BEGIN
        RAISERROR('Esta palabra clave ya está registrada y activa para esta regla.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        INSERT INTO PalabrasClaveRegla (ReglaID, PalabraClave, Activo)
        VALUES (@ReglaID, LOWER(TRIM(@PalabraClave)), ISNULL(@Activo, 1));
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- 2. PROCEDIMIENTO UPDATE
CREATE OR ALTER PROCEDURE Sp_PalabrasClaveRegla_Update
    @PalabraClaveID INT,
    @ReglaID INT,
    @PalabraClave VARCHAR(100),
    @Activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM PalabrasClaveRegla WHERE PalabraClaveID = @PalabraClaveID)
    BEGIN
        RAISERROR('El registro de palabra clave no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM ReglasChatbot WHERE ReglaID = @ReglaID)
    BEGIN
        RAISERROR('La regla asociada no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        UPDATE PalabrasClaveRegla
        SET ReglaID = @ReglaID,
            PalabraClave = LOWER(TRIM(@PalabraClave)),
            Activo = @Activo
        WHERE PalabraClaveID = @PalabraClaveID;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- 3. PROCEDIMIENTO DELETE
CREATE OR ALTER PROCEDURE Sp_PalabrasClaveRegla_Delete
    @PalabraClaveID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE PalabrasClaveRegla SET Activo = 0 WHERE PalabraClaveID = @PalabraClaveID;
END;
GO
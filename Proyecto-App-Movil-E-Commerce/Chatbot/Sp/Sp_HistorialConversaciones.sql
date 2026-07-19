USE [DB_EcommerceAgent];
GO

CREATE OR ALTER PROCEDURE [dbo].[Sp_HistorialMensajes_Insert]
    @ConversacionID BIGINT,
    @ChatBot BIT,
    @Texto VARCHAR(1000),
    @FechaHora DATETIME = NULL,
    @ReglaActivadaID INT = NULL,
    @Metadata NVARCHAR(MAX) = NULL 
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Validar existencia de la conversación
    IF NOT EXISTS (SELECT 1 FROM [dbo].[HistorialConversaciones] WHERE [ConversacionID] = @ConversacionID)
    BEGIN
        RAISERROR('La conversación asociada no existe.', 16, 1);
        RETURN;
    END

    -- 2. Prevención defensiva de mensaje vacío
    IF @Texto IS NULL OR TRIM(@Texto) = ''
    BEGIN
        SET @Texto = '⚠️ [Error de Sistema]: Mensaje sin contenido de texto.';
    END

    -- 3. Sanitización e integridad de reglas de negocio
    IF @ReglaActivadaID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [dbo].[ReglasChatbot] WHERE [ReglaID] = @ReglaActivadaID)
    BEGIN
        SET @ReglaActivadaID = NULL;
    END

    -- 4. Validación estricta del formato JSON en Metadata si viene provisto
    IF @Metadata IS NOT NULL AND ISJSON(@Metadata) = 0
    BEGIN
        -- Si no es JSON válido, lo encapsulamos en un nodo de texto plano para no romper la transacción
        SET @Metadata = (SELECT @Metadata AS [raw_invalid_metadata] FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
    END

    BEGIN TRY
        INSERT INTO [dbo].[HistorialMensajes] 
            (ConversacionID, ChatBot, Texto, FechaHora, ReglaActivadaID, metadata)
        VALUES 
            (@ConversacionID, @ChatBot, @Texto, ISNULL(@FechaHora, GETDATE()), @ReglaActivadaID, @Metadata);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO
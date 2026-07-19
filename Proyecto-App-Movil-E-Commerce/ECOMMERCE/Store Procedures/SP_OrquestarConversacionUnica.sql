Use DB_ECOMMERCE
Go

CREATE or alter PROCEDURE [SQM_CATALOGS].[USP_OrquestarConversacionUnica]
    @p_UserName VARCHAR(50),
    @p_Mensaje NVARCHAR(MAX),
    @p_Resultado INT OUTPUT,
    @p_MensajeOutput NVARCHAR(250) OUTPUT,
    @p_ConversationId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @v_UserId INT;

    BEGIN TRY
        -- 1. Validar la existencia del usuario de forma estricta
        SELECT @v_UserId = userId 
        FROM [SQM_SECURITY].[Tbl_Users] 
        WHERE userName = @p_UserName AND userStatusId = 1;

        IF @v_UserId IS NULL
        BEGIN
            SET @p_Resultado = 400;
            SET @p_MensajeOutput = 'El usuario especificado no existe o está inactivo.';
            SET @p_ConversationId = 0;
            RETURN;
        END

        -- 2. Verificar si ya existe UNA conversación activa para este usuario
        SELECT TOP 1 @p_ConversationId = conversationId
        FROM [SQM_GENERAL].[Tbl_Conversations] -- Ajustar esquema según corresponda
        WHERE conversationUserId = @v_UserId AND conversationStatusId = 1;

        -- 3. Si no existe, abrimos la transacción e insertamos una nueva de forma aislada
        IF @p_ConversationId IS NULL
        BEGIN
            BEGIN TRANSACTION;

            INSERT INTO [SQM_GENERAL].[Tbl_Conversations] 
                (conversationUserId, conversationStartDate, conversationCreatorId, conversationCreationDate, conversationStatusId)
            VALUES 
                (@v_UserId, GETDATE(), @v_UserId, GETDATE(), 1);

            SET @p_ConversationId = SCOPE_IDENTITY();

            COMMIT TRANSACTION;
            SET @p_Resultado = 201; -- Creado
            SET @p_MensajeOutput = 'Nueva conversación iniciada exitosamente.';
        END
        ELSE
        BEGIN
            SET @p_Resultado = 200; -- OK (Ya existía una)
            SET @p_MensajeOutput = 'Se reutilizará la conversación activa existente.';
        END

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @p_Resultado = 500;
        SET @p_MensajeOutput = ERROR_MESSAGE();
        SET @p_ConversationId = 0;
    END CATCH
END;
USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_SOP_VERIFICAR_CARRITO]
    @p_UserName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @v_UserId INT = NULL;
    DECLARE @v_CartId INT = NULL;
    DECLARE @v_CatalogoJson NVARCHAR(MAX) = '[]';
    
    DECLARE @v_SubTotal DECIMAL(18,2) = 0.00;
    DECLARE @v_Tax DECIMAL(18,2) = 0.00;
    DECLARE @v_Total DECIMAL(18,2) = 0.00;
    DECLARE @v_CantidadItems INT = 0;

    -- Variables para homogeneizar la respuesta con el Orquestador Principal
    DECLARE @v_ConversationId BIGINT = NULL;
    DECLARE @v_MensajeRespuesta NVARCHAR(MAX) = '';
    DECLARE @FinalJsonResponse NVARCHAR(MAX) = '';

    -- 0. Recuperar la conversación activa para auditoría e historial
    SELECT TOP 1 @v_ConversationId = ConversacionID 
    FROM [dbo].[HistorialConversaciones] (NOLOCK)
    WHERE UsuarioID = LOWER(TRIM(@p_UserName)) AND Activo = 1  
    ORDER BY FechaInicio DESC;

    -- 1. Obtener el ID del Usuario (Convertido a minúsculas para coincidir con el orquestador)
    SELECT TOP 1 @v_UserId = userId 
    FROM [DB_ECOMMERCE].[SQM_SECURITY].[Tbl_Users] (NOLOCK)
    WHERE LOWER(userName) = LOWER(TRIM(@p_UserName)) AND userStatusId = 1;

    IF @v_UserId IS NULL
    BEGIN
        SET @v_MensajeRespuesta = 'El usuario especificado no existe en el sistema.';
        GOTO RESPUESTA_FINAL;
    END

    -- 2. Buscar el carrito activo para este usuario
    SELECT TOP 1 @v_CartId = cartId 
    FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_Carts] (NOLOCK)
    WHERE cartUserId = @v_UserId AND cartStatusId = 1;

    IF @v_CartId IS NULL
    BEGIN
        SET @v_MensajeRespuesta = 'No tienes ningún carrito activo en este momento.';
        GOTO RESPUESTA_FINAL;
    END

    -- 3. Calcular Totales sumando únicamente los detalles con estado Activo (= 1)
    SELECT 
        @v_CantidadItems = ISNULL(SUM(cartDetailQuantity), 0),
        @v_SubTotal = ISNULL(SUM(cartDetailQuantity * cartDetailPrice), 0)
    FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails] (NOLOCK)
    WHERE cartDetailCartId = @v_CartId AND cartDetailStatusId = 1;

    IF @v_CantidadItems = 0
    BEGIN
        SET @v_MensajeRespuesta = 'Tu carrito de compras está vacío.';
        GOTO RESPUESTA_FINAL;
    END

    SET @v_Tax = @v_SubTotal * 0.15;
    SET @v_Total = @v_SubTotal + @v_Tax;

    -- 4. Construir el JSON del catálogo de productos usando obligatoriamente det.cartDetailStatusId = 1
    SET @v_CatalogoJson = (
        SELECT 
            det.cartDetailProductVariableId AS [id_producto],
            prod.CategoryName AS [categoria],
            prod.SubCategoryName AS [subcategoria],
            prod.SegmentName AS [segmento],
            prod.MarkName AS [marca],
            prod.ProductName AS [nombre_producto],
            prod.ProductVariableName AS [variante],
            det.cartDetailPrice AS [precio],
            det.cartDetailQuantity AS [stock]
        FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails] det (NOLOCK)
        INNER JOIN [DB_ECOMMERCE].[SQM_GENERAL].[VW_GENERAL_PRODUCTS] prod (NOLOCK)
            ON det.cartDetailProductVariableId = prod.ProductVariableID
        WHERE det.cartDetailCartId = @v_CartId AND det.cartDetailStatusId = 1
        FOR JSON PATH
    );

    -- Construcción del texto informativo estructurado
    SET @v_MensajeRespuesta = 'Tienes ' + CAST(@v_CantidadItems AS VARCHAR(10)) + ' artículo(s) en tu carrito. ' +
                             'Subtotal: $' + CONVERT(VARCHAR, @v_SubTotal) + ' | ' +
                             'IVA (15%): $' + CONVERT(VARCHAR, @v_Tax) + ' | ' +
                             'Total a Pagar: $' + CONVERT(VARCHAR, @v_Total) + '.';

RESPUESTA_FINAL:
    -- Si por alguna razón la respuesta está vacía, evitamos colapsos
    IF @v_MensajeRespuesta = '' SET @v_MensajeRespuesta = 'No logré procesar la información de tu carrito.';

    -- 5. Generar el JSON Final y asignarlo a la variable @FinalJsonResponse ANTES de guardarlo en historial
    SET @FinalJsonResponse = (
        SELECT   
            CAST(ISNULL(@v_ConversationId, 0) AS VARCHAR(50)) AS [conversation_id],  
            'bot' AS [emisor],  
            5 AS [regla_id],  
            'MOSTRAR CARRITO' AS [nombre_regla],  
            'mostrar_carrito' AS [Intent],   
            @v_MensajeRespuesta AS [mensaje],  
            JSON_QUERY(ISNULL(@v_CatalogoJson, '[]')) AS [catalogo_productos],
            CAST(0 AS BIT) AS [requiere_confirmacion],
            CAST(0 AS BIT) AS [escalado_humano]
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );

    -- 6. Registrar el mensaje final del bot en el historial (Regla 5 = MOSTRAR CARRITO)
    IF @v_ConversationId IS NOT NULL
    BEGIN
        EXEC [dbo].[Sp_HistorialMensajes_Insert]   
            @ConversacionID = @v_ConversationId,   
            @ChatBot = 1,   
            @Texto = @v_MensajeRespuesta,   
            @FechaHora = NULL,   
            @ReglaActivadaID = 5,
            @Metadata = @FinalJsonResponse; -- ¡AQUÍ ESTÁ LA CORRECCIÓN!
    END

    -- 7. Formatear la salida idéntica a la estructura maestra del orquestador hacia FastAPI
    SELECT @FinalJsonResponse AS [json_result];
END;
GO
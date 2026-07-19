USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_SOP_AGREGAR_CARRITO_VARIANTE]
    @p_PayloadJson NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @v_Status VARCHAR(50) = 'ERROR';
    DECLARE @v_Mensaje NVARCHAR(MAX) = '';
    DECLARE @v_CatalogoJson NVARCHAR(MAX) = '[]';
    DECLARE @v_ConversationId BIGINT = NULL;
    DECLARE @v_FinalJson NVARCHAR(MAX);

    BEGIN TRY
        DECLARE @v_UserName NVARCHAR(100);
        DECLARE @v_TextoOriginal NVARCHAR(MAX);
        DECLARE @v_UserId INT = NULL;
        DECLARE @v_CantidadSolicitada INT = 1;

        DECLARE @v_CartId INT = NULL;
        DECLARE @v_SelectedVariableID INT = NULL;
        DECLARE @v_SelectedPrice DECIMAL(18,2) = NULL;
        DECLARE @v_SelectedStock INT = 0;

        -- 1. Validar JSON de entrada
        IF @p_PayloadJson IS NULL OR ISJSON(@p_PayloadJson) = 0
        BEGIN
            SET @v_Status = 'ERROR';
            SET @v_Mensaje = 'El payload JSON de entrada es inválido o nulo.';
            GOTO RESPUESTA_FINAL;
        END

        -- 2. Extraer parámetros del payload
        SELECT
            @v_UserName = LOWER(TRIM(JSON_VALUE(@p_PayloadJson, '$.username'))),
            @v_TextoOriginal = TRIM(JSON_VALUE(@p_PayloadJson, '$.message'));

        -- 3. Buscar el ID de usuario en la base comercial
        SELECT TOP 1 @v_UserId = userId
        FROM [DB_ECOMMERCE].[SQM_SECURITY].[Tbl_Users] (NOLOCK)
        WHERE LOWER(userName) = @v_UserName AND userStatusId = 1;

        IF @v_UserId IS NULL
        BEGIN
            SET @v_Status = 'NOT_FOUND';
            SET @v_Mensaje = 'No se pudo procesar la solicitud porque el usuario "' + ISNULL(@v_UserName, 'Desconocido') + '" no está registrado.';
            GOTO RESPUESTA_FINAL;
        END

        -- 4. Obtener la conversación activa
        SELECT TOP 1 @v_ConversationId = ConversacionID
        FROM [dbo].[HistorialConversaciones] (NOLOCK)
        WHERE UsuarioID = @v_UserName AND Activo = 1
        ORDER BY FechaInicio DESC;

        -- 5. Tokenización dirigida por StopWords
        DECLARE @v_MensajeLower NVARCHAR(500) = LOWER(@v_TextoOriginal);
        DECLARE @TerminosUsuario TABLE (Termino NVARCHAR(100));

        INSERT INTO @TerminosUsuario
        SELECT DISTINCT LOWER(TRIM(S.value))
        FROM STRING_SPLIT(@v_MensajeLower, ' ') S
        WHERE LEN(TRIM(S.value)) > 1
          AND NOT EXISTS (
              SELECT 1 FROM [dbo].[StopWordsCarrito] SW
              WHERE SW.Activo = 1 AND LOWER(SW.Palabra) = LOWER(TRIM(S.value))
          )
          AND NOT EXISTS (
              SELECT 1 FROM [dbo].[StopWords] W
              WHERE W.Activo = 1 AND LOWER(W.Palabra) = LOWER(TRIM(S.value))
          );

        DECLARE @v_CantidadTerminosReales INT = 0;
        SELECT @v_CantidadTerminosReales = COUNT(*) FROM @TerminosUsuario;

        -- Frase limpia reconstruida
        DECLARE @v_CleanSearch NVARCHAR(500) = '';
        SELECT @v_CleanSearch = STRING_AGG(Termino, ' ') FROM @TerminosUsuario;
        SET @v_CleanSearch = ISNULL(@v_CleanSearch, '');

        -- 6. Evaluación de Catálogo por Scoring
        DECLARE @TmpScoring TABLE (
            ProductID INT, ProductName VARCHAR(150), ProductVariableID INT, ProductVariableName VARCHAR(150),
            ProductVariablePrice DECIMAL(18,2), CategoryName VARCHAR(100), SubcategoryName VARCHAR(100),
            SegmentName VARCHAR(100), MarkName VARCHAR(100), StockAvilable INT, MatchScore INT
        );

        INSERT INTO @TmpScoring
        SELECT
            P.ProductID, P.ProductName, P.ProductVariableID, P.ProductVariableName,
            P.ProductVariablePrice, P.CategoryName, P.SubcategoryName, P.SegmentName, P.MarkName, P.StockAvilable,
            (
                -- MATCH EXACTO: Se amplía para buscar en Nombre, Variante, Categoría, Subcategoría y Marca
                CASE WHEN @v_CleanSearch <> '' AND LOWER(P.ProductName + ' ' + P.ProductVariableName + ' ' + P.CategoryName + ' ' + P.SubcategoryName + ' ' + P.MarkName) LIKE '%' + @v_CleanSearch + '%' THEN 30 ELSE 0 END +
                
                -- MATCH EN VARIANTE: Se mantiene igual para darle peso a detalles como color o talla
                CASE WHEN @v_CleanSearch <> '' AND LOWER(P.ProductVariableName) LIKE '%' + @v_CleanSearch + '%' THEN 15 ELSE 0 END +
                
                -- MATCH POR TÉRMINOS INDIVIDUALES: Se amplía para sumar puntos por cada palabra (ej. "tenis", "nike", "negro")
                CASE WHEN @v_CantidadTerminosReales > 0 THEN
                    (SELECT COUNT(*) * 10 FROM @TerminosUsuario T 
                     WHERE LOWER(P.ProductName + ' ' + P.ProductVariableName + ' ' + P.CategoryName + ' ' + P.SubcategoryName + ' ' + P.MarkName) LIKE '%' + T.Termino + '%')
                ELSE 0 END
            ) AS MatchScore
        FROM [DB_ECOMMERCE].[SQM_GENERAL].[VW_GENERAL_PRODUCTS] P (NOLOCK)
        WHERE P.StockAvilable > 0;

        -- 💡 CORRECCIÓN: Se añade MatchScore a la estructura para poder aplicar el filtro de desempate posterior
        DECLARE @TmpVariantes TABLE (
            ProductID INT, ProductName VARCHAR(150), ProductVariableID INT, ProductVariableName VARCHAR(150),
            ProductVariablePrice DECIMAL(18,2), CategoryName VARCHAR(100), SubcategoryName VARCHAR(100),
            SegmentName VARCHAR(100), MarkName VARCHAR(100), StockAvilable INT, RankPos INT, MatchScore INT
        );

        INSERT INTO @TmpVariantes
        SELECT ProductID, ProductName, ProductVariableID, ProductVariableName,
               ProductVariablePrice, CategoryName, SubcategoryName, SegmentName, MarkName, StockAvilable,
               ROW_NUMBER() OVER (ORDER BY MatchScore DESC, ProductVariablePrice ASC) AS RankPos,
               MatchScore
        FROM @TmpScoring
        WHERE MatchScore >= 10;

        -- ===================================================================
        -- 💡 FIX: BLOQUE DE DESEMPATE DINÁMICO POR PUNTUACIÓN MÁXIMA
        -- ===================================================================
        DECLARE @MaxScore INT = (SELECT MAX(MatchScore) FROM @TmpVariantes);

        -- Limpiar de la tabla los productos inferiores que no alcanzaron la máxima puntuación
        DELETE FROM @TmpVariantes WHERE MatchScore < @MaxScore;

        -- Recalcular las coincidencias reales del primer lugar
        DECLARE @v_TotalCoincidencias INT = 0;
        SELECT @v_TotalCoincidencias = COUNT(*) FROM @TmpVariantes;

        -- ===================================================================
        -- ESCENARIO A: MATCH EXACTO
        -- ===================================================================
        IF @v_TotalCoincidencias = 1
        BEGIN
            DECLARE @v_SelectedCurrencyId INT = NULL;

            SELECT TOP 1
                @v_SelectedVariableID = ProductVariableID,
                @v_SelectedPrice = ProductVariablePrice,
                @v_SelectedStock = StockAvilable
            FROM @TmpVariantes;

            SELECT TOP 1 @v_SelectedCurrencyId = productVariableCurrencyId
            FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_ProductVariables] (NOLOCK)
            WHERE productVariableId = @v_SelectedVariableID;

            SET @v_SelectedCurrencyId = ISNULL(@v_SelectedCurrencyId, 1);

            IF @v_CantidadSolicitada > @v_SelectedStock
            BEGIN
                SET @v_Status = 'SHORTAGE';
                SET @v_Mensaje = 'Disculpa, solo contamos con ' + CAST(@v_SelectedStock AS VARCHAR) + ' unidades disponibles de ese modelo.';
                GOTO RESPUESTA_FINAL;
            END

            BEGIN TRANSACTION;

            SELECT TOP 1 @v_CartId = cartId
            FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_Carts]
            WHERE cartUserId = @v_UserId AND cartStatusId = 1;

            IF @v_CartId IS NULL
            BEGIN
                INSERT INTO [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_Carts]
                    (cartUserId, cartStatusId, cartCreatorId, cartCreationDate, cartModificatorId, cartModificationDate)
                VALUES
                    (@v_UserId, 1, @v_UserId, GETDATE(), @v_UserId, GETDATE());

                SET @v_CartId = SCOPE_IDENTITY();
            END

            IF EXISTS (SELECT 1 FROM [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails]
                       WHERE cartDetailCartId = @v_CartId AND cartDetailProductVariableId = @v_SelectedVariableID AND cartDetailStatusId = 1)
            BEGIN
                UPDATE [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails]
                SET cartDetailQuantity = cartDetailQuantity + @v_CantidadSolicitada,
                    cartDetailSubTotal = cartDetailSubTotal + (@v_CantidadSolicitada * @v_SelectedPrice),
                    cartDetailTAX = cartDetailTAX + ((@v_CantidadSolicitada * @v_SelectedPrice) * 0.15),
                    cartDetailTotal = cartDetailTotal + ((@v_CantidadSolicitada * @v_SelectedPrice) + ((@v_CantidadSolicitada * @v_SelectedPrice) * 0.15)),
                    cartDetailModificatorId = @v_UserId,
                    cartDetailModificationDate = GETDATE()
                WHERE cartDetailCartId = @v_CartId AND cartDetailProductVariableId = @v_SelectedVariableID AND cartDetailStatusId = 1;
            END
            ELSE
            BEGIN
                DECLARE @SubTotal DECIMAL(18,2) = (@v_CantidadSolicitada * @v_SelectedPrice);
                DECLARE @Tax DECIMAL(18,2) = (@SubTotal * 0.15);
                DECLARE @Total DECIMAL(18,2) = @SubTotal + @Tax;

                INSERT INTO [DB_ECOMMERCE].[SQM_GENERAL].[Tbl_CartDetails]
                    (cartDetailCartId, cartDetailProductVariableId, cartDetailQuantity,
                     cartDetailPrice, cartDetailDiscount, cartDetailSubTotal,
                     cartDetailTAX, cartDetailTotal, cartDetailCurrencyId,
                     cartDetailCreatorId, cartDetailCreationDate,
                     cartDetailModificatorId, cartDetailModificationDate, cartDetailStatusId)
                VALUES
                    (@v_CartId, @v_SelectedVariableID, @v_CantidadSolicitada,
                     @v_SelectedPrice, 0.00, @SubTotal,
                     @Tax, @Total, @v_SelectedCurrencyId,
                     @v_UserId, GETDATE(),
                     @v_UserId, GETDATE(), 1);
            END

            COMMIT TRANSACTION;

            SET @v_CatalogoJson = (
                SELECT ProductID AS id_producto, CategoryName AS categoria, SubcategoryName AS subcategoria,
                       MarkName AS marca, ProductName AS nombre_producto, ProductVariableName AS variante,
                       @v_SelectedPrice AS precio, @v_CantidadSolicitada AS cantidad_agregada
                FROM @TmpVariantes WHERE RankPos = 1 FOR JSON PATH
            );

            SET @v_Status = 'SUCCESS';
            SET @v_Mensaje = '¡Listo! He añadido ' + CAST(@v_CantidadSolicitada AS VARCHAR(10)) + ' unidad de tu ' +
                             (SELECT TOP 1 ProductName + ' (' + ProductVariableName + ')' FROM @TmpVariantes WHERE RankPos = 1) + ' al carrito.';
        END

        -- ===================================================================
        -- ESCENARIO B: AMBIGÜEDAD CONTROLADA
        -- ===================================================================
        ELSE IF @v_TotalCoincidencias > 1
        BEGIN
            SET @v_CatalogoJson = (
                SELECT ProductID AS id_producto, CategoryName AS categoria, SubcategoryName AS subcategoria,
                       MarkName AS marca, ProductName AS nombre_producto, ProductVariableName AS variante,
                       ProductVariablePrice AS precio, StockAvilable AS stock
                FROM @TmpVariantes FOR JSON PATH
            );

            SET @v_Status = 'AMBIGUOUS';
            SET @v_Mensaje = 'He detectado varias opciones para tu solicitud. Por favor indícame cuál deseas agregar de las siguientes:';
        END

        -- ===================================================================
        -- ESCENARIO C: NO ENCONTRADO
        -- ===================================================================
        ELSE
        BEGIN
            SET @v_Status = 'NOT_FOUND';
            SET @v_Mensaje = 'No logré encontrar ningún producto con stock en catálogo que coincida con "' + ISNULL(@v_TextoOriginal, '') + '".';
        END

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @v_Status = 'ERROR';
        SET @v_Mensaje = 'Fallo crítico interno en el motor de carritos: ' + ERROR_MESSAGE();
    END CATCH

RESPUESTA_FINAL:
    SET @v_FinalJson = (
        SELECT
            CAST(ISNULL(@v_ConversationId, 0) AS VARCHAR(50)) AS [conversation_id],
            'bot' AS [emisor],
            4 AS [regla_id],
            'AGREGAR CARRITO' AS [nombre_regla],
            'agregar_carrito' AS [Intent],
            @v_Mensaje AS [mensaje],
            JSON_QUERY(ISNULL(@v_CatalogoJson, '[]')) AS [catalogo_productos],
            CAST(0 AS BIT) AS [requiere_confirmacion],
            CAST(0 AS BIT) AS [escalado_humano]
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );

    IF @v_ConversationId IS NOT NULL
    BEGIN
        EXEC [dbo].[Sp_HistorialMensajes_Insert]
            @ConversacionID = @v_ConversationId,
            @ChatBot = 1,
            @Texto = @v_Mensaje,
            @FechaHora = NULL,
            @ReglaActivadaID = 4,
            @Metadata = @v_FinalJson;  
    END

    SELECT @v_FinalJson AS [json_result];
END;
GO
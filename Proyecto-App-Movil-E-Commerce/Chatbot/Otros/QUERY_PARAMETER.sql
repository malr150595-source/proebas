USE DB_ECOMMERCE
GO

DECLARE @QueryParameter VARCHAR(200)
SET @QueryParameter = '128'

IF ISNULL(@QueryParameter, '') = ''
BEGIN
	PRINT 'EL PARAMETRO DE BUSQUEDA NO PUEDE SER NULO'
END
ELSE
BEGIN

SELECT
	ProductID,
	ProductName,
	ProductVariableName,
	ProductVariablePrice,
	CurrencyISO,
	CategoryName,
	SubcategoryName,
	SegmentName,
	MarkName,
	ProviderName,
	SUM(StockAvilable) [StockAvilable]
FROM SQM_GENERAL.VW_GENERAL_PRODUCTS
WHERE
	ProductName LIKE CONCAT('%', @QueryParameter,'%') OR
	ProductVariableName LIKE CONCAT('%', @QueryParameter,'%') OR
	CategoryName LIKE CONCAT('%', @QueryParameter,'%')
GROUP BY 
	ProductID,
	ProductName,
	ProductVariableName,
	ProductVariablePrice,
	CurrencyISO,
	CategoryName,
	SubcategoryName,
	SegmentName,
	MarkName,
	ProviderName
END


/*
SELECT *
FROM [SQM_CATALOGS].[VW_PRODUCT_IDENTIFICATORS]

sp_tables
[SQM_GENERAL].[Tbl_CartDetails]
[SQM_GENERAL].[Tbl_PaymentOrderDetails]

UPDATE [SQM_GENERAL].[Tbl_Stocks]
SET stockFactoryDate = DATEADD(MONTH,1,stockFactoryDate),
	stockExpirationDate = DATEADD(MONTH,1,stockExpirationDate),
	stockCreationDate =  DATEADD(DAY,15,stockCreationDate)
WHERE stockId = 2

DECLARE @Products AS TABLE (
IDX INT IDENTITY(1,1),
STOCKID INT,
PRODUCTNAME VARCHAR(80),
STOCKAVILABLE INT,
STOCKEXPIRATIONDATE DATETIME
)

INSERT INTO @Products
SELECT
	StockId,
	ProductName,
	StockAvilable,
	StockExpirationDate
FROM SQM_GENERAL.VW_GENERAL_PRODUCTS
WHERE ProductVariableID = 2
ORDER BY StockExpirationDate ASC

SELECT *
FROM @Products
*/


SELECT *
FROM ReglasChatbot

SELECT *
FROM PalabrasClaveRegla

SELECT *
FROM PlantillasRespuesta

SELECT *
FROM HistorialMensajes

DECLARE @TEXTO1 VARCHAR(200) = '¡Buenas noticias! Sí tenemos disponible. Puedes ver los detalles, precio y fotos directamente aquí [ENLACE]'
DECLARE @TEXTO2 VARCHAR(50) = 'https://amazon.com'
DECLARE @TEXTO3 VARCHAR(200) = '¡Hola! Claro que sí, con gusto te ayudo a encontrar lo que necesitas. Para mostrarte las opciones correctas, ¿qué tipo de producto estás buscando hoy? \n Elige una de las siguientes opciones: [TABLA]'

SELECT REPLACE(@TEXTO1, '[ENLACE]', @TEXTO2)

DECLARE
	@Code INT,
	@Message VARCHAR(255),
	@TemplateId INT

DECLARE @TABLA AS TABLE(
	categoryId INT,
	categoryName VARCHAR(50),
	categoryDescription VARCHAR(100)
)

INSERT INTO @TABLA (categoryId, categoryName, categoryDescription)
EXEC DB_ECOMMERCE..USP_CATEGORIES
@w_methodType = 'LIST',
@o_code = @Code OUT,
@o_message  = @Message OUT,
@o_templateId = @TemplateId OUT

SELECT categoryName
FROM @TABLA

PRINT 'Code: ' + CAST(@Code AS VARCHAR)
PRINT 'Message: ' + @Message
PRINT 'TemplateId: ' + CAST(@TemplateId AS VARCHAR)
DB_Eco ... nt.sql
Mostrando DB_EcommerceAgent.sql.
book
CLASE N02: BASE DE CONOCIMIENTO CHATBOT
HECTOR JOSE CALERO ALANIZ
•
31 may (Última modificación: 7 jun)
DB_EcommerceAgent.sql
SQL

Comentarios de la clase

Añade un comentario de clase…
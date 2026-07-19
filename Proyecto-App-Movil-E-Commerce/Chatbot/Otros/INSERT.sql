USE [DB_EcommerceAgent]
GO

Insert into [DB_EcommerceAgent].dbo.ReglasChatbot
values ('MOSTRAR CARRITO',1,'mostrar_carrito',1)


Insert into [DB_EcommerceAgent].dbo.PalabrasClaveRegla
values 
(5,'muestra',1),
(5,'enseña',1),
(5,'ver',1)

insert into [DB_EcommerceAgent].dbo.PlantillasRespuesta
values 
(5,'Este es tu carrito',1),
(5,'Por el momento ese es tu carrito',1)
-- =====================================================================
-- 1. INSERCIÓN EN TABLA: ReglasChatbot
-- =====================================================================
-- Limpiamos inserciones anteriores si existieran para evitar duplicados visuales
TRUNCATE TABLE PalabrasClaveRegla;
DELETE FROM PlantillasRespuesta;
DELETE FROM HistorialMensajes;
DELETE FROM HistorialConversaciones;
DELETE FROM ReglasChatbot;

SET IDENTITY_INSERT ReglasChatbot ON;
INSERT INTO ReglasChatbot (ReglaID, NombreRegla, AccionDinamica, AccionPython, Activo) 
VALUES
(1, 'SALUDO INICIAL', 1, 'cargar_saludos_db', 1),
(2, 'BUSCAR PRODUCTOS', 1, 'buscar_producto_en_db', 1),
(3, 'SOPORTE HUMANO', 0, 'ninguna', 1);
SET IDENTITY_INSERT ReglasChatbot OFF;


-- =====================================================================
-- 2. INSERCIÓN EN TABLA: PalabrasClaveRegla
-- =====================================================================
INSERT INTO PalabrasClaveRegla (ReglaID, PalabraClave, Activo)
VALUES 
-- Disparadores para Regla 1 (Saludos)
(1, 'hola', 1),
(1, 'buenos dias', 1),
(1, 'buenas tardes', 1),
(1, 'buenas noches', 1),

-- Disparadores Generales para Regla 2 (Búsqueda)
(2, 'tienen', 1),
(2, 'buscar', 1),
(2, 'precio', 1),
(2, 'stock', 1),
(2, 'producto', 1),

-- Disparadores específicos por tus productos y marcas reales del catálogo
(2, 'zapatos', 1),
(2, 'zapato', 1),
(2, 'tenis', 1),
(2, 'nike', 1),
(2, 'pegasus', 1),
(2, 'galaxy', 1),
(2, 'samsung', 1),
(2, 's24', 1),
(2, 'iphone', 1),
(2, 'apple', 1),
(2, 'watch', 1),
(2, 'laptop', 1),
(2, 'asus', 1),
(2, 'strix', 1),
(2, 'camiseta', 1),
(2, 'camisetas', 1),
(2, 'levis', 1),
(2, 'jeans', 1),
(2, 'zara', 1),
(2, 'cafetera', 1),
(2, 'nespresso', 1),
(2, 'sofa', 1),
(2, 'mueble', 1),
(2, 'whey', 1),
(2, 'proteina', 1),
(2, 'perfume', 1),
(2, 'chanel', 1),
(2, 'playstation', 1),
(2, 'ps5', 1),
(2, 'taladro', 1),
(2, 'dewalt', 1),
(2, 'aceite', 1),
(2, 'castrol', 1),

-- Disparadores para Regla 3 (Soporte / Fallback manual)
(3, 'asesor', 1),
(3, 'humano', 1),
(3, 'ayuda', 1),
(3, 'soporte', 1),
(3, 'agente', 1);


-- =====================================================================
-- 3. INSERCIÓN EN TABLA: PlantillasRespuesta
-- =====================================================================
INSERT INTO PlantillasRespuesta (ReglaID, TextoRespuesta, Activo)
VALUES
-- Respuestas para Regla 1 (Saludo)
(1, '¡Hola! Bienvenido a nuestra tienda en línea. ¿En qué te puedo colaborar hoy?', 1),
(1, '¡Qué gusto tenerte de vuelta! ¿Buscas algún artículo específico en nuestro catálogo?', 1),
(1, 'Hola, soy tu asistente virtual de compras. Escribe el nombre de un producto o marca para buscarlo.', 1),

-- Respuestas para Regla 2 (Búsqueda de Catálogo)
(2, '¡Excelente elección! He consultado nuestro inventario y esto fue lo que encontré:', 1),
(2, 'Claro que sí, nuestro catálogo en tiempo real dispone de los siguientes resultados:', 1),
(2, '¡Buenas noticias! Contamos con existencias del producto. Aquí tienes los detalles, precios y stock:', 1),

-- Respuestas para Regla 3 (Soporte / Fallback cuando no entiende)
(3, 'Lo siento, no logré comprender tu solicitud. Intenta buscando con una palabra clave como "Samsung", "Nike", "Laptops" o "Precio".', 1),
(3, 'No encontré coincidencias con esa descripción en nuestro catálogo de productos. ¿Deseas intentar con otro término?', 1),
(3, 'Entendido. Si necesitas asistencia personalizada, puedo transferir esta conversación con un agente de soporte humano.', 1);


-- =====================================================================
-- 4. INSERCIÓN EN TABLAS DE LOGS: HistorialConversaciones e HistorialMensajes
-- Simulación de interacciones reales para tener registros de auditoría
-- =====================================================================

-- Caso 1: Usuario busca Tecnología (Samsung / Celular)
INSERT INTO HistorialConversaciones (UsuarioID, FechaInicio, FechaFin, Activo)
VALUES ('examen_user_tech', GETDATE(), NULL, 1);

DECLARE @ID_Conv1 BIGINT = SCOPE_IDENTITY();

INSERT INTO HistorialMensajes (ConversacionID, ChatBot, Texto, FechaHora, ReglaActivadaID)
VALUES 
(@ID_Conv1, 1, '¡Hola! Bienvenido a nuestra tienda en línea. ¿En qué te puedo colaborar hoy?', GETDATE(), 1),
(@ID_Conv1, 0, 'Hola, busco el precio del celular Galaxy S24 Ultra', GETDATE(), NULL),
(@ID_Conv1, 1, '¡Excelente elección! He consultado nuestro inventario y esto fue lo que encontré:', GETDATE(), 2);

-- Caso 2: Usuario ingresa texto que activa el Fallback (Regla 3)
INSERT INTO HistorialConversaciones (UsuarioID, FechaInicio, FechaFin, Activo)
VALUES ('examen_user_ayuda', GETDATE(), NULL, 1);

DECLARE @ID_Conv2 BIGINT = SCOPE_IDENTITY();

INSERT INTO HistorialMensajes (ConversacionID, ChatBot, Texto, FechaHora, ReglaActivadaID)
VALUES 
(@ID_Conv2, 1, 'Hola, soy tu asistente virtual de compras. Escribe el nombre de un producto o marca para buscarlo.', GETDATE(), 1),
(@ID_Conv2, 0, '¿Tienen servicio de entrega de pizza a domicilio?', GETDATE(), NULL),
(@ID_Conv2, 1, 'No encontré coincidencias con esa descripción en nuestro catálogo de productos. ¿Deseas intentar con otro término?', GETDATE(), 3);
GO


-- Vaciamos e insertamos los sinónimos perfectos para tu catálogo real
INSERT INTO [dbo].[BotSinonimos] (PalabraUsuario, PalabraCatalogo) VALUES 
-- Mapeos para Subcategoría: Smartphones
('celular', 'smartphones'),
('celulares', 'smartphones'),
('telefono', 'smartphones'),
('telefonos', 'smartphones'),
('movil', 'smartphones'),
('moviles', 'smartphones'),

-- Mapeos para Subcategoría: Laptops / Consolas / Smartwatches
('lapto', 'laptop'),
('laptos', 'laptop'),
('computadora', 'laptop'),
('computadoras', 'laptop'),
('play', 'playstation'),
('nintendo', 'switch'),
('reloj', 'smartwatches'),
('relojes', 'smartwatches'),

-- Mapeos para Subcategoría: Tenis Deportivos / Camisetas
('zapatos', 'calzado'),
('zapato', 'calzado'),
('zapatillas', 'tenis deportivos'),
('zapatilla', 'tenis deportivos'),
('tenis', 'tenis deportivos'),
('playera', 'camisetas'),
('playeras', 'camisetas'),
('remera', 'camisetas'),
('ropa', 'ropa y moda'),

-- Mapeos para Subcategoría: Suplementos / Mascotas / Automotriz
('proteina', 'suplementos'),
('creatina', 'suplementos'),
('comida para perro', 'alimento para perros'),
('croquetas', 'alimento para perros'),
('aceite', 'aceites para motor'),
('lubricante', 'aceites para motor');
GO

-- =====================================================================
-- 3. DATOS DE PRUEBA PARA LAS NUEVAS TABLAS
-- =====================================================================
-- 3. INSERCIÓN DE DATOS DE PRUEBA (Caso E-commerce)
-- Insertamos primero las Reglas del Sistema Experto
INSERT INTO ReglasChatbot (NombreRegla, AccionDinamica, AccionPython, Activo)
VALUES 
('Saludo Inicial', 1,  'cargar_saludos_db', 1),
('Buscar Producto', 1, 'buscar_producto_en_db',1);

-- Insertamos las Palabras Clave asociadas a cada Regla (usando los IDs generados)
-- Suponiendo que 'Saludo Inicial' es ID 1, 'Buscar Producto' es ID 2, y 'Soporte Humano' es ID 3
INSERT INTO PalabrasClaveRegla (ReglaID, PalabraClave, Activo)
VALUES 
(1, 'hola',1),
(1, 'buenos dias',1),
(1, 'buenas tardes',1),
(1, 'buenas noches',1),
(2, 'tienen',1),
(2, 'buscar',1),
(2, 'precio',1),
(2, 'stock',1),
(2, 'producto',1);

-- Agregamos múltiples opciones de respuesta para el 'Saludo Inicial' (Asumiendo que es el ReglaID = 1)
INSERT INTO PlantillasRespuesta (ReglaID, TextoRespuesta, Activo)
VALUES 
(1, '¡Hola! Bienvenido a nuestra tienda. ¿En qué te puedo colaborar hoy?', 1),
(1, '¡Qué gusto tenerte de vuelta! ¿Buscas algún producto en nuestro catálogo?',1),
(1, 'Hola, soy tu asistente de compras virtuales. ¿Deseas buscar un artículo o ver el estado de un pedido?',1);

INSERT INTO PlantillasRespuesta (ReglaID, TextoRespuesta, Activo)
VALUES 
(2, '¡He encontrado estas opciones para que puedas revisarlas!', 1),
(2, '¡Hola! Claro que sí, con gusto te ayudo a encontrar lo que necesitas. Para mostrarte las opciones correctas, ¿qué tipo de producto estás buscando hoy? \n [@MESSAGE] [@TABLA]',1),
(2, '¡Buenas noticias! Sí tenemos disponible. Puedes ver los detalles, precio y fotos directamente aquí ',1);



Insert into PalabrasClaveRegla values
(4,'agregar',1),
(4,'añadir',1),
(4,'pon',1)


INSERT INTO [dbo].[PlantillasRespuesta] (ReglaID, TextoRespuesta, Activo)
VALUES 
(4, '¡Excelente elección! He procesado tu solicitud para añadir esta variante a tu carrito de compras. ¿Deseas verificar tu carrito o necesitas buscar algo más?', 1),
(4, '¡Listo! He registrado la variante que me pediste en tu carrito con éxito. ¿Te gustaría seguir explorando nuestro catálogo?', 1),
(4, 'Perfecto, acabo de agregar esa variante a tu carrito. ¿Hay algún otro artículo o variante que te gustaría añadir antes de pagar?', 1);
GO

INSERT INTO [dbo].[StopWordsCarrito] ([Palabra],[Activo])
VALUES 
('agrega',1),
('agregar',1), 
('añade',1),
('añadir',1), 
('pon',1), 
('poner',1),
('quiero',1),
('por favor',1), 
('al',1),
('el',1),
('del',1),
('de',1),
('carrito',1), 
('un',1),
('una',1),
('con',1),
('al carrito',1);
GO

INSERT INTO [dbo].[StopWordsCarrito] ([Palabra], [Activo])
SELECT P.Palabra, 1
FROM (
    VALUES 
    ('tienes'), ('tiene'), ('tienen'), ('busco'), ('quiero'), 
    ('por'), ('favor'), ('de'), ('el'), ('la'), ('los'), 
    ('las'), ('un'), ('una'), ('hay'), ('algun'), ('alguna'), 
    ('ver'), ('mira'), ('necesito'), ('comprar')
) AS P(Palabra)
WHERE NOT EXISTS (
    SELECT 1 FROM [dbo].[StopWordsCarrito] S 
    WHERE LOWER(S.Palabra) = LOWER(P.Palabra)
);
GO

INSERT INTO [dbo].[StopWordsBuscar] ([Palabra], [Activo])
VALUES 
('tienes', 1), ('tiene', 1), ('tienen', 1), 
('busco', 1), ('quiero', 1), ('por', 1), 
('favor', 1), ('de', 1), ('el', 1), 
('la', 1), ('los', 1), ('las', 1), 
('un', 1), ('una', 1), ('hay', 1), 
('algun', 1), ('alguna', 1), ('ver', 1), 
('mira', 1), ('necesito', 1), ('comprar', 1);
GO


USE [DB_EcommerceAgent];
GO

-- Añadimos las palabras de intención de búsqueda al motor
INSERT INTO [dbo].[PalabrasClaveRegla] (ReglaID, PalabraClave, Activo)
VALUES 
(2, 'busco', 1),
(2, 'tienen', 1),
(2, 'tiene', 1),
(2, 'quiero', 1),
(2, 'hay', 1),
(2, 'necesito', 1),
(2, 'buscar', 1);
GO

INSERT INTO StopWordsCarrito (Palabra, Activo) VALUES
('agrega', 1),
('agregar', 1),
('añade', 1),
('añadir', 1),
('pon', 1),
('poner', 1),
('comprar', 1),
('carrito', 1),
('quiero', 1);

USE [DB_EcommerceAgent]
GO

-- 1. Insertar la regla base si no existe
SET IDENTITY_INSERT ReglasChatbot ON;
IF NOT EXISTS (SELECT 1 FROM ReglasChatbot WHERE ReglaID = 6)
BEGIN
    INSERT INTO ReglasChatbot (ReglaID, NombreRegla, AccionDinamica, AccionPython, Activo)
    VALUES (6, 'ELIMINAR CARRITO', 1, 'eliminar_carrito', 1);
END
SET IDENTITY_INSERT ReglasChatbot OFF;

-- 2. Palabras clave que el usuario escribe al INICIO para quitar cosas del carrito
INSERT INTO PalabrasClaveRegla (ReglaID, PalabraClave, Activo)
VALUES 
(6, 'elimina', 1),
(6, 'quita', 1),
(6, 'remueve', 1),
(6, 'vacia', 1),
(6, 'cancela', 1),
(6, 'borra', 1);
GO

INSERT INTO dbo.StopWords (Palabra, Activo) 
    VALUES ('busco', 1), ('necesito', 1), ('tienen', 1), ('quiero', 1), ('hola', 1), ('porfavor', 1);

    INSERT INTO dbo.StopWordsCarrito (Palabra, Activo) 
    VALUES ('agrega', 1), ('añadir', 1), ('adicionar', 1), ('pon', 1), ('carrito', 1);
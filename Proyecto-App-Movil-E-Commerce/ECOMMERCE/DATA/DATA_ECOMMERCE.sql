USE [DB_ECOMMERCE]
GO

-- ==========================================
-- 1. Tbl_Status (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_Status] (statusName, statusCreatorId, statusCreationDate, statusStatusId) VALUES
('Activo', 1, GETDATE(), 1),
('Inactivo', 1, GETDATE(), 1),
('Pendiente de Pago', 1, GETDATE(), 1),
('Pago Procesado', 1, GETDATE(), 1),
('Enviado', 1, GETDATE(), 1),
('Entregado', 1, GETDATE(), 1),
('Cancelado', 1, GETDATE(), 1),
('Devuelto', 1, GETDATE(), 1),
('Reembolsado', 1, GETDATE(), 1),
('En Espera de Stock', 1, GETDATE(), 1),
('Apartado', 1, GETDATE(), 1),
('Borrador', 1, GETDATE(), 1),
('Bloqueado', 1, GETDATE(), 1),
('Expirado', 1, GETDATE(), 1),
('Validado', 1, GETDATE(), 1);

-- ==========================================
-- 2. Tbl_Users (15 Inserciones)
-- ==========================================
INSERT INTO  [SQM_SECURITY].[Tbl_Users] (userFullName, userName, userPassword, userEmail, userPhoneNumber, userCountryId, userGenderId, userBirthDay, userCreatorId, userCreationDate, userStatusId) VALUES
('Jonatan Varela Gutierrez', 'Jonatan', HASHBYTES('SHA2_256', 'jonatan123'), 'jgarcia@hotmail.com', '+50588552211', 1, 2, '2000-06-15', 1, GETDATE(), 1),
('System Administrator', 'admin', HASHBYTES('SHA2_256', 'AdminPass123!'), 'admin@ecommerce.com', '+50512345671', 1, 1, '1990-01-01', 1, GETDATE(), 1),
('Juan Alberto Pérez', 'juan.perez', HASHBYTES('SHA2_256', 'JuanPass123!'), 'juan.perez@gmail.com', '+50588888881', 1, 1, '1988-04-12', 1, GETDATE(), 1),
('María Elena Gómez', 'maria.gomez', HASHBYTES('SHA2_256', 'MariaPass123!'), 'maria.gomez@hotmail.com', '+50588888882', 1, 2, '1993-08-22', 1, GETDATE(), 1),
('Carlos José López', 'carlos.lopez', HASHBYTES('SHA2_256', 'CarlosPass123!'), 'carlos.lopez@yahoo.com', '+50588888883', 1, 1, '1991-11-05', 1, GETDATE(), 1),
('Ana Cecilia Rodríguez', 'ana.rod', HASHBYTES('SHA2_256', 'AnaPass123!'), 'ana.rodriguez@outlook.com', '+50588888884', 1, 2, '1995-02-14', 1, GETDATE(), 1),
('Luis Miguel Martínez', 'luis.mtz', HASHBYTES('SHA2_256', 'LuisPass123!'), 'luis.martinez@gmail.com', '+50588888885', 1, 1, '1985-06-30', 1, GETDATE(), 1),
('Diana Patricia Castillo', 'diana.cas', HASHBYTES('SHA2_256', 'DianaPass123!'), 'diana.castillo@gmail.com', '+50588888886', 1, 2, '1997-09-18', 1, GETDATE(), 1),
('Roberto Antonio Silva', 'roberto.silva', HASHBYTES('SHA2_256', 'RobPass123!'), 'roberto.silva@hotmail.com', '+50588888887', 1, 1, '1992-01-25', 1, GETDATE(), 1),
('Laura Sofia Flores', 'laura.flores', HASHBYTES('SHA2_256', 'LauraPass123!'), 'laura.flores@gmail.com', '+50588888888', 1, 2, '1994-07-07', 1, GETDATE(), 1),
('Fernando Javier Ríos', 'fernando.rios', HASHBYTES('SHA2_256', 'FerPass123!'), 'frios@outlook.com', '+50588888889', 1, 1, '1989-10-10', 1, GETDATE(), 1),
('Gabriela Alejandra Meza', 'gaby.meza', HASHBYTES('SHA2_256', 'GabyPass123!'), 'gaby.meza@gmail.com', '+50588888890', 1, 2, '1996-12-05', 1, GETDATE(), 1),
('Alejandro José Torres', 'ale.torres', HASHBYTES('SHA2_256', 'AlePass123!'), 'atorres@gmail.com', '+50588888891', 1, 1, '1991-03-15', 1, GETDATE(), 1),
('Sonia del Carmen Ruiz', 'sonia.ruiz', HASHBYTES('SHA2_256', 'SoniaPass123!'), 'sonia.ruiz@gmail.com', '+50588888892', 1, 2, '1987-05-20', 1, GETDATE(), 1),
('Ricardo Enrique Mendoza', 'ricardo.men', HASHBYTES('SHA2_256', 'RicaPass123!'), 'rmendoza@yahoo.com', '+50588888893', 1, 1, '1993-02-28', 1, GETDATE(), 1),
('Vanessa Beatriz Cruz', 'vane.cruz', HASHBYTES('SHA2_256', 'VanePass123!'), 'vcruz@hotmail.com', '+50588888894', 1, 2, '1998-06-14', 1, GETDATE(), 1);


-- ==========================================
-- 3. Tbl_UserAddress (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_UserAddress] (userAddressUserId, userAddressCountryId, userAddressZIPCode, userAddressDescription, userAddressIsPrincipal, userAddressCreatorId, userAddressCreationDate, userAddressStatusId) VALUES
(2, 1, 11001, 'Colonia Los Robles, Casa #45, Managua', 1, 1, GETDATE(), 1),
(3, 1, 11002, 'Altamira D''Este, de la Vicky 2c al Sur, Managua', 1, 1, GETDATE(), 1),
(4, 1, 12001, 'Reparto San Juan, Calle Principal H-12, León', 1, 1, GETDATE(), 1),
(5, 1, 13001, 'Barrio El Sagrario, Costado Oeste de la Iglesia, Granada', 1, 1, GETDATE(), 1),
(6, 1, 14001, 'Urbanización Estelí Real, Módulo C-3, Estelí', 1, 1, GETDATE(), 1),
(7, 1, 11003, 'Bello Horizonte, Rotonda 1c Al Lago, Managua', 1, 1, GETDATE(), 1),
(8, 1, 15001, 'Barrio Central, Frente al Parque de Ferias, Matagalpa', 1, 1, GETDATE(), 1),
(9, 1, 11004, 'Linda Vista, del Palí 3c Abajo, Managua', 1, 1, GETDATE(), 1),
(10, 1, 16001, 'Calle Real, del Banco Central 1c Al Este, Chinandega', 1, 1, GETDATE(), 1),
(11, 1, 11005, 'Villa Fontana, de los Semáforos de Invercasa 300m Sur, Managua', 1, 1, GETDATE(), 1),
(12, 1, 17001, 'Barrio Sunrise, Frente a la Bahía, Bluefields', 1, 1, GETDATE(), 1),
(13, 1, 18001, 'Barrio Santa Lucia, Costado Norte del Mercado, Masaya', 1, 1, GETDATE(), 1),
(14, 1, 11006, 'Bolonia, de la Óptica Matamoros 1c Abajo', 1, 1, GETDATE(), 1),
(15, 1, 19001, 'Frente a la Parroquia San Sebastián, Diriamba, Carazo', 1, 1, GETDATE(), 1),
(2, 1, 11001, 'Oficinas Ofiplaza El Retiro, Edificio 3, Piso 2, Managua', 0, 1, GETDATE(), 1);

-- ==========================================
-- 4. Tbl_Categories (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_Categories] (categoryName, categoryDescription, categoryCreatorId, categoryCreationDate, categoryStatusId) VALUES
('Tecnología', 'Celulares, Laptops, Gadgets y Accesorios Electrónicos', 1, GETDATE(), 1),
('Ropa y Moda', 'Ropa para Damas, Caballeros y Niños', 1, GETDATE(), 1),
('Hogar y Cocina', 'Muebles, Decoración y Electrodomésticos de cocina', 1, GETDATE(), 1),
('Deportes y Fitness', 'Ropa deportiva, Máquinas de ejercicios y Accesorios', 1, GETDATE(), 1),
('Calzado', 'Zapatos Formales, Deportivos, Botas y Sandalias', 1, GETDATE(), 1),
('Belleza y Cuidado Personal', 'Maquillaje, Cremas, Perfumes y Cuidado del Cabello', 1, GETDATE(), 1),
('Videojuegos', 'Consolas, Juegos físicos y Accesorios Gamer', 1, GETDATE(), 1),
('Libros y Papelería', 'Novelas, Libros Educativos y Útiles Escolares', 1, GETDATE(), 1),
('Herramientas', 'Herramientas Eléctricas y Manuales para Bricolaje', 1, GETDATE(), 1),
('Automotriz', 'Accesorios para autos, Repuestos y Limpieza', 1, GETDATE(), 1),
('Juguetería', 'Juegos de mesa, Muñecos y Juguetes para niños', 1, GETDATE(), 1),
('Mascotas', 'Alimentos, Juguetes y Accesorios para Perros y Gatos', 1, GETDATE(), 1),
('Joyas y Relojes', 'Relojes de pulsera, Anillos, Cadenas y Pulseras', 1, GETDATE(), 1),
('Salud y Bienestar', 'Vitaminas, Suplementos y Equipos Médicos Caseros', 1, GETDATE(), 1),
('Supermercado', 'Snacks, Bebidas, Alimentos empacados Gourmet', 1, GETDATE(), 1);

-- ==========================================
-- 5. Tbl_SubCategories (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_SubCategories] (subCategoryName, subCategoryDescription, subCategoryCreatorId, subCategoryCreationDate, subCategoryStatusId) VALUES
('Smartphones', 'Teléfonos móviles inteligentes de última generación', 1, GETDATE(), 1),
('Laptops', 'Computadoras portátiles para oficina y gaming', 1, GETDATE(), 1),
('Camisetas', 'Camisetas y playeras casuales', 1, GETDATE(), 1),
('Pantalones', 'Jeans, Pantalones de vestir y Joggers', 1, GETDATE(), 1),
('Cafeteras', 'Máquinas de espresso y cafeteras de goteo', 1, GETDATE(), 1),
('Sofás', 'Muebles de sala, Sofás de cuero y tela', 1, GETDATE(), 1),
('Suplementos', 'Proteínas en polvo, Creatina y Aminoácidos', 1, GETDATE(), 1),
('Tenis Deportivos', 'Zapatillas optimizadas para correr y entrenar', 1, GETDATE(), 1),
('Perfumes', 'Fragancias de marcas internacionales', 1, GETDATE(), 1),
('Consolas', 'PlayStation, Xbox y Nintendo Switch', 1, GETDATE(), 1),
('Taladros', 'Taladros inalámbricos y percutores', 1, GETDATE(), 1),
('Aceites para Motor', 'Lubricantes sintéticos y minerales', 1, GETDATE(), 1),
('Alimento para Perros', 'Croquetas y comida húmeda premium', 1, GETDATE(), 1),
('Smartwatches', 'Relojes inteligentes con sensores de salud', 1, GETDATE(), 1),
('Monitores', 'Pantallas para PC planas y curvas gamer', 1, GETDATE(), 1);

-- ==========================================
-- 6. Tbl_Segments (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_Segments] (segmentName, segmentDescription, segmentCreatorId, segmentCreationDate, segmentStatusId) VALUES
('Premium / Alta Gama', 'Productos de lujo con el precio más alto y mejor calidad', 1, GETDATE(), 1),
('Estándar / Consumo Masivo', 'Productos con balance ideal calidad-precio', 1, GETDATE(), 1),
('Económico / Entrada', 'Productos accesibles de bajo costo', 1, GETDATE(), 1),
('Gamer / Profesional', 'Hardware especializado para entusiastas y creadores', 1, GETDATE(), 1),
('Caballeros', 'Líneas enfocadas exclusivamente al público masculino', 1, GETDATE(), 1),
('Damas', 'Líneas enfocadas exclusivamente al público femenino', 1, GETDATE(), 1),
('Unisex', 'Productos de uso general aptos para todo público', 1, GETDATE(), 1),
('Niños e Infantil', 'Diseños orientados a bebés y niños pequeños', 1, GETDATE(), 1),
('Edición Limitada', 'Productos de colección con pocas piezas disponibles', 1, GETDATE(), 1),
('Corporativo / Oficina', 'Líneas industriales o de productividad de oficina', 1, GETDATE(), 1),
('Fitness / Atletas', 'Para alto rendimiento físico', 1, GETDATE(), 1),
('Orgánico / Natural', 'Productos libres de químicos dañinos', 1, GETDATE(), 1),
('Invierno / Otoño', 'Línea de temporada fría', 1, GETDATE(), 1),
('Verano / Primavera', 'Línea de temporada cálida', 1, GETDATE(), 1),
('Hogar Inteligente', 'Productos automatizados IoT', 1, GETDATE(), 1);

-- ==========================================
-- 7. Tbl_ProductIdentificators (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_ProductIdentificators] (productIdentificatorCategoryId, productIdentificatorSubCategoryId, productIdentificatorSegmentId, productIdentificatorCreatorId, productIdentificatorCreationDate, productIdentificatorStatusId) VALUES
(1, 1, 1, 1, GETDATE(), 1), -- Tecnología -> Smartphones -> Premium
(1, 2, 4, 1, GETDATE(), 1), -- Tecnología -> Laptops -> Gamer
(2, 3, 5, 1, GETDATE(), 1), -- Ropa -> Camisetas -> Caballeros
(2, 4, 6, 1, GETDATE(), 1), -- Ropa -> Pantalones -> Damas
(3, 5, 15, 1, GETDATE(), 1),-- Hogar -> Cafeteras -> Hogar Inteligente
(3, 6, 2, 1, GETDATE(), 1), -- Hogar -> Sofás -> Estándar
(4, 7, 11, 1, GETDATE(), 1),-- Deportes -> Suplementos -> Fitness
(5, 8, 11, 1, GETDATE(), 1),-- Calzado -> Tenis Deportivos -> Fitness
(6, 9, 6, 1, GETDATE(), 1), -- Belleza -> Perfumes -> Damas
(7, 10, 4, 1, GETDATE(), 1),-- Videojuegos -> Consolas -> Gamer
(9, 11, 10, 1, GETDATE(), 1),-- Herramientas -> Taladros -> Oficina/Corp
(10, 12, 2, 1, GETDATE(), 1),-- Automotriz -> Aceites -> Estándar
(12, 13, 7, 1, GETDATE(), 1),-- Mascotas -> Alimento Perros -> Unisex
(13, 14, 1, 1, GETDATE(), 1),-- Joyas -> Smartwatches -> Premium
(11, 10, 8, 1, GETDATE(), 1);-- Juguetería -> Consolas -> Niños

-- ==========================================
-- 8. Tbl_Providers (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_Providers] (providerName, providerDescription, providerCreatorId, providerCreationDate, providerStatusId) VALUES
('Distribuidora Global Tech S.A.', 'Mayorista principal de marcas electrónicas', 1, GETDATE(), 1),
('Textiles de Centroamérica', 'Proveedor de telas e indumentaria textil', 1, GETDATE(), 1),
('Importaciones del Hogar S.A.', 'Mayorista de muebles de sala y línea blanca', 1, GETDATE(), 1),
('Nutrición Avanzada S.A.', 'Importador de suplementos deportivos premium', 1, GETDATE(), 1),
('Zapatos Internacionales S.A.', 'Fábrica y distribuidora de calzado a gran escala', 1, GETDATE(), 1),
('Cosméticos París Corp.', 'Distribuidor autorizado de fragancias y estética', 1, GETDATE(), 1),
('Gamer Zone Wholesale', 'Distribuidor oficial de consolas y periféricos', 1, GETDATE(), 1),
('Herramientas Industriales del Norte', 'Líder en importación de maquinaria y ferretería', 1, GETDATE(), 1),
('Automotriz Express Distribución', 'Logística de repuestos y químicos vehiculares', 1, GETDATE(), 1),
('Mascotas Felices Distribuidora', 'Proveedor de alimentos concentrados certificados', 1, GETDATE(), 1),
('Joyas del Norte S.A.', 'Consorcio de joyería fina y tecnología vestible', 1, GETDATE(), 1),
('Corporación del Café Centro', 'Distribuidor de electrodomésticos y barismo', 1, GETDATE(), 1),
('Alimentos del Pacífico', 'Suministros de abarrotes gourmet importados', 1, GETDATE(), 1),
('Muebles Modernos de Roble', 'Fabricante local de carpintería y tapizados', 1, GETDATE(), 1),
('Deportes y Más S.A.', 'Distribuidora mayorista de accesorios deportivos', 1, GETDATE(), 1);

-- ==========================================
-- 9. Tbl_Marks (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_Marks] (markName, markDescription, markCreatorId, markCreationDate, markStatusId) VALUES
('Samsung', 'Electrónica de consumo, móviles y pantallas coreanas', 1, GETDATE(), 1),
('ASUS Rog', 'Hardware de alto rendimiento enfocado a gaming', 1, GETDATE(), 1),
('Levi''s', 'Marca icónica mundial de pantalones y ropa de mezclilla', 1, GETDATE(), 1),
('Zara', 'Moda internacional rápida y contemporánea', 1, GETDATE(), 1),
('Nespresso', 'Líder en máquinas de café espresso y cápsulas de lujo', 1, GETDATE(), 1),
('Ashley Furniture', 'Muebles de sala y hogar reconocidos mundialmente', 1, GETDATE(), 1),
('Optimum Nutrition', 'Proteínas y suplementación deportiva certificada mundialmente', 1, GETDATE(), 1),
('Nike', 'Calzado e indumentaria líder global en deportes', 1, GETDATE(), 1),
('Chanel', 'Alta perfumería y cosmética de lujo francesa', 1, GETDATE(), 1),
('Sony PlayStation', 'Ecosistema líder de consolas de entretenimiento interactivo', 1, GETDATE(), 1),
('DEWALT', 'Herramientas eléctricas industriales de alta duración amarillas', 1, GETDATE(), 1),
('Castrol', 'Lubricantes automotrices avanzados y sintéticos', 1, GETDATE(), 1),
('Pro Plan', 'Nutrición canina super premium de Nestlé', 1, GETDATE(), 1),
('Apple', 'Innovación móvil, smartwatches y ecosistemas premium', 1, GETDATE(), 1),
('Adidas', 'Ropa deportiva de las tres rayas reconocida mundialmente', 1, GETDATE(), 1);

-- ==========================================
-- 10. Tbl_MarkByProviders (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_MarkByProviders] (markByProviderMarkId, markByProviderProviderId, markByProviderCreatorId, markByProviderCreationDate, markByProviderStatusId) VALUES
(1, 1, 1, GETDATE(), 1),  -- Samsung -> Global Tech
(2, 7, 1, GETDATE(), 1),  -- ASUS -> Gamer Zone
(3, 2, 1, GETDATE(), 1),  -- Levi's -> Textiles Centro
(4, 2, 1, GETDATE(), 1),  -- Zara -> Textiles Centro
(5, 12, 1, GETDATE(), 1), -- Nespresso -> Corp Café
(6, 3, 1, GETDATE(), 1),  -- Ashley -> Importaciones Hogar
(7, 4, 1, GETDATE(), 1),  -- Optimum Nutrition -> Nutrición Avanzada
(8, 15, 1, GETDATE(), 1), -- Nike -> Deportes y Más
(9, 6, 1, GETDATE(), 1),  -- Chanel -> Cosméticos París
(10, 7, 1, GETDATE(), 1), -- Sony -> Gamer Zone
(11, 8, 1, GETDATE(), 1), -- DEWALT -> Herramientas Norte
(12, 9, 1, GETDATE(), 1), -- Castrol -> Automotriz Express
(13, 10, 1, GETDATE(), 1),-- Pro Plan -> Mascotas Felices
(14, 1, 1, GETDATE(), 1), -- Apple -> Global Tech
(15, 15, 1, GETDATE(), 1);-- Adidas -> Deportes y Más

-- ==========================================
-- 11. Tbl_AttributesTypes (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_AttributesTypes] (attributeTypeName, attributeTypeDescription, attributeTypeCreatorId, attributeTypeCreationDate, attributeTypeStatusId) VALUES
('Almacenamiento', 'Capacidad en GB o TB para aparatos digitales', 1, GETDATE(), 1),
('Memoria RAM', 'Capacidad de procesamiento RAM del equipo', 1, GETDATE(), 1),
('Talla Ropa', 'Tallas estándar de vestimenta S, M, L, XL', 1, GETDATE(), 1),
('Talla Calzado', 'Números de calzado US / EU', 1, GETDATE(), 1),
('Color', 'Gamas cromáticas comerciales del producto', 1, GETDATE(), 1),
('Voltaje', 'Requisito eléctrico 110V o 220V', 1, GETDATE(), 1),
('Sabor', 'Variantes gustativas para alimentos o suplementos', 1, GETDATE(), 1),
('Material', 'Composición material (Algodón, Cuero, Titanio)', 1, GETDATE(), 1),
('Peso', 'Masa neta del producto empacado (Kg, Lbs)', 1, GETDATE(), 1),
('Viscosidad', 'Grado SAE para lubricantes de motor', 1, GETDATE(), 1),
('Conectividad', 'Redes inalámbricas soportadas (Wi-Fi 6, Bluetooth 5.2)', 1, GETDATE(), 1),
('Resolución', 'Densidad de píxeles (4K, Full HD, QHD)', 1, GETDATE(), 1),
('Garantía', 'Período cubierto de fábrica contra fallas', 1, GETDATE(), 1),
('Género', 'Público meta de fragancias o cosméticos', 1, GETDATE(), 1),
('Tipo de Cierre', 'Mecanismos de sujeción (Cordones, Cremallera)', 1, GETDATE(), 1);

-- ==========================================
-- 12. Tbl_Currencies (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_Currencies] (currencyName, currencyISO, currencyCode, currencyDescription, currencyCreatorId, currencyCreationDate, currencyStatusId) VALUES
('Dólar Estadounidense', 'USD  ', 840, 'Moneda de transacciones globales del sitio', 1, GETDATE(), 1),
('Córdoba Oro', 'NIO  ', 558, 'Moneda local de facturación en Nicaragua', 1, GETDATE(), 1),
('Euro', 'EUR  ', 978, 'Moneda para operaciones europeas', 1, GETDATE(), 1),
('Peso Mexicano', 'MXN  ', 484, 'Moneda regional México', 1, GETDATE(), 1),
('Colón Costarricense', 'CRC  ', 188, 'Moneda regional Costa Rica', 1, GETDATE(), 1),
('Quetzal Guatemalteco', 'GTQ  ', 320, 'Moneda regional Guatemala', 1, GETDATE(), 1),
('Lempira Hondureño', 'HNL  ', 340, 'Moneda regional Honduras', 1, GETDATE(), 1),
('Libra Esterlina', 'GBP  ', 826, 'Reino Unido divisa', 1, GETDATE(), 1),
('Yen Japonés', 'JPY  ', 392, 'Moneda de transacciones asiáticas', 1, GETDATE(), 1),
('Real Brasileño', 'BRL  ', 986, 'Moneda regional Brasil', 1, GETDATE(), 1),
('Sol Peruano', 'PEN  ', 604, 'Moneda de facturación Perú', 1, GETDATE(), 1),
('Peso Colombiano', 'COP  ', 170, 'Moneda regional Colombia', 1, GETDATE(), 1),
('Peso Chileno', 'CLP  ', 152, 'Moneda regional Chile', 1, GETDATE(), 1),
('Dólar Canadiense', 'CAD  ', 124, 'Moneda Norteamérica Canadá', 1, GETDATE(), 1),
('Dólar Australiano', 'AUD  ', 036, 'Moneda Oceanía Australia', 1, GETDATE(), 1);

-- ==========================================
-- 13. Tbl_Products (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_Products] (productName, productDescription, productProductIdentificatorId, productMarkByProviderId, productCreatorId, productCreationDate, productStatusId) VALUES
('Galaxy S24 Ultra', 'Smartphone con IA integrada y pantalla de titanio', 1, 1, 1, GETDATE(), 1),
('ROG Strix G16', 'Laptop Gamer de alto rendimiento con Intel i9', 2, 2, 1, GETDATE(), 1),
('Camiseta Casual Regular Fit', 'Camiseta Levi''s cómoda 100% algodón', 3, 3, 1, GETDATE(), 1),
('Jeans Skinny de Tiro Alto', 'Jeans elásticos Zara modernos de dama', 4, 4, 1, GETDATE(), 1),
('Essenza Mini Espresso', 'Cafetera compacta de cápsulas de alta presión', 5, 5, 1, GETDATE(), 1),
('Sofá Seccional Reclinable', 'Sofá Ashley espacioso de cuero sintético premium', 6, 6, 1, GETDATE(), 1),
('100% Whey Gold Standard', 'Suplemento proteico aislado para ganancia muscular', 7, 7, 1, GETDATE(), 1),
('Pegasus 40 Running', 'Tenis Nike con amortiguación reactiva React', 8, 8, 1, GETDATE(), 1),
('Bleu de Chanel Parfum', 'Fragancia masculina amaderada sofisticada intensa', 9, 9, 1, GETDATE(), 1),
('PlayStation 5 Slim 1TB', 'Consola con lector de discos y gráficos de nueva generación', 10, 10, 1, GETDATE(), 1),
('Taladro Percutor 20V XR', 'Taladro DEWALT sin escobillas de alta potencia inalámbrico', 11, 11, 1, GETDATE(), 1),
('Edge Professional 5W-30', 'Aceite sintético para motores modernos de alto rendimiento', 12, 12, 1, GETDATE(), 1),
('Adult Performance Chicken', 'Alimento Pro Plan balanceado para perros de alta energía', 13, 13, 1, GETDATE(), 1),
('Apple Watch Series 9', 'Reloj inteligente con sensor avanzado de temperatura', 14, 14, 1, GETDATE(), 1),
('Ultraboost 22 Light', 'Tenis Adidas premium para running con retorno energético', 8, 15, 1, GETDATE(), 1);

-- ==========================================
-- 14. Tbl_AttributeProducts (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_AttributeProducts] (AttributeProductAttributesTypeId, AttributeProductName, AttributeProductDescription, AttributeProductCreatorId, AttributeProductCreationDate, AttributeProductStatusId) VALUES
(1, '512 GB', 'Capacidad masiva para archivos', 1, GETDATE(), 1),
(1, '256 GB', 'Capacidad estándar de almacenamiento', 1, GETDATE(), 1),
(2, '16 GB RAM', 'Ideal para tareas simultáneas exigentes', 1, GETDATE(), 1),
(3, 'Talla M', 'Talla mediana para adultos', 1, GETDATE(), 1),
(3, 'Talla L', 'Talla grande para adultos', 1, GETDATE(), 1),
(4, 'Talla 9 US', 'Medida de calzado americano promedio', 1, GETDATE(), 1),
(4, 'Talla 10 US', 'Medida de calzado americano grande', 1, GETDATE(), 1),
(5, 'Negro Titanio', 'Acabado metalizado oscuro elegante', 1, GETDATE(), 1),
(5, 'Blanco Satín', 'Color blanco con brillo suave', 1, GETDATE(), 1),
(6, '110 Voltios', 'Conexión estándar americana de red', 1, GETDATE(), 1),
(7, 'Vainilla Ice Cream', 'Sabor dulce y cremoso gourmet', 1, GETDATE(), 1),
(7, 'Double Rich Chocolate', 'Sabor intenso a chocolate negro', 1, GETDATE(), 1),
(8, 'Cuero Sintético', 'Material durable de fácil lavado', 1, GETDATE(), 1),
(9, '5 Libras', 'Manojo de peso para suplementación', 1, GETDATE(), 1),
(10, 'SAE 5W-30', 'Índice de viscosidad óptimo para climas cambiantes', 1, GETDATE(), 1);

-- ==========================================
-- 15. Tbl_ProductImages (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_ProductImages] (productImageProductId, productImageURL, productImageDescription, productImageIsPrincipal, productImageCreatorId, productImageCreationDate, productImageStatusId) VALUES
(1, 'https://cdn.ecom.com/p/s24u-front.jpg', 'Vista frontal Galaxy S24 Ultra', 1, 1, GETDATE(), 1),
(1, 'https://cdn.ecom.com/p/s24u-back.jpg', 'Vista trasera del chasis de titanio', 0, 1, GETDATE(), 1),
(2, 'https://cdn.ecom.com/p/strix16.jpg', 'Laptop abierta mostrando el teclado RGB', 1, 1, GETDATE(), 1),
(3, 'https://cdn.ecom.com/p/levis-camiseta.jpg', 'Camiseta colgada frontal', 1, 1, GETDATE(), 1),
(4, 'https://cdn.ecom.com/p/zara-jeans.jpg', 'Modelo posando de frente con Jeans', 1, 1, GETDATE(), 1),
(5, 'https://cdn.ecom.com/p/nespresso-mini.jpg', 'Cafetera operando con taza de café', 1, 1, GETDATE(), 1),
(6, 'https://cdn.ecom.com/p/ashley-sofa.jpg', 'Sofá completo en una sala iluminada', 1, 1, GETDATE(), 1),
(7, 'https://cdn.ecom.com/p/on-whey.jpg', 'Bote de proteína de 5 libras de frente', 1, 1, GETDATE(), 1),
(8, 'https://cdn.ecom.com/p/nike-pegasus.jpg', 'Tenis lateral flotando sobre fondo gris', 1, 1, GETDATE(), 1),
(9, 'https://cdn.ecom.com/p/chanel-bleu.jpg', 'Frasco de perfume elegante iluminado', 1, 1, GETDATE(), 1),
(10, 'https://cdn.ecom.com/p/ps5-slim.jpg', 'Consola vertical junto a su control DualSense', 1, 1, GETDATE(), 1),
(11, 'https://cdn.ecom.com/p/dewalt-drill.jpg', 'Taladro con batería instalada de perfil', 1, 1, GETDATE(), 1),
(12, 'https://cdn.ecom.com/p/castrol-oil.jpg', 'Envase de 1 galón de aceite de frente', 1, 1, GETDATE(), 1),
(13, 'https://cdn.ecom.com/p/proplan-dog.jpg', 'Bolsa de comida mostrando perro de raza', 1, 1, GETDATE(), 1),
(14, 'https://cdn.ecom.com/p/aw-series9.jpg', 'Reloj encendido mostrando interfaz de salud', 1, 1, GETDATE(), 1);

-- ==========================================
-- 16. Tbl_ProductVariableTypes (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_ProductVariableTypes] (productVariableTypeName, productVariableTypeDescription, productVariableTypeCreatorId, productVariableTypeCreationDate, productVariableTypeStatusId) VALUES
('Estándar / Básica', 'Variante regular sin añadidos adicionales', 1, GETDATE(), 1),
('Gama Alta / Pro', 'Variante con mejoras sustanciales en hardware', 1, GETDATE(), 1),
('Paquete Ahorro / Combo', 'Incluye productos secundarios de regalo', 1, GETDATE(), 1),
('Slim / Compacto', 'Diseño reducido con iguales prestaciones', 1, GETDATE(), 1),
('Tamaño Mediano (M)', 'Especificación textil de tamaño intermedio', 1, GETDATE(), 1),
('Tamaño Grande (L)', 'Especificación textil de tamaño espacioso', 1, GETDATE(), 1),
('Calzado 9 US', 'Variante exacta de horma deportiva 9', 1, GETDATE(), 1),
('Calzado 10 US', 'Variante exacta de horma deportiva 10', 1, GETDATE(), 1),
('Voltaje Americano 110V', 'Configuración de fábrica para red eléctrica americana', 1, GETDATE(), 1),
('Sabor Chocolate', 'Variante con saborizantes de chocolate dulce', 1, GETDATE(), 1),
('Sabor Vainilla', 'Variante con extractos de vainilla natural', 1, GETDATE(), 1),
('Fórmula Sintética 1 Galón', 'Presentación química líquida estándar', 1, GETDATE(), 1),
('Saco de 30 Libras', 'Presentación de alimento pesado económico', 1, GETDATE(), 1),
('Caja de Colección', 'Empaque especial rígido con regalos de la marca', 1, GETDATE(), 1),
('Conectividad Cellular + GPS', 'Modelo premium con ranura eSIM independiente', 1, GETDATE(), 1);

-- ==========================================
-- 17. Tbl_ProductVariables (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_ProductVariables] (productVariableProductId, productVariableValue, productVariablePrice, productVariableCurrencyId, productVariableCreatorId, productVariableCreationDate, productVariableStatusId) VALUES
(1, 'Titanio Gris / 512GB', 1299.99, 1, 1, GETDATE(), 1), -- Variante 1 (USD)
(1, 'Negro Onyx / 256GB', 1149.99, 1, 1, GETDATE(), 1),  -- Variante 2 (USD)
(2, '16GB RAM / 1TB SSD', 1599.00, 1, 1, GETDATE(), 1),  -- Variante 3 (USD)
(3, 'Negra / Talla M', 850.00, 2, 1, GETDATE(), 1),      -- Variante 4 (NIO)
(3, 'Blanca / Talla L', 850.00, 2, 1, GETDATE(), 1),     -- Variante 5 (NIO)
(4, 'Denim Azul / Talla 6', 1450.00, 2, 1, GETDATE(), 1), -- Variante 6 (NIO)
(5, 'Negra Mate 110V', 149.99, 1, 1, GETDATE(), 1),       -- Variante 7 (USD)
(6, '3 Cuerpos / Cuero Café', 899.99, 1, 1, GETDATE(), 1),-- Variante 8 (USD)
(7, 'Chocolate / 5 Lbs', 74.99, 1, 1, GETDATE(), 1),      -- Variante 9 (USD)
(8, 'Negro / Talla 9.5 US', 130.00, 1, 1, GETDATE(), 1),  -- Variante 10 (USD)
(9, 'Frasco Atomizador 100ml', 145.00, 1, 1, GETDATE(), 1),-- Variante 11 (USD)
(10, 'Chasis Blanco Core 1TB', 499.99, 1, 1, GETDATE(), 1),-- Variante 12 (USD)
(11, 'Maletín Kit + 2 Baterías', 220.00, 1, 1, GETDATE(), 1),-- Variante 13 (USD)
(12, 'Garrafa 4 Litros Sintético', 1650.00, 2, 1, GETDATE(), 1),-- Variante 14 (NIO)
(14, 'Aluminio Negro 45mm', 429.99, 1, 1, GETDATE(), 1);   -- Variante 15 (USD)

-- ==========================================
-- 18. Tbl_Stocks (15 Inserciones) -> ¡Crítico para la vista!
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_Stocks] (stockProductVariableId, stockQuantity, stockFactoryDate, stockExpirationDate, stockCreatorId, stockCreationDate, stockStatusId) VALUES
(1, 15, '2026-01-10', '2030-01-01', 1, GETDATE(), 1),
(2, 22, '2026-01-12', '2030-01-01', 1, GETDATE(), 1),
(3, 8, '2025-11-20', '2029-11-20', 1, GETDATE(), 1),
(4, 50, '2025-10-01', '2028-10-01', 1, GETDATE(), 1),
(5, 45, '2025-10-01', '2028-10-01', 1, GETDATE(), 1),
(6, 30, '2025-08-15', '2028-08-15', 1, GETDATE(), 1),
(7, 12, '2025-12-01', '2029-12-01', 1, GETDATE(), 1),
(8, 5, '2025-09-10', '2035-09-10', 1, GETDATE(), 1),
(9, 40, '2025-12-15', '2028-12-15', 1, GETDATE(), 1),
(10, 25, '2025-11-01', '2029-11-01', 1, GETDATE(), 1),
(11, 18, '2025-06-01', '2029-06-01', 1, GETDATE(), 1),
(12, 35, '2025-11-15', '2029-11-15', 1, GETDATE(), 1),
(13, 14, '2025-10-10', '2030-10-10', 1, GETDATE(), 1),
(14, 60, '2025-07-22', '2028-07-22', 1, GETDATE(), 1),
(15, 20, '2026-01-05', '2030-01-05', 1, GETDATE(), 1);

-- ==========================================
-- 19. Tbl_Carts (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_Carts] (cartUserId, cartCreatorId, cartCreationDate, cartModificatorId, cartModificationDate, cartStatusId) VALUES
(2, 2, GETDATE(), NULL, NULL, 1),
(3, 3, GETDATE(), NULL, NULL, 1),
(4, 4, GETDATE(), NULL, NULL, 1),
(5, 5, GETDATE(), NULL, NULL, 1),
(6, 6, GETDATE(), NULL, NULL, 1),
(7, 7, GETDATE(), NULL, NULL, 1),
(8, 8, GETDATE(), NULL, NULL, 1),
(9, 9, GETDATE(), NULL, NULL, 1),
(10, 10, GETDATE(), NULL, NULL, 1),
(11, 11, GETDATE(), NULL, NULL, 1),
(12, 12, GETDATE(), NULL, NULL, 1),
(13, 13, GETDATE(), NULL, NULL, 1),
(14, 14, GETDATE(), NULL, NULL, 1),
(15, 15, GETDATE(), NULL, NULL, 1),
(2, 2, GETDATE(), NULL, NULL, 0); -- Historial inactivo

-- ==========================================
-- 20. Tbl_CartDetails (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_CartDetails] (cartDetailCartId, cartDetailProductVariableId, cartDetailPrice, cartDetailQuantity, cartDetailDiscount, cartDetailSubTotal, cartDetailTAX, cartDetailTotal, cartDetailCurrencyId, cartDetailCreatorId, cartDetailCreationDate, cartDetailStatusId) VALUES
(1, 1, 1299.99, 1, 0.00, 1299.99, 195.00, 1494.99, 1, 2, GETDATE(), 1),
(2, 3, 1599.00, 1, 50.00, 1549.00, 232.35, 1781.35, 1, 3, GETDATE(), 1),
(3, 4, 850.00, 2, 0.00, 1700.00, 255.00, 1955.00, 2, 4, GETDATE(), 1),
(4, 7, 149.99, 1, 10.00, 139.99, 21.00, 160.99, 1, 5, GETDATE(), 1),
(5, 9, 74.99, 2, 0.00, 149.98, 22.50, 172.48, 1, 6, GETDATE(), 1),
(6, 11, 145.00, 1, 0.00, 145.00, 21.75, 166.75, 1, 7, GETDATE(), 1),
(7, 12, 499.99, 1, 0.00, 499.99, 75.00, 574.99, 1, 8, GETDATE(), 1),
(8, 13, 220.00, 1, 20.00, 200.00, 30.00, 230.00, 1, 9, GETDATE(), 1),
(9, 15, 429.99, 1, 0.00, 429.99, 64.50, 494.49, 1, 10, GETDATE(), 1),
(10, 2, 1149.99, 1, 0.00, 1149.99, 172.50, 1322.49, 1, 11, GETDATE(), 1),
(11, 5, 850.00, 1, 0.00, 850.00, 127.50, 977.50, 2, 12, GETDATE(), 1),
(12, 6, 1450.00, 1, 50.00, 1400.00, 210.00, 1610.00, 2, 13, GETDATE(), 1),
(13, 8, 899.99, 1, 0.00, 899.99, 135.00, 1034.99, 1, 14, GETDATE(), 1),
(14, 10, 130.00, 2, 0.00, 260.00, 39.00, 299.00, 1, 15, GETDATE(), 1),
(15, 14, 1650.00, 1, 0.00, 1650.00, 247.50, 1897.50, 2, 2, GETDATE(), 1);

-- ==========================================
-- 21. Tbl_PaymentMethodTypes (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_PaymentMethodTypes] (paymentMethodTypeName, paymentMethodTypeDescription, paymentMethodTypeCreatorId, paymentMethodTypeCreationDate, paymentMethodTypeStatusId) VALUES
('Tarjeta de Crédito Visa', 'Pagos mediante pasarela segura Visa', 1, GETDATE(), 1),
('Tarjeta de Crédito Mastercard', 'Pagos mediante pasarela segura Mastercard', 1, GETDATE(), 1),
('PayPal Wallet', 'Transacciones internacionales en línea', 1, GETDATE(), 1),
('Transferencia Bancaria LAFISE', 'Pago diferido por banca electrónica', 1, GETDATE(), 1),
('Transferencia Bancaria BAC', 'Pago diferido por banca electrónica', 1, GETDATE(), 1),
('Apple Pay', 'Pago express mediante dispositivo móvil', 1, GETDATE(), 1),
('Google Pay', 'Pago express mediante dispositivo móvil', 1, GETDATE(), 1),
('Efectivo contra Entrega', 'Pago físico al recibir el paquete', 1, GETDATE(), 1),
('Criptomonedas (USDT)', 'Pago descentralizado mediante blockchain', 1, GETDATE(), 1),
('Tarjeta de Débito Local', 'Tarjetas de débito nacionales', 1, GETDATE(), 1),
('American Express', 'Tarjeta premium internacional', 1, GETDATE(), 1),
('Sinpe Móvil', 'Pago regional simplificado móvil', 1, GETDATE(), 1),
('Plataforma Tigo Money', 'Billetera electrónica celular', 1, GETDATE(), 1),
('Monedero del Sitio (Wallet)', 'Saldo a favor dentro del e-commerce', 1, GETDATE(), 1),
('Pago en Cuotas Ficosa', 'Financiamiento diferido a plazos', 1, GETDATE(), 1);

-- ==========================================
-- 22. Tbl_UserPaymentMethods (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_UserPaymentMethods] (userPaymentMethodUserId, userPaymentMethodPaymentMethodTypeId, userPaymentMethodCardNumber, userPaymentMethodExpirationDate, userPaymentMethodCVV, userPaymentMethodCardHolderName, userPaymentMethodCreatorId, userPaymentMethodCreationDate, userPaymentMethodStatusId) VALUES
(2, 1, HASHBYTES('SHA2_256', '4111222233334444'), HASHBYTES('SHA2_256', '12/28'), HASHBYTES('SHA2_256', '123'), 'JUAN PEREZ', 1, GETDATE(), 1),
(3, 2, HASHBYTES('SHA2_256', '5222333344445555'), HASHBYTES('SHA2_256', '05/29'), HASHBYTES('SHA2_256', '456'), 'MARIA GOMEZ', 1, GETDATE(), 1),
(4, 1, HASHBYTES('SHA2_256', '4333444455556666'), HASHBYTES('SHA2_256', '08/27'), HASHBYTES('SHA2_256', '789'), 'CARLOS LOPEZ', 1, GETDATE(), 1),
(5, 3, HASHBYTES('SHA2_256', 'PAYPAL_ENC_TOKEN1'), HASHBYTES('SHA2_256', '00/00'), HASHBYTES('SHA2_256', '000'), 'ANA RODRIGUEZ', 1, GETDATE(), 1),
(6, 2, HASHBYTES('SHA2_256', '5444555566667777'), HASHBYTES('SHA2_256', '11/30'), HASHBYTES('SHA2_256', '111'), 'LUIS MARTINEZ', 1, GETDATE(), 1),
(7, 1, HASHBYTES('SHA2_256', '4555666677778888'), HASHBYTES('SHA2_256', '02/28'), HASHBYTES('SHA2_256', '222'), 'DIANA CASTILLO', 1, GETDATE(), 1),
(8, 5, HASHBYTES('SHA2_256', 'BAC_TRANS_TOKEN'), HASHBYTES('SHA2_256', '00/00'), HASHBYTES('SHA2_256', '000'), 'ROBERTO SILVA', 1, GETDATE(), 1),
(9, 1, HASHBYTES('SHA2_256', '4666777788889999'), HASHBYTES('SHA2_256', '07/27'), HASHBYTES('SHA2_256', '333'), 'LAURA FLORES', 1, GETDATE(), 1),
(10, 2, HASHBYTES('SHA2_256', '5777888899990000'), HASHBYTES('SHA2_256', '09/29'), HASHBYTES('SHA2_256', '444'), 'FERNANDO RIOS', 1, GETDATE(), 1),
(11, 3, HASHBYTES('SHA2_256', 'PAYPAL_ENC_TOKEN2'), HASHBYTES('SHA2_256', '00/00'), HASHBYTES('SHA2_256', '000'), 'GABRIELA MEZA', 1, GETDATE(), 1),
(12, 1, HASHBYTES('SHA2_256', '4888999900001111'), HASHBYTES('SHA2_256', '04/28'), HASHBYTES('SHA2_256', '555'), 'ALEJANDRO TORRES', 1, GETDATE(), 1),
(13, 8, HASHBYTES('SHA2_256', 'EFECTIVO_TOKEN'), HASHBYTES('SHA2_256', '00/00'), HASHBYTES('SHA2_256', '000'), 'SONIA RUIZ', 1, GETDATE(), 1),
(14, 1, HASHBYTES('SHA2_256', '4999000011112222'), HASHBYTES('SHA2_256', '01/27'), HASHBYTES('SHA2_256', '666'), 'RICARDO MENDOZA', 1, GETDATE(), 1),
(15, 2, HASHBYTES('SHA2_256', '5111000022223333'), HASHBYTES('SHA2_256', '06/28'), HASHBYTES('SHA2_256', '777'), 'VANESSA CRUZ', 1, GETDATE(), 1),
(2, 11, HASHBYTES('SHA2_256', '3777111122223333'), HASHBYTES('SHA2_256', '10/29'), HASHBYTES('SHA2_256', '888'), 'JUAN A PEREZ', 1, GETDATE(), 1);

-- ==========================================
-- 23. Tbl_PaymentOrders (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_PaymentOrders] (orderUserId, orderDeliveryAddress, orderPaymentMethodId, orderSubtotal, orderDiscount, orderShipping, orderTAX, orderTotal, orderCurrencyId, orderCreatorId, orderCreationDate, orderStatusId) VALUES
(2, 1, 1, 1299.99, 0.00, 15.00, 195.00, 1509.99, 1, 2, GETDATE(), 1),
(3, 2, 2, 1599.00, 50.00, 20.00, 232.35, 1801.35, 1, 3, GETDATE(), 4),
(4, 3, 3, 1700.00, 0.00, 150.00, 255.00, 2105.00, 2, 4, GETDATE(), 6),
(5, 4, 4, 139.99, 10.00, 5.00, 21.00, 155.99, 1, 5, GETDATE(), 6),
(6, 5, 5, 149.98, 0.00, 10.00, 22.50, 182.48, 1, 6, GETDATE(), 6),
(7, 6, 6, 145.00, 0.00, 8.00, 21.75, 174.75, 1, 7, GETDATE(), 6),
(8, 7, 7, 499.99, 0.00, 25.00, 75.00, 599.99, 1, 8, GETDATE(), 5),
(9, 8, 8, 200.00, 20.00, 12.00, 30.00, 242.00, 1, 9, GETDATE(), 5),
(10, 9, 9, 429.99, 0.00, 15.00, 64.50, 509.49, 1, 10, GETDATE(), 4),
(11, 10, 10, 1149.99, 0.00, 0.00, 172.50, 1322.49, 1, 11, GETDATE(), 4),
(12, 11, 11, 850.00, 0.00, 80.00, 127.50, 1057.50, 2, 12, GETDATE(), 1),
(13, 12, 12, 1400.00, 50.00, 100.00, 210.00, 1660.00, 2, 13, GETDATE(), 1),
(14, 13, 13, 899.99, 0.00, 35.00, 135.00, 1069.99, 1, 14, GETDATE(), 1),
(15, 14, 14, 260.00, 0.00, 20.00, 39.00, 319.00, 1, 15, GETDATE(), 1),
(2, 1, 1, 1650.00, 0.00, 120.00, 247.50, 2017.50, 2, 2, GETDATE(), 1);

-- ==========================================
-- 24. Tbl_PaymentOrderDetails (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_PaymentOrderDetails] (orderDetailOrderId, orderDetailProductVariableId, orderDetailPrice, orderDetailQuantity, orderDetailDiscount, orderDetailSubTotal, orderDetailTAX, orderDetailTotal, orderDetailCurrencyId, orderDetailCreatorId, orderDetailCreationDate, orderDetailStatusId) VALUES
(1, 1, 1299.99, 1, 0.00, 1299.99, 195.00, 1494.99, 1, 2, GETDATE(), 1),
(2, 3, 1599.00, 1, 50.00, 1549.00, 232.35, 1781.35, 1, 3, GETDATE(), 1),
(3, 4, 850.00, 2, 0.00, 1700.00, 255.00, 1955.00, 2, 4, GETDATE(), 1),
(4, 7, 149.99, 1, 10.00, 139.99, 21.00, 160.99, 1, 5, GETDATE(), 1),
(5, 9, 74.99, 2, 0.00, 149.98, 22.50, 172.48, 1, 6, GETDATE(), 1),
(6, 11, 145.00, 1, 0.00, 145.00, 21.75, 166.75, 1, 7, GETDATE(), 1),
(7, 12, 499.99, 1, 0.00, 499.99, 75.00, 574.99, 1, 8, GETDATE(), 1),
(8, 13, 220.00, 1, 20.00, 200.00, 30.00, 230.00, 1, 9, GETDATE(), 1),
(9, 15, 429.99, 1, 0.00, 429.99, 64.50, 494.49, 1, 10, GETDATE(), 1),
(10, 2, 1149.99, 1, 0.00, 1149.99, 172.50, 1322.49, 1, 11, GETDATE(), 1),
(11, 5, 850.00, 1, 0.00, 850.00, 127.50, 977.50, 2, 12, GETDATE(), 1),
(12, 6, 1450.00, 1, 50.00, 1400.00, 210.00, 1610.00, 2, 13, GETDATE(), 1),
(13, 8, 899.99, 1, 0.00, 899.99, 135.00, 1034.99, 1, 14, GETDATE(), 1),
(14, 10, 130.00, 2, 0.00, 260.00, 39.00, 299.00, 1, 15, GETDATE(), 1),
(15, 14, 1650.00, 1, 0.00, 1650.00, 247.50, 1897.50, 2, 2, GETDATE(), 1);

-- ==========================================
-- 25. Tbl_StockMovementTypes (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_CATALOGS].[Tbl_StockMovementTypes] (stockMovementTypeName, stockMovementTypeDescription, stockMovementTypeCreatorId, stockMovementTypeCreationDate, stockMovementTypeStatusId) VALUES
('Entrada por Compra', 'Ingreso de nuevo stock desde proveedor de fábrica', 1, GETDATE(), 1),
('Salida por Venta', 'Descuento automático por orden completada', 1, GETDATE(), 1),
('Devolución de Cliente', 'Reingreso de producto retornado por garantía', 1, GETDATE(), 1),
('Ajuste por Inventario Físico', 'Corrección manual de auditoría', 1, GETDATE(), 1),
('Producto Dañado', 'Salida del sistema por rotura o avería interna', 1, GETDATE(), 1),
('Muestra de Marketing', 'Retiro de inventario promocional', 1, GETDATE(), 1),
('Transferencia entre Bodegas', 'Movimiento logístico de cambio posicional', 1, GETDATE(), 1),
('Entrada de Emergencia', 'Abastecimiento exprés por alta demanda', 1, GETDATE(), 1),
('Salida por Caducidad', 'Retiro por expiración de vida útil', 1, GETDATE(), 1),
('Robo o Pérdida', 'Baja por reporte de siniestro', 1, GETDATE(), 1),
('Garantía de Proveedor', 'Envío a fábrica original por desperfectos', 1, GETDATE(), 1),
('Donación', 'Salida autorizada corporativa benéfica', 1, GETDATE(), 1),
('Remanufactura', 'Reingreso de producto reparado', 1, GETDATE(), 1),
('Consignación', 'Entrada temporal para exhibición comercial', 1, GETDATE(), 1),
('Liquidación Especial', 'Lote apartado de remates masivos', 1, GETDATE(), 1);

-- ==========================================
-- 26. Tbl_StockMovements (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_StockMovements] (stockMovementType, stockMovementOrderId, stockMovementReference, stockMovementDate, stockMovementCreatorId, stockMovementCreationDate, stockMovementStatusId) VALUES
(1, NULL, 'FAC-PROV-001', GETDATE(), 1, GETDATE(), 1),
(2, 1, 'VENTA-ORD-001', GETDATE(), 1, GETDATE(), 1),
(2, 2, 'VENTA-ORD-002', GETDATE(), 1, GETDATE(), 1),
(2, 3, 'VENTA-ORD-003', GETDATE(), 1, GETDATE(), 1),
(3, NULL, 'DEV-JUAN-02', GETDATE(), 1, GETDATE(), 1),
(4, NULL, 'AJUSTE-ANUAL-26', GETDATE(), 1, GETDATE(), 1),
(5, NULL, 'DANADO-BODEGA-B', GETDATE(), 1, GETDATE(), 1),
(2, 4, 'VENTA-ORD-004', GETDATE(), 1, GETDATE(), 1),
(2, 5, 'VENTA-ORD-005', GETDATE(), 1, GETDATE(), 1),
(2, 6, 'VENTA-ORD-006', GETDATE(), 1, GETDATE(), 1),
(1, NULL, 'FAC-PROV-002', GETDATE(), 1, GETDATE(), 1),
(2, 7, 'VENTA-ORD-007', GETDATE(), 1, GETDATE(), 1),
(2, 8, 'VENTA-ORD-008', GETDATE(), 1, GETDATE(), 1),
(2, 9, 'VENTA-ORD-009', GETDATE(), 1, GETDATE(), 1),
(2, 10, 'VENTA-ORD-010', GETDATE(), 1, GETDATE(), 1);

-- ==========================================
-- 27. Tbl_StockMovementDetails (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_GENERAL].[Tbl_StockMovementDetails] (stockMovementDetailMovementId, stockMovementDetailOrderDetailId, stockMovementDetailStockId, stockMovementDetailQuantity, stockMovementDetailFactoryDate, stockMovementDetailExpirationDate, stockMovementDetailCreatorId, stockMovementDetailCreationDate, stockMovementDetailStatusId) VALUES
(1, NULL, 1, 100, '2026-01-01', '2030-01-01', 1, GETDATE(), 1),
(2, 1, 1, 1, NULL, NULL, 1, GETDATE(), 1),
(3, 2, 3, 1, NULL, NULL, 1, GETDATE(), 1),
(4, 3, 4, 2, NULL, NULL, 1, GETDATE(), 1),
(5, NULL, 1, 1, '2026-01-01', '2030-01-01', 1, GETDATE(), 1),
(6, NULL, 2, 5, '2026-01-02', '2030-01-02', 1, GETDATE(), 1),
(7, NULL, 5, -2, NULL, NULL, 1, GETDATE(), 1),
(8, 4, 7, 1, NULL, NULL, 1, GETDATE(), 1),
(9, 5, 9, 2, NULL, NULL, 1, GETDATE(), 1),
(10, 6, 11, 1, NULL, NULL, 1, GETDATE(), 1),
(11, NULL, 8, 50, '2025-09-10', '2035-09-10', 1, GETDATE(), 1),
(12, 7, 12, 1, NULL, NULL, 1, GETDATE(), 1),
(13, 8, 13, 1, NULL, NULL, 1, GETDATE(), 1),
(14, 9, 15, 1, NULL, NULL, 1, GETDATE(), 1),
(15, 10, 2, 1, NULL, NULL, 1, GETDATE(), 1);

-- ==========================================
-- 28. Tbl_Roles (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_SECURITY].[Tbl_Roles] (roleName, roleDescription, roleCreatorId, roleCreationDate, roleStatusId) VALUES
('Administrador Global', 'Controlador maestro con accesos irrestrictos en todo el software', 1, GETDATE(), 1),
('Cliente Registrado', 'Usuario comprador final habilitado para pasarela y perfiles', 1, GETDATE(), 1),
('Soporte Chatbot Técnico', 'Agente encargado de la supervisión de logs del bot e IA', 1, GETDATE(), 1),
('Gerente de Operaciones', 'Encargado de reportes de ventas masivas y pasarela', 1, GETDATE(), 1),
('Supervisor de Inventario', 'Habilitado para realizar ajustes manuales en almacenes físicos', 1, GETDATE(), 1),
('Editor de Contenido', 'Encargado de subir productos, variantes e imágenes', 1, GETDATE(), 1),
('Contador Fiscal', 'Habilitado para reportes tributarios de órdenes de pago', 1, GETDATE(), 1),
('Encargado de Despacho', 'Modifica el estado logístico de órdenes a "Enviado"', 1, GETDATE(), 1),
('Auditor de Seguridad', 'Revisión y control estricto del log de accesos y tokens', 1, GETDATE(), 1),
('Analista de Marketing', 'Administrador exclusivo de cupones, banners y descuentos', 1, GETDATE(), 1),
('Proveedor Externo', 'Acceso restringido a reportes propios de stock de su marca', 1, GETDATE(), 1),
('Atención al Cliente', 'Modifica perfiles y gestiona reembolsos manuales', 1, GETDATE(), 1),
('Soporte Nivel 2', 'Resolución de conflictos en procesamiento interbancario', 1, GETDATE(), 1),
('Banned / Bloqueado', 'Rol restrictivo temporal automático por fraude informático', 1, GETDATE(), 1),
('Invitado temporal', 'Acceso básico transitorio de carritos anónimos persistentes', 1, GETDATE(), 1);

-- ==========================================
-- 29. Tbl_Permissions (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_SECURITY].[Tbl_Permissions] (permissionName, permissionDescription, permissionModule, permissionCreatorId, permissionCreationDate, permissionStatusId) VALUES
('PRODUCT_CREATE', 'Habilidad para añadir nuevos productos al catálogo', 'CATALOGO', 1, GETDATE(), 1),
('PRODUCT_UPDATE', 'Habilidad para modificar variables y precios', 'CATALOGO', 1, GETDATE(), 1),
('PRODUCT_DELETE', 'Habilidad para dar de baja lógica a productos', 'CATALOGO', 1, GETDATE(), 1),
('ORDER_VIEW_ALL', 'Visualización de transacciones globales de compra', 'ORDENES', 1, GETDATE(), 1),
('ORDER_UPDATE_STATUS', 'Cambio de estados de órdenes de pago', 'ORDENES', 1, GETDATE(), 1),
('STOCK_MANUAL_ADJUST', 'Permite alterar las cantidades de inventario bruto', 'INVENTARIO', 1, GETDATE(), 1),
('USER_BAN_AUTOMATIC', 'Habilidad de bloquear usuarios maliciosos', 'SEGURIDAD', 1, GETDATE(), 1),
('CHATBOT_CONFIG_TEMPLATES', 'Habilidad para modificar textos de plantillas bot', 'CHATBOT', 1, GETDATE(), 1),
('REPORT_GENERATE_FINANCIAL', 'Descarga de balances monetarios en PDF/Excel', 'REPORTES', 1, GETDATE(), 1),
('VIEW_SECRET_CARD_TOKEN', 'Desencriptación temporal controlada de tarjetas', 'SEGURIDAD', 1, GETDATE(), 1),
('PERMISSIONS_ASSIGN_ROLES', 'Asignación matricial de privilegios de sistema', 'SEGURIDAD', 1, GETDATE(), 1),
('MARKETING_COUPON_CREATE', 'Inyección de cupones dinámicos de porcentaje', 'MARKETING', 1, GETDATE(), 1),
('REFUND_EXECUTE', 'Ordenamiento de retornos de dinero a pasarelas', 'ORDENES', 1, GETDATE(), 1),
('PROVIDER_DASHBOARD_VIEW', 'Acceso a la vista simplificada de lotes propios', 'PROVEEDORES', 1, GETDATE(), 1),
('USER_ADDRESS_OVERWRITE', 'Modificación de domicilios por soporte técnico', 'CLIENTES', 1, GETDATE(), 1);

-- ==========================================
-- 30. Tbl_RolePermissions (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_SECURITY].[Tbl_RolePermissions] (rolePermissionRoleId, rolePermissionPermissionId, rolePermissionCreatorId, rolePermissionCreationDate, rolePermissionStatusId) VALUES
(1, 1, 1, GETDATE(), 1),  -- Admin -> Product Create
(1, 2, 1, GETDATE(), 1),  -- Admin -> Product Update
(1, 3, 1, GETDATE(), 1),  -- Admin -> Product Delete
(1, 11, 1, GETDATE(), 1), -- Admin -> Assign Roles
(6, 1, 1, GETDATE(), 1),  -- Editor -> Product Create
(6, 2, 1, GETDATE(), 1),  -- Editor -> Product Update
(5, 6, 1, GETDATE(), 1),  -- Supervisor Inventario -> Stock Adjust
(4, 4, 1, GETDATE(), 1),  -- Gerente -> View All Orders
(4, 9, 1, GETDATE(), 1),  -- Gerente -> Financial Reports
(3, 8, 1, GETDATE(), 1),  -- Soporte Chatbot -> Config Templates
(8, 5, 1, GETDATE(), 1),  -- Encargado Despacho -> Update Order Status
(12, 13, 1, GETDATE(), 1),-- Atención Cliente -> Refund Execute
(12, 15, 1, GETDATE(), 1),-- Atención Cliente -> Address Overwrite
(11, 14, 1, GETDATE(), 1),-- Proveedor Externo -> Provider Dashboard
(9, 7, 1, GETDATE(), 1);  -- Auditor Seguridad -> User Ban

-- ==========================================
-- 31. Tbl_UserRoles (15 Inserciones)
-- ==========================================
INSERT INTO [SQM_SECURITY].[Tbl_UserRoles] (userRoleUserId, userRoleRoleId, userRoleCreatorId, userRoleCreationDate, userRoleStatusId) VALUES
(1, 1, 1, GETDATE(), 1),  -- Admin (System) -> Administrador Global
(2, 2, 1, GETDATE(), 1),  -- Juan Pérez -> Cliente Registrado
(3, 2, 1, GETDATE(), 1),  -- María Gómez -> Cliente Registrado
(4, 4, 1, GETDATE(), 1),  -- Carlos López -> Gerente de Operaciones
(5, 12, 1, GETDATE(), 1), -- Ana Rodríguez -> Atención al Cliente
(6, 5, 1, GETDATE(), 1),  -- Luis Martínez -> Supervisor de Inventario
(7, 6, 1, GETDATE(), 1),  -- Diana Castillo -> Editor de Contenido
(8, 8, 1, GETDATE(), 1),  -- Roberto Silva -> Encargado de Despacho
(9, 3, 1, GETDATE(), 1),  -- Laura Flores -> Soporte Chatbot Técnico
(10, 7, 1, GETDATE(), 1), -- Fernando Ríos -> Contador Fiscal
(11, 9, 1, GETDATE(), 1), -- Gabriela Meza -> Auditor de Seguridad
(12, 10, 1, GETDATE(), 1),-- Alejandro Torres -> Analista de Marketing
(13, 2, 1, GETDATE(), 1), -- Sonia Ruiz -> Cliente Registrado
(14, 2, 1, GETDATE(), 1), -- Ricardo Mendoza -> Cliente Registrado
(15, 2, 1, GETDATE(), 1); -- Vanessa Cruz -> Cliente Registrado
GO
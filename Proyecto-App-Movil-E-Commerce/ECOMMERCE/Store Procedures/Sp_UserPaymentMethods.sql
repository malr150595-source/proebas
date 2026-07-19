USE DB_ECOMMERCE
GO

-- 1. LISTAR MÉTODOS DE PAGO DE UN USUARIO (USANDO TU FUNCIÓN Fn_DecryptByKey)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_UserPaymentMethods]
(
    @userPaymentMethodUserId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- OBLIGATORIO: Abrir la llave simétrica con el certificado antes de usar la función de desencriptado
    OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

    SELECT 
        UPM.userPaymentMethodId,
        UPM.userPaymentMethodUserId,
        UPM.userPaymentMethodPaymentMethodTypeId,
        PMT.paymentMethodTypeName, -- Nombre del catálogo de pago
        
        -- Usamos tu función y enmascaramos para vista del Front-End público (ej: ************1234)
        CASE 
            WHEN UPM.userPaymentMethodCardNumber IS NOT NULL THEN 
                '************' + RIGHT([SQM_SECURITY].Fn_DecryptByKey(UPM.userPaymentMethodCardNumber), 4)
            ELSE NULL 
        END AS userPaymentMethodCardNumber_Masked,
        
        -- Desencriptación completa de Fecha de Expiración mediante tu función escalar
        [SQM_SECURITY].Fn_DecryptByKey(UPM.userPaymentMethodExpirationDate) AS userPaymentMethodExpirationDate,
        
        -- Desencriptación completa del CVV mediante tu función escalar
        [SQM_SECURITY].Fn_DecryptByKey(UPM.userPaymentMethodCVV) AS userPaymentMethodCVV,
        
        UPM.userPaymentMethodCardHolderName,
        UPM.userPaymentMethodCreatorId,
        UPM.userPaymentMethodCreationDate,
        UPM.userPaymentMethodModificatorId,
        UPM.userPaymentMethodModificationDate
    FROM [SQM_GENERAL].[Tbl_UserPaymentMethods] UPM
    INNER JOIN [SQM_CATALOGS].[Tbl_PaymentMethodTypes] PMT 
        ON UPM.userPaymentMethodPaymentMethodTypeId = PMT.paymentMethodTypeId
    WHERE UPM.userPaymentMethodUserId = @userPaymentMethodUserId 
      AND UPM.userPaymentMethodStatusId = 1
    ORDER BY UPM.userPaymentMethodId DESC;

    -- OBLIGATORIO: Cerrar la llave al terminar para liberar la memoria y proteger la sesión
    CLOSE SYMMETRIC KEY KEY_HASH;
END
GO

-- 2. FILTRAR / OBTENER UN MÉTODO DE PAGO CRUDO (PARA LA PASARELA DE PAGOS)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_UserPaymentMethods]
(
    @userPaymentMethodId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- OBLIGATORIO: Abrir la llave simétrica
    OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

    SELECT 
        userPaymentMethodId,
        userPaymentMethodUserId,
        userPaymentMethodPaymentMethodTypeId,
        
        -- Devolvemos los datos reales limpios para procesar la transacción bancaria (Stripe, Paypal, etc.)
        [SQM_SECURITY].Fn_DecryptByKey(userPaymentMethodCardNumber) AS userPaymentMethodCardNumber_Raw,
        [SQM_SECURITY].Fn_DecryptByKey(userPaymentMethodExpirationDate) AS userPaymentMethodExpirationDate,
        [SQM_SECURITY].Fn_DecryptByKey(userPaymentMethodCVV) AS userPaymentMethodCVV,
        
        userPaymentMethodCardHolderName,
        userPaymentMethodCreatorId,
        userPaymentMethodCreationDate,
        userPaymentMethodModificatorId,
        userPaymentMethodModificationDate
    FROM [SQM_GENERAL].[Tbl_UserPaymentMethods]
    WHERE userPaymentMethodId = @userPaymentMethodId 
      AND userPaymentMethodStatusId = 1;

    -- OBLIGATORIO: Cerrar la llave
    CLOSE SYMMETRIC KEY KEY_HASH;
END
GO

-- 3. INSERTAR UN NUEVO MÉTODO DE PAGO (USANDO TU FUNCIÓN Fn_EncryptByKey)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_UserPaymentMethods]
(
    @userPaymentMethodUserId INT,
    @userPaymentMethodPaymentMethodTypeId INT,
    @CardNumber_Raw VARCHAR(256),       
    @ExpirationDate_Raw VARCHAR(256),   
    @CVV_Raw VARCHAR(256),               
    @userPaymentMethodCardHolderName VARCHAR(100),
    @userPaymentMethodCreatorId INT,
    @userPaymentMethodCreationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @userPaymentMethodCreationDate IS NULL SET @userPaymentMethodCreationDate = GETDATE();

        -- 1. Validaciones de campos obligatorios
        IF (@userPaymentMethodUserId IS NULL OR @userPaymentMethodPaymentMethodTypeId IS NULL OR 
            TRIM(ISNULL(@CardNumber_Raw, '')) = '' OR TRIM(ISNULL(@ExpirationDate_Raw, '')) = '' OR 
            TRIM(ISNULL(@CVV_Raw, '')) = '' OR TRIM(ISNULL(@userPaymentMethodCardHolderName, '')) = '' OR 
            @userPaymentMethodCreatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: Todos los datos de la tarjeta y propietarios son mandatorios.';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_insert_user_cards];

        -- OBLIGATORIO: Abrir la llave simétrica antes de mandar a llamar tu función de encriptado
        OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

        INSERT INTO [SQM_GENERAL].[Tbl_UserPaymentMethods]
        (
            userPaymentMethodUserId,
            userPaymentMethodPaymentMethodTypeId,
            userPaymentMethodCardNumber,
            userPaymentMethodExpirationDate,
            userPaymentMethodCVV,
            userPaymentMethodCardHolderName,
            userPaymentMethodCreatorId,
            userPaymentMethodCreationDate,
            userPaymentMethodModificatorId,
            userPaymentMethodModificationDate,
            userPaymentMethodStatusId
        )
        VALUES
        (
            @userPaymentMethodUserId,
            @userPaymentMethodPaymentMethodTypeId,
            [SQM_SECURITY].Fn_EncryptByKey(TRIM(@CardNumber_Raw)),       -- Aplicamos tu función
            [SQM_SECURITY].Fn_EncryptByKey(TRIM(@ExpirationDate_Raw)),   -- Aplicamos tu función
            [SQM_SECURITY].Fn_EncryptByKey(TRIM(@CVV_Raw)),              -- Aplicamos tu función
            TRIM(UPPER(@userPaymentMethodCardHolderName)),                  
            @userPaymentMethodCreatorId,
            @userPaymentMethodCreationDate,
            NULL,
            NULL,
            1
        );

        -- OBLIGATORIO: Cerrar la llave inmediatamente después de las consultas y antes del COMMIT
        CLOSE SYMMETRIC KEY KEY_HASH;

        COMMIT TRANSACTION [trx_insert_user_cards];

        SET @Mensaje = 'Método de pago registrado y cifrado con KEY_HASH (AES_256) con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        -- Si la transacción sigue abierta ante un fallo, cerramos la llave y hacemos el rollback
        IF @@TRANCOUNT > 0 
        BEGIN
            -- Intentamos cerrar la llave de forma segura por si quedó abierta antes del error
            IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'KEY_HASH') CLOSE SYMMETRIC KEY KEY_HASH;
            ROLLBACK TRANSACTION;
        END 
        SET @Mensaje = 'Error interno al guardar método de pago: ' + ERROR_MESSAGE();
        SET @Resultado = 500; 
    END CATCH
END
GO

-- 4. ACTUALIZAR UN MÉTODO DE PAGO (USANDO TU FUNCIÓN Fn_EncryptByKey)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_UserPaymentMethods]
(
    @userPaymentMethodId INT,
    @userPaymentMethodPaymentMethodTypeId INT,
    @CardNumber_Raw VARCHAR(256),
    @ExpirationDate_Raw VARCHAR(256),
    @CVV_Raw VARCHAR(256),
    @userPaymentMethodCardHolderName VARCHAR(100),
    @userPaymentMethodModificatorId INT,
    @userPaymentMethodModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @userPaymentMethodModificationDate IS NULL SET @userPaymentMethodModificationDate = GETDATE();

        -- Validaciones
        IF (@userPaymentMethodId IS NULL OR @userPaymentMethodPaymentMethodTypeId IS NULL OR 
            TRIM(ISNULL(@CardNumber_Raw, '')) = '' OR TRIM(ISNULL(@ExpirationDate_Raw, '')) = '' OR 
            TRIM(ISNULL(@CVV_Raw, '')) = '' OR TRIM(ISNULL(@userPaymentMethodCardHolderName, '')) = '' OR 
            @userPaymentMethodModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: Faltan datos requeridos para la actualización del método de pago.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_UserPaymentMethods] WHERE userPaymentMethodId = @userPaymentMethodId AND userPaymentMethodStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El método de pago seleccionado no existe o está inactivo.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_update_user_cards];

        -- OBLIGATORIO: Abrir la llave simétrica
        OPEN SYMMETRIC KEY KEY_HASH DECRYPTION BY CERTIFICATE CERT_ECOMMERCE;

        UPDATE [SQM_GENERAL].[Tbl_UserPaymentMethods]
        SET 
            userPaymentMethodPaymentMethodTypeId = @userPaymentMethodPaymentMethodTypeId,
            userPaymentMethodCardNumber = [SQM_SECURITY].Fn_EncryptByKey(TRIM(@CardNumber_Raw)),
            userPaymentMethodExpirationDate = [SQM_SECURITY].Fn_EncryptByKey(TRIM(@ExpirationDate_Raw)),
            userPaymentMethodCVV = [SQM_SECURITY].Fn_EncryptByKey(TRIM(@CVV_Raw)),
            userPaymentMethodCardHolderName = TRIM(UPPER(@userPaymentMethodCardHolderName)),
            userPaymentMethodModificatorId = @userPaymentMethodModificatorId,
            userPaymentMethodModificationDate = @userPaymentMethodModificationDate
        WHERE userPaymentMethodId = @userPaymentMethodId AND userPaymentMethodStatusId = 1;

        -- OBLIGATORIO: Cerrar la llave
        CLOSE SYMMETRIC KEY KEY_HASH;

        COMMIT TRANSACTION [trx_update_user_cards];

        SET @Mensaje = 'Método de pago actualizado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
        BEGIN
            IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'KEY_HASH') CLOSE SYMMETRIC KEY KEY_HASH;
            ROLLBACK TRANSACTION;
        END 
        SET @Mensaje = 'Error interno al actualizar: ' + ERROR_MESSAGE();
        SET @Resultado = 500; 
    END CATCH
END
GO

-- 5. ELIMINAR MÉTODO DE PAGO (BAJA LÓGICA - NO REQUIERE APERTURA DE LLAVES)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_UserPaymentMethods]
(
    @userPaymentMethodId INT,
    @userPaymentMethodModificatorId INT,
    @userPaymentMethodModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @userPaymentMethodModificationDate IS NULL SET @userPaymentMethodModificationDate = GETDATE();

        IF (@userPaymentMethodId IS NULL OR @userPaymentMethodModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID del registro y el usuario modificador son requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_UserPaymentMethods] WHERE userPaymentMethodId = @userPaymentMethodId AND userPaymentMethodStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El método de pago no existe o ya fue removido anteriormente.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_user_cards];

        UPDATE [SQM_GENERAL].[Tbl_UserPaymentMethods]
        SET 
            userPaymentMethodStatusId = 0,
            userPaymentMethodModificatorId = @userPaymentMethodModificatorId,
            userPaymentMethodModificationDate = @userPaymentMethodModificationDate
        WHERE userPaymentMethodId = @userPaymentMethodId AND userPaymentMethodStatusId = 1;

        COMMIT TRANSACTION [trx_delete_user_cards];

        SET @Mensaje = 'Método de pago removido con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al eliminar: ' + ERROR_MESSAGE();
        SET @Resultado = 500; 
    END CATCH
END
GO
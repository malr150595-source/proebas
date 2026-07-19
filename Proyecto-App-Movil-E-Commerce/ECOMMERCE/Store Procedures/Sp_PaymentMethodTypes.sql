USE DB_ECOMMERCE
GO

-- 1. LISTAR TODOS LOS TIPOS DE MÉTODOS DE PAGO ACTIVOS
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_PaymentMethodTypes]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        paymentMethodTypeId,
        paymentMethodTypeName,
        paymentMethodTypeDescription,
        paymentMethodTypeCreatorId,
        paymentMethodTypeCreationDate,
        paymentMethodTypeModificatorId,
        paymentMethodTypeModificationDate
    FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes]
    WHERE paymentMethodTypeStatusId = 1
    ORDER BY paymentMethodTypeName ASC;
END
GO

-- 2. FILTRAR / BUSCAR MÉTODOS DE PAGO (Por ID o coincidencia en Nombre/Descripción)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_list_PaymentMethodTypes]
(
    @Filt VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FiltInt INT = TRY_CAST(@Filt AS INT);

    SELECT 
        paymentMethodTypeId,
        paymentMethodTypeName,
        paymentMethodTypeDescription,
        paymentMethodTypeCreatorId,
        paymentMethodTypeCreationDate,
        paymentMethodTypeModificatorId,
        paymentMethodTypeModificationDate
    FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes]
    WHERE paymentMethodTypeStatusId = 1
      AND (
            (@FiltInt IS NOT NULL AND paymentMethodTypeId = @FiltInt)
            OR paymentMethodTypeName LIKE '%' + @Filt + '%'
            OR paymentMethodTypeDescription LIKE '%' + @Filt + '%'
          )
    ORDER BY paymentMethodTypeName ASC;
END
GO

-- 3. INSERTAR UN NUEVO TIPO DE MÉTODO DE PAGO
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_PaymentMethodTypes]
(
    @paymentMethodTypeName VARCHAR(50),
    @paymentMethodTypeDescription VARCHAR(100),
    @paymentMethodTypeCreatorId INT,
    @paymentMethodTypeCreationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @paymentMethodTypeCreationDate IS NULL SET @paymentMethodTypeCreationDate = GETDATE();

        -- 1. Validación de campos obligatorios vacíos
        IF (TRIM(ISNULL(@paymentMethodTypeName, '')) = '' OR TRIM(ISNULL(@paymentMethodTypeDescription, '')) = '' OR @paymentMethodTypeCreatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El nombre, la descripción y el creador son obligatorios.';
            SET @Resultado = 400;
            RETURN;
        END

        -- 2. Evitar nombres duplicados (Ignorando espacios extras al inicio/final)
        IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] WHERE LOWER(TRIM(paymentMethodTypeName)) = LOWER(TRIM(@paymentMethodTypeName)) AND paymentMethodTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: Ya existe un tipo de método de pago activo con este nombre.';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_insert_paytypes];

        INSERT INTO [SQM_CATALOGS].[Tbl_PaymentMethodTypes]
        (
            paymentMethodTypeName,
            paymentMethodTypeDescription,
            paymentMethodTypeCreatorId,
            paymentMethodTypeCreationDate,
            paymentMethodTypeModificatorId,
            paymentMethodTypeModificationDate,
            paymentMethodTypeStatusId
        )
        VALUES
        (
            TRIM(@paymentMethodTypeName),
            TRIM(@paymentMethodTypeDescription),
            @paymentMethodTypeCreatorId,
            @paymentMethodTypeCreationDate,
            NULL,
            NULL,
            1
        );

        COMMIT TRANSACTION [trx_insert_paytypes];

        SET @Mensaje = 'Tipo de método de pago registrado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al insertar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

-- 4. ACTUALIZAR UN TIPO DE MÉTODO DE PAGO
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_PaymentMethodTypes]
(
    @paymentMethodTypeId INT,
    @paymentMethodTypeName VARCHAR(50),
    @paymentMethodTypeDescription VARCHAR(100),
    @paymentMethodTypeModificatorId INT,
    @paymentMethodTypeModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @paymentMethodTypeModificationDate IS NULL SET @paymentMethodTypeModificationDate = GETDATE();

        -- 1. Validar parámetros obligatorios
        IF (@paymentMethodTypeId IS NULL OR TRIM(ISNULL(@paymentMethodTypeName, '')) = '' OR TRIM(ISNULL(@paymentMethodTypeDescription, '')) = '' OR @paymentMethodTypeModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: Todos los campos son obligatorios para la actualización.';
            SET @Resultado = 400;
            RETURN;
        END

        -- 2. Verificar que el registro exista
        IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] WHERE paymentMethodTypeId = @paymentMethodTypeId AND paymentMethodTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El tipo de método de pago no existe o está inactivo.';
            SET @Resultado = 404;
            RETURN;
        END

        -- 3. Evitar duplicidad de nombre con OTROS registros diferentes al que se está editando
        IF EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] WHERE LOWER(TRIM(paymentMethodTypeName)) = LOWER(TRIM(@paymentMethodTypeName)) AND paymentMethodTypeId <> @paymentMethodTypeId AND paymentMethodTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: Ya existe otro método de pago activo registrado con ese nombre.';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_update_paytypes];

        UPDATE [SQM_CATALOGS].[Tbl_PaymentMethodTypes]
        SET 
            paymentMethodTypeName = TRIM(@paymentMethodTypeName),
            paymentMethodTypeDescription = TRIM(@paymentMethodTypeDescription),
            paymentMethodTypeModificatorId = @paymentMethodTypeModificatorId,
            paymentMethodTypeModificationDate = @paymentMethodTypeModificationDate
        WHERE paymentMethodTypeId = @paymentMethodTypeId AND paymentMethodTypeStatusId = 1;

        COMMIT TRANSACTION [trx_update_paytypes];

        SET @Mensaje = 'Tipo de método de pago actualizado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al actualizar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO

-- 5. ELIMINAR TIPO DE MÉTODO DE PAGO (BAJA LÓGICA)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_PaymentMethodTypes]
(
    @paymentMethodTypeId INT,
    @paymentMethodTypeModificatorId INT,
    @paymentMethodTypeModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @paymentMethodTypeModificationDate IS NULL SET @paymentMethodTypeModificationDate = GETDATE();

        IF (@paymentMethodTypeId IS NULL OR @paymentMethodTypeModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID del registro y el usuario modificador son requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_CATALOGS].[Tbl_PaymentMethodTypes] WHERE paymentMethodTypeId = @paymentMethodTypeId AND paymentMethodTypeStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El tipo de método de pago no existe o ya fue removido.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_paytypes];

        UPDATE [SQM_CATALOGS].[Tbl_PaymentMethodTypes]
        SET 
            paymentMethodTypeStatusId = 0,
            paymentMethodTypeModificatorId = @paymentMethodTypeModificatorId,
            paymentMethodTypeModificationDate = @paymentMethodTypeModificationDate
        WHERE paymentMethodTypeId = @paymentMethodTypeId AND paymentMethodTypeStatusId = 1;

        COMMIT TRANSACTION [trx_delete_paytypes];

        SET @Mensaje = 'Tipo de método de pago eliminado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error interno al eliminar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH
END
GO
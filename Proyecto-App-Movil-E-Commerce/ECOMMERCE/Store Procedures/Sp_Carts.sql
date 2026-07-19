USE DB_ECOMMERCE
GO

-- 1. LISTAR TODOS LOS CARRITOS ACTIVOS (Con INNER JOIN para el nombre del usuario)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[List_Carts]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.cartId,
        c.cartUserId,
        u.userFullName AS [userFullNameRef], -- Campo del INNER JOIN
        c.cartCreatorId,
        c.cartCreationDate,
        c.cartModificatorId,
        c.cartModificationDate
    FROM [SQM_GENERAL].[Tbl_Carts] c
    INNER JOIN [SQM_SECURITY].[Tbl_Users] u ON c.cartUserId = u.userId
    WHERE c.cartStatusId = 1
    ORDER BY c.cartId DESC;
END;
GO

-- 2. FILTRAR O BUSCAR UN CARRITO ESPECÍFICO (Por Id de Carrito o Id de Usuario)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Filt_list_Carts](
    @Filt INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.cartId,
        c.cartUserId,
        u.userFullName AS [userFullNameRef], -- Campo del INNER JOIN
        c.cartCreatorId,
        c.cartCreationDate,
        c.cartModificatorId,
        c.cartModificationDate
    FROM [SQM_GENERAL].[Tbl_Carts] c
    INNER JOIN [SQM_SECURITY].[Tbl_Users] u ON c.cartUserId = u.userId
    WHERE c.cartStatusId = 1
      AND (
            c.cartId = @Filt 
            OR c.cartUserId = @Filt
          )
    ORDER BY c.cartId DESC;
END;
GO

-- 3. INSERTAR UN NUEVO CARRITO
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Insert_Carts](
    @cartUserId INT,
    @cartCreatorId INT,
    @cartCreationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @cartCreationDate IS NULL SET @cartCreationDate = GETDATE();

        IF (@cartUserId IS NULL OR @cartCreatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID de usuario y el ID de creador son obligatorios.';
            SET @Resultado = 400;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Carts] WHERE cartUserId = @cartUserId AND cartStatusId = 1)
        BEGIN
            SET @Mensaje = 'Advertencia: El usuario ya posee un carrito de compras activo.';
            SET @Resultado = 400;
            RETURN;
        END

        BEGIN TRANSACTION [trx_insert_carts];

        INSERT INTO [SQM_GENERAL].[Tbl_Carts] (
            cartUserId,
            cartCreatorId,
            cartCreationDate,
            cartModificatorId,
            cartModificationDate,
            cartStatusId
        )
        VALUES (
            @cartUserId,
            @cartCreatorId,
            @cartCreationDate,
            NULL, 
            NULL, 
            1     
        );

        COMMIT TRANSACTION [trx_insert_carts];

        SET @Mensaje = 'Carrito de compras creado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
        BEGIN
            ROLLBACK TRANSACTION;
        END
        SET @Mensaje = 'Error interno al insertar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 4. ACTUALIZAR UN CARRITO
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Update_Carts](
    @cartId INT,
    @cartUserId INT,
    @cartModificatorId INT,
    @cartModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @cartModificationDate IS NULL SET @cartModificationDate = GETDATE();

        IF (@cartId IS NULL OR @cartUserId IS NULL OR @cartModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID de carrito, ID de usuario y el ID del modificador son obligatorios.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Carts] WHERE cartId = @cartId AND cartStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El carrito especificado no existe o ya fue cerrado/eliminado.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_update_carts];

        UPDATE [SQM_GENERAL].[Tbl_Carts]
        SET  cartUserId = @cartUserId,
             cartModificatorId = @cartModificatorId,
             cartModificationDate = @cartModificationDate
        WHERE cartId = @cartId AND cartStatusId = 1;

        COMMIT TRANSACTION [trx_update_carts];

        SET @Mensaje = 'Carrito actualizado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
        BEGIN
            ROLLBACK TRANSACTION;
        END
        SET @Mensaje = 'Error interno al actualizar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO

-- 5. ELIMINAR CARRITO (BAJA LÓGICA)
CREATE OR ALTER PROCEDURE [SQM_GENERAL].[Delete_Carts](
    @cartId INT,
    @cartModificatorId INT,
    @cartModificationDate DATETIME = NULL,
    @Mensaje VARCHAR(250) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @cartModificationDate IS NULL SET @cartModificationDate = GETDATE();

        IF (@cartId IS NULL OR @cartModificatorId IS NULL)
        BEGIN
            SET @Mensaje = 'Error: El ID del carrito y el ID del modificador son requeridos.';
            SET @Resultado = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_GENERAL].[Tbl_Carts] WHERE cartId = @cartId AND cartStatusId = 1)
        BEGIN
            SET @Mensaje = 'Error: El carrito de compras no existe o ya se encuentra inactivo.';
            SET @Resultado = 404;
            RETURN;
        END

        BEGIN TRANSACTION [trx_delete_carts];

        UPDATE [SQM_GENERAL].[Tbl_Carts]
        SET cartStatusId = 0,
            cartModificatorId = @cartModificatorId,
            cartModificationDate = @cartModificationDate
        WHERE cartId = @cartId AND cartStatusId = 1;

        COMMIT TRANSACTION [trx_delete_carts];

        SET @Mensaje = 'Carrito eliminado/desactivado con éxito.';
        SET @Resultado = 200;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
        BEGIN
            ROLLBACK TRANSACTION;
        END
        SET @Mensaje = 'Error interno al eliminar: ' + ERROR_MESSAGE();
        SET @Resultado = 500;
    END CATCH;
END;
GO
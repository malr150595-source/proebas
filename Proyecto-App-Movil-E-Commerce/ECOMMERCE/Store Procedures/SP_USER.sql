USE [DB_ECOMMERCE]
GO

---------------------------------------------------------------------------------
-- 1. LISTADO DE USUARIOS
---------------------------------------------------------------------------------
CREATE OR ALTER PROC [SQM_SECURITY].[List_Users]
AS 
BEGIN 
    SET NOCOUNT ON;
    SELECT 
        U.userId as [UserId],
        U.userFullName as [UserFullName],
        U.userName as [UserName],
        U.userEmail as [UserEmail],
        U.userPhoneNumber as [UserPhoneNumber],
        U.userCountryId as [UserCountryId],
        U.userGenderId as [UserGenderId],
        U.userBirthDay as [UserBirthDay],
        U.userCreatorId as [UserCreatorId],
        U.userCreationDate as [UserCreationDate],
        U.userModificatorId as [UserModificatorId],
        U.userModificationDate as [UserModificationDate],
        S.statusName as [Status]
    FROM [SQM_SECURITY].[Tbl_Users] AS U
    INNER JOIN [SQM_CATALOGS].[Tbl_Status] as S ON U.userStatusId = S.statusId 
    WHERE U.userStatusId = 1
    order by U.userId desc
END
GO

---------------------------------------------------------------------------------
-- 2. FILTRADO DE USUARIOS
---------------------------------------------------------------------------------
CREATE OR ALTER PROC [SQM_SECURITY].[Filt_List_Users]
(
    @CRITERIO NVARCHAR(100)
)
AS 
BEGIN 
    SET NOCOUNT ON;
    SELECT 
        U.userId as [UserId],
        U.userFullName as [UserFullName],
        U.userName as [UserName],
        U.userEmail as [UserEmail],
        U.userPhoneNumber as [UserPhoneNumber],
        U.userCountryId as [UserCountryId],
        U.userGenderId as [UserGenderId],
        U.userBirthDay as [UserBirthDay],
        U.userCreatorId as [UserCreatorId],
        U.userCreationDate as [UserCreationDate],
        U.userModificatorId as [UserModificatorId],
        U.userModificationDate as [UserModificationDate],
        S.statusName as [Status]
    FROM [SQM_SECURITY].[Tbl_Users] AS U
    INNER JOIN [SQM_CATALOGS].[Tbl_Status] as S ON U.userStatusId = S.statusId
    WHERE U.userStatusId = 1
    AND (
        @CRITERIO IS NULL
        OR U.userFullName LIKE '%' + @CRITERIO + '%'
        OR U.userName LIKE '%' + @CRITERIO + '%'
        OR U.userEmail LIKE '%' + @CRITERIO + '%'
        -- CORREGIDO: TRY_CAST devuelve NULL si no es un número, evitando el error de conversión
        OR U.userId = TRY_CAST(@CRITERIO AS INT) 
    )
    ORDER BY U.userFullName DESC;
END
GO
---------------------------------------------------------------------------------
-- 3. INSERTAR USUARIOS (SHA2_256)
---------------------------------------------------------------------------------
CREATE OR ALTER PROC [SQM_SECURITY].[Insert_Users]
(
    @UserFullName NVARCHAR(100),
    @UserName NVARCHAR(50),
    @UserPasswordText VARCHAR(256), 
    @UserEmail NVARCHAR(100),
    @UserPhoneNumber NVARCHAR(20),
    @UserCountryId INT,
    @UserGenderId INT,
    @UserBirthDay DATE,
    @UserCreatorId INT,
    @UserCreationDate DATETIME,
    @MENSAJE NVARCHAR(255) OUTPUT,
    @RESULTADO INT OUTPUT
) 
AS 
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY 
        IF (@UserCreationDate IS NULL)
            SET @UserCreationDate = GETDATE();

        IF (ISNULL(@UserFullName, '') = '' 
            OR @UserName IS NULL 
            OR ISNULL(@UserPasswordText, '') = '')
        BEGIN
            SET @MENSAJE = 'FALTAN DATOS OBLIGATORIOS.';
            SET @RESULTADO = 400;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] 
            WHERE userName = TRIM(@UserName) AND userStatusId = 1
        )
        BEGIN 
            SET @MENSAJE = 'EL NOMBRE DE USUARIO YA EXISTE.';
            SET @RESULTADO = 400;
            RETURN;
        END

        DECLARE @PasswordHashed VARBINARY(256);
        SET @PasswordHashed = HASHBYTES('SHA2_256', @UserPasswordText);
        
        IF EXISTS (
            SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] 
            WHERE userName = TRIM(@UserName) AND userStatusId = 0
        )
        BEGIN 
            BEGIN TRANSACTION;
            UPDATE [SQM_SECURITY].[Tbl_Users]
            SET userStatusId = 1,
                userFullName = TRIM(@UserFullName),
                userEmail = TRIM(@UserEmail),
                userPassword = @PasswordHashed,
                userPhoneNumber = TRIM(@UserPhoneNumber),
                userCountryId = @UserCountryId,
                userGenderId = @UserGenderId,
                userBirthDay = @UserBirthDay,
                userModificatorId = @UserCreatorId,
                userModificationDate = @UserCreationDate
            WHERE userName = TRIM(@UserName) AND userStatusId = 0;
            COMMIT TRANSACTION;

            SET @MENSAJE = 'USUARIO REACTIVADO EXITOSAMENTE.';
            SET @RESULTADO = 201;
            RETURN;
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION;
            INSERT INTO [SQM_SECURITY].[Tbl_Users] (
                userFullName,
                userName,
                userPassword,
                userEmail,
                userPhoneNumber,
                userCountryId,
                userGenderId,
                userBirthDay,
                userCreatorId,
                userCreationDate,
                userStatusId
            ) VALUES (
                TRIM(@UserFullName),
                TRIM(@UserName),
                @PasswordHashed, 
                TRIM(@UserEmail),
                TRIM(@UserPhoneNumber),
                @UserCountryId,
                @UserGenderId,
                @UserBirthDay,
                @UserCreatorId,
                @UserCreationDate,
                1
            );
            COMMIT TRANSACTION;

            SET @MENSAJE = 'USUARIO CREADO EXITOSAMENTE.';
            SET @RESULTADO = 200;
        END
    END TRY
    BEGIN CATCH
       IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
       SET @MENSAJE = 'ERROR AL CREAR EL USUARIO: ' + ERROR_MESSAGE();
       SET @RESULTADO = 500;
    END CATCH
END
GO

---------------------------------------------------------------------------------
-- 4. ACTUALIZAR USUARIOS (SHA2_256)
---------------------------------------------------------------------------------
CREATE OR ALTER PROC [SQM_SECURITY].[Update_Users]
(
    @UserId INT,
    @UserFullName NVARCHAR(100),
    @UserName NVARCHAR(50),
    @UserPasswordText VARCHAR(256) NULL, 
    @UserEmail NVARCHAR(100),
    @UserPhoneNumber NVARCHAR(20),
    @UserCountryId INT,
    @UserGenderId INT,
    @UserBirthDay DATE,
    @UserModificatorId INT,
    @UserModificationDate DATETIME,
    @MENSAJE NVARCHAR(255) OUTPUT,
    @RESULTADO INT OUTPUT
) 
AS 
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@UserModificationDate IS NULL)
            SET @UserModificationDate = GETDATE();

        IF (@UserId IS NULL 
            OR ISNULL(@UserFullName, '') = '' 
            OR @UserModificatorId IS NULL)
        BEGIN 
            SET @MENSAJE = 'FALTAN DATOS OBLIGATORIOS.';
            SET @RESULTADO = 400;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @UserId AND userStatusId = 1)
        BEGIN
            SET @MENSAJE = 'EL USUARIO NO EXISTE.';
            SET @RESULTADO = 400;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] 
            WHERE userName = TRIM(@UserName) AND userId <> @UserId AND userStatusId = 1
        )
        BEGIN
            SET @MENSAJE = 'EL NOMBRE DE USUARIO YA EXISTE.';
            SET @RESULTADO = 400;
            RETURN;
        END

        DECLARE @PasswordHashed VARBINARY(256);
        IF (ISNULL(@UserPasswordText, '') <> '')
            SET @PasswordHashed = HASHBYTES('SHA2_256', @UserPasswordText);
        ELSE
            SELECT @PasswordHashed = userPassword FROM [SQM_SECURITY].[Tbl_Users] WHERE userId = @UserId;

        BEGIN TRANSACTION;
        UPDATE [SQM_SECURITY].[Tbl_Users]
        SET userFullName = TRIM(@UserFullName),
            userName = TRIM(@UserName),
            userPassword = @PasswordHashed, 
            userEmail = TRIM(@UserEmail),
            userPhoneNumber = TRIM(@UserPhoneNumber),
            userCountryId = @UserCountryId,
            userGenderId = @UserGenderId,
            userBirthDay = @UserBirthDay,
            userModificatorId = @UserModificatorId,
            userModificationDate = @UserModificationDate,
            userStatusId = 1
        WHERE userId = @UserId AND userStatusId = 1;
        COMMIT TRANSACTION;

        SET @MENSAJE = 'USUARIO ACTUALIZADO EXITOSAMENTE.';
        SET @RESULTADO = 200;
    END TRY
    BEGIN CATCH
       IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
       SET @MENSAJE = 'ERROR AL ACTUALIZAR EL USUARIO: ' + ERROR_MESSAGE();
       SET @RESULTADO = 500;
    END CATCH
END
GO

---------------------------------------------------------------------------------
-- 5. VALIDAR LOGIN (SHA2_256)
---------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE [SQM_SECURITY].[SP_ValidateUserLogin]
    @Email NVARCHAR(150),
    @PasswordText VARCHAR(256),
    @Resultado INT OUTPUT,
    @Mensaje NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        
        IF ISNULL(@Email, '') = '' OR ISNULL(@PasswordText, '') = ''
        BEGIN
            SET @Resultado = 400;
            SET @Mensaje = 'Los campos de autenticación son obligatorios.';
            RETURN;
        END

        IF NOT EXISTS (
            SELECT 1 FROM [SQM_SECURITY].[Tbl_Users] 
            WHERE ([userEmail] = @Email OR [userName] = @Email) AND [userStatusId] = 1
        )
        BEGIN
            SET @Resultado = 401;
            SET @Mensaje = 'El correo electrónico no se encuentra registrado o la cuenta está inactiva.';
            RETURN;
        END

        DECLARE @UserId INT;
        DECLARE @FullName NVARCHAR(200);

        SELECT 
            @UserId = [userId],
            @FullName = [userFullName]
        FROM [SQM_SECURITY].[Tbl_Users]
        WHERE ([userEmail] = @Email OR [userName] = @Email) 
          AND [userPassword] = HASHBYTES('SHA2_256', @PasswordText) 
          AND [userStatusId] = 1;

        IF @UserId IS NULL
        BEGIN
            SET @Resultado = 400;
            SET @Mensaje = 'Contraseña incorrecta. Inténtelo de nuevo.';
            RETURN;
        END

        SET @Resultado = 200;
        SET @Mensaje = 'Autenticación exitosa.';

        -- ▄ MODIFICADO: Obtenemos el Rol asignado de manera directa
        SELECT 
            U.[userId] AS UserId,
            U.[userFullName] AS FullName,
            @Email AS Email,
            ISNULL(R.[roleName], 'Cliente Registrado') AS UserRole
        FROM [SQM_SECURITY].[Tbl_Users] U
        LEFT JOIN [SQM_SECURITY].[Tbl_UserRoles] UR ON U.userId = UR.userRoleUserId AND UR.userRoleStatusId = 1
        LEFT JOIN [SQM_SECURITY].[Tbl_Roles] R ON UR.userRoleRoleId = R.roleId AND R.roleStatusId = 1
        WHERE U.userId = @UserId;

    END TRY
    BEGIN CATCH
        SET @Resultado = 500;
        SET @Mensaje = 'Error interno en el servidor de base de datos: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
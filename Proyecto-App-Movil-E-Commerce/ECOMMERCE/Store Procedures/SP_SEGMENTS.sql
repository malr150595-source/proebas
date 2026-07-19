USE [DB_ECOMMERCE]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[List_Segments]
AS
BEGIN 
    SET NOCOUNT ON;
    SELECT 
        s.segmentId AS [Id],
        s.segmentName AS [Nombre],
        s.segmentDescription AS [Descripción],
        s.segmentCreatorId AS [IdCreador],
        s.segmentCreationDate AS [FechaCreación],
        s.segmentModificatorId AS [IdModificador],
        s.segmentModificationDate AS [FechaModificación]
    FROM [SQM_CATALOGS].[Tbl_Segments] AS s
    WHERE s.segmentStatusId = 1
    ORDER BY s.segmentId DESC;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_List_Segments](
    @filtro NVARCHAR(50) = NULL
)
AS
BEGIN 
    SET NOCOUNT ON;
    SELECT 
        s.segmentId AS [Id],
        s.segmentName AS [Nombre],
        s.segmentDescription AS [Descripción],
        s.segmentCreatorId AS [IdCreador],
        s.segmentCreationDate AS [FechaCreación],
        s.segmentModificatorId AS [IdModificador],
        s.segmentModificationDate AS [FechaModificación]
    FROM [SQM_CATALOGS].[Tbl_Segments] AS s
    WHERE s.segmentStatusId = 1
      AND (
            @filtro IS NULL OR TRIM(@filtro) = ''
            OR s.segmentName LIKE '%' + @filtro + '%'
            OR s.segmentDescription LIKE '%' + @filtro + '%'
            OR s.segmentId = TRY_CAST(@filtro AS INT)
          );
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_Segments](
    @SegmentName VARCHAR(50) NULL,
    @SegmentDescription VARCHAR(100) NULL,
    @SegmentCreatorId INT NULL,
    @SegmentCreationDate DATETIME NULL,
    @Mensaje NVARCHAR(100) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@SegmentCreationDate IS NULL)
        BEGIN 
            SET @SegmentCreationDate = GETDATE()
        END 

        IF (ISNULL(TRIM(@SegmentName), '') = '' 
            OR ISNULL(TRIM(@SegmentDescription), '') = '' 
            OR @SegmentCreatorId IS NULL)
        BEGIN 
            SET @Mensaje = 'Faltan datos obligatorios'
            SET @Resultado = 400
            RETURN
        END 

        IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Users]
        WHERE userId = @SegmentCreatorId AND userStatusId = 1)
        BEGIN
            SET @Mensaje = 'El usuario creador no existe o está inactivo'
            SET @Resultado = 400
            RETURN
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Segments] 
                  WHERE segmentName = TRIM(@SegmentName) AND segmentStatusId = 1)
        BEGIN 
            SET @Mensaje = 'El segmento existe'
            SET @Resultado = 400
            RETURN
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Segments] 
                  WHERE segmentName = TRIM(@SegmentName) AND segmentStatusId = 0)
        BEGIN 
            BEGIN TRANSACTION;
            UPDATE [SQM_CATALOGS].[Tbl_Segments]
            SET segmentStatusId = 1,
                segmentDescription = TRIM(@SegmentDescription),
                segmentModificatorId = @SegmentCreatorId,
                segmentModificationDate = @SegmentCreationDate
            WHERE segmentName = TRIM(@SegmentName) AND segmentStatusId = 0;
            COMMIT TRANSACTION;

            SET @Mensaje = 'Segmento reactivado'
            SET @Resultado = 201
            RETURN
        END
        ELSE
        BEGIN 
            BEGIN TRANSACTION;
            INSERT INTO [SQM_CATALOGS].[Tbl_Segments] (
                segmentName,
                segmentDescription,
                segmentCreatorId,
                segmentCreationDate,
                segmentStatusId
            )
            VALUES (
                TRIM(@SegmentName),
                TRIM(@SegmentDescription),
                @SegmentCreatorId,
                @SegmentCreationDate,
                1
            );
            COMMIT TRANSACTION;

            SET @Mensaje = 'Segmento creado'
            SET @Resultado = 200
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al crear: ' + ERROR_MESSAGE()
        SET @Resultado = 500
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_Segments](
    @SegmentId INT,
    @SegmentName VARCHAR(50) NULL,
    @SegmentDescription VARCHAR(100) NULL,
    @SegmentModificatorId INT NULL,
    @SegmentModificationDate DATETIME NULL,
    @Mensaje NVARCHAR(100) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        IF(@SegmentModificationDate IS NULL)
        BEGIN 
            SET @SegmentModificationDate = GETDATE()
        END

        IF(@SegmentId IS NULL OR ISNULL(TRIM(@SegmentName), '') = '' 
        OR @SegmentModificatorId IS NULL)
        BEGIN 
            SET @Mensaje = 'Faltan datos obligatorios'
            SET @Resultado = 400
            RETURN
        END

        IF NOT EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Segments] 
                      WHERE segmentId = @SegmentId AND segmentStatusId = 1)
        BEGIN 
            SET @Mensaje = 'El segmento no existe'
            SET @Resultado = 400
            RETURN
        END

        IF NOT EXISTS(SELECT 1 FROM [SQM_SECURITY].[Tbl_Users]
        WHERE userId = @SegmentModificatorId AND userStatusId = 1)
        BEGIN
            SET @Mensaje = 'El usuario modificador no existe o está inactivo'
            SET @Resultado = 400
            RETURN
        END

        IF EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Segments] 
                  WHERE 
                  (
                  segmentName = TRIM(@SegmentName)
                  or segmentName = LOWER(trim(@SegmentName))
                  )AND segmentStatusId = 1 AND segmentId <> @SegmentId)
        BEGIN 
            SET @Mensaje = 'Otro segmento con el mismo nombre ya existe'
            SET @Resultado = 400
            RETURN
        END
        ELSE 
        BEGIN 
            BEGIN TRANSACTION;
            UPDATE [SQM_CATALOGS].[Tbl_Segments]
            SET segmentName = TRIM(@SegmentName),
                segmentDescription = TRIM(@SegmentDescription),
                segmentModificatorId = @SegmentModificatorId,
                segmentModificationDate = @SegmentModificationDate,
                segmentStatusId = 1
            WHERE segmentId = @SegmentId;
            COMMIT TRANSACTION;

            SET @Mensaje = 'Segmento actualizado correctamente'
            SET @Resultado = 200
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al actualizar: ' + ERROR_MESSAGE()
        SET @Resultado = 500
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Delete_Segments](
    @SegmentId INT,
    @SegmentModificatorId INT NULL,
    @SegmentModificationDate DATETIME NULL,
    @Mensaje NVARCHAR(100) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN 
    SET NOCOUNT ON;
    BEGIN TRY
        IF (@SegmentModificationDate IS NULL)
        BEGIN 
            SET @SegmentModificationDate = GETDATE()
        END

        IF NOT EXISTS(SELECT 1 FROM [SQM_CATALOGS].[Tbl_Segments] 
                      WHERE segmentId = @SegmentId AND segmentStatusId = 1)
        BEGIN 
            SET @Mensaje = 'El segmento no existe'
            SET @Resultado = 400
            RETURN
        END
        ELSE
        BEGIN
            BEGIN TRANSACTION;
            UPDATE [SQM_CATALOGS].[Tbl_Segments]
            SET segmentStatusId = 0,
                segmentModificatorId = @SegmentModificatorId,
                segmentModificationDate = @SegmentModificationDate
            WHERE segmentId = @SegmentId;
            COMMIT TRANSACTION;

            SET @Mensaje = 'Segmento eliminado'
            SET @Resultado = 200
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Mensaje = 'Error al eliminar: ' + ERROR_MESSAGE()
        SET @Resultado = 500
    END CATCH
END
GO
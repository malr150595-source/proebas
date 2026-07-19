USE [DB_EcommerceAgent]
GO

CREATE OR ALTER PROCEDURE [dbo].[Sp_HistorialConversaciones_Cerrar]
    @UsuarioID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE [dbo].[HistorialConversaciones]
    SET [FechaFin] = GETDATE(),
        [Activo] = 0
    WHERE LOWER(TRIM([UsuarioID])) = LOWER(TRIM(@UsuarioID)) AND [Activo] = 1;
END;
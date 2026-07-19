Use DB_ECOMMERCE
Go
--Listar todas las subcategorías activas
Create or alter procedure [SQM_CATALOGS].[List_SubCategories]
as
BEGIN 
Select 
s.subCategoryId as [Id],
s.subCategoryName as [Nombre],
s.subCategoryDescription as [Descripción],
s.subCategoryCreatorId as [IdCreador],
s.subCategoryCreationDate as [FechaCreación],
s.subCategoryModificatorId as [IdModificador],
S.subCategoryModificationDate as [FechaModificación]
From [SQM_CATALOGS].[Tbl_SubCategories] as s
Where s.subCategoryStatusId = 1
order by s.subCategoryId desc
END
Go
--Listar subcategorías por filtro de nombre o id
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Filt_List_SubCategories](
    @filtro NVARCHAR(50) = NULL
)
AS
BEGIN 
    SET NOCOUNT ON;
    SELECT 
        s.subCategoryId AS [Id],
        s.subCategoryName AS [Nombre],
        s.subCategoryDescription AS [Descripción],
        s.subCategoryCreatorId AS [IdCreador],
        s.subCategoryCreationDate AS [FechaCreación],
        s.subCategoryModificatorId AS [IdModificador],
        s.subCategoryModificationDate AS [FechaModificación]
    FROM [SQM_CATALOGS].[Tbl_SubCategories] AS s
    WHERE s.subCategoryStatusId = 1
      AND (
            @filtro IS NULL OR TRIM(@filtro) = ''
            OR s.subCategoryName LIKE '%' + @filtro + '%'
            -- Solución definitiva: Si es 'Niños', TRY_CAST devuelve NULL de inmediato de forma segura
            OR s.subCategoryId = TRY_CAST(@filtro AS INT)
          );
END
GO
/*Insertar nueva subcategoría, 
si ya existe pero está inactiva, se reactiva con los nuevos datos*/
Create or alter procedure [SQM_CATALOGS].[Insert_SubCategories]
(
	@subCategoryName VARCHAR(50) NULL,
	@subCategoryDescription VARCHAR(100) NULL,
	@subCategoryCreatorId INT NULL,
	@subCategoryCreationDate DATETIME NULL,
	@Mensaje NVARCHAR(100) OUTPUT,
	@Resultado INT OUTPUT
)
as
BEGIN 
	Begin try
		if(@subCategoryCreationDate IS NULL)
		begin 
			set @subCategoryCreationDate = GETDATE()
		end 

		if (@subCategoryName IS NULL 
		or @subCategoryDescription IS NULL 
		or @subCategoryCreatorId IS NULL)
		begin 
			set @Mensaje = 'Faltan datos obligatorios'
			set @Resultado = 400
			return
		end 

		if exists(Select 1 from [SQM_CATALOGS].[Tbl_SubCategories] 
		where subCategoryName = Trim(@subCategoryName) and subCategoryStatusId = 1)
		begin 
			set @Mensaje = 'La subcategoría ya existe'
			set @Resultado = 400
			Return
		end

		if exists(Select 1 from [SQM_CATALOGS].[Tbl_SubCategories] 
		where subCategoryName = Trim(@subCategoryName) and subCategoryStatusId = 0)
		begin 
			begin transaction [trx_reactivate_subcaterories]
			update [SQM_CATALOGS].[Tbl_SubCategories]
			set subCategoryStatusId = 1,
			subCategoryDescription = Trim(@subCategoryDescription),
			subCategoryModificatorId = @subCategoryCreatorId,
			subCategoryModificationDate = @subCategoryCreationDate
			where subCategoryName = Trim(@subCategoryName)
			and subCategoryStatusId = 0
			commit transaction [trx_reactivate_subcaterories]
			set @Mensaje = 'Subcategoría reactivada'
			set @Resultado = 1
			Return
		end

		else
		begin 
		Begin transaction [trx_insert_SubCategories]
			insert into [SQM_CATALOGS].[Tbl_SubCategories]
			(
				subCategoryName,
				subCategoryDescription,
				subCategoryCreatorId,
				subCategoryCreationDate,
				subCategoryStatusId
			)
			values
			(
				Trim(@subCategoryName),
				Trim(@subCategoryDescription),
				@subCategoryCreatorId,
				@subCategoryCreationDate,
				1
			)
			Commit transaction [trx_insert_SubCategories]
			set @Mensaje = 'Subcategoría creada correctamente'
			set @Resultado = 200
		end
	End try

	Begin catch
		if @@TRANCOUNT > 0
		Rollback transaction
		set @Mensaje = 'Error al crear la subcategoría: ' + ERROR_MESSAGE()
		set @Resultado = 500
	End catch
END
Go
/*Actualizar subcategoría, 
si se intenta cambiar el nombre a uno que ya existe,
no se permite la actualización*/
Create or alter procedure [SQM_CATALOGS].[Update_SubCategories]
(
	@subCategoryId INT,
	@subCategoryName VARCHAR(50) NULL,
	@subCategoryDescription VARCHAR(100) NULL,
	@subCategoryModificatorId INT NULL,
	@subCategoryModificationDate DATETIME NULL,
	@Mensaje NVARCHAR(100) OUTPUT,
	@Resultado INT OUTPUT
)
as
BEGIN 
	Begin try
		if(@subCategoryModificationDate IS NULL)
		begin 
			set @subCategoryModificationDate = GETDATE()
		end

		if(@subCategoryId IS NULL 
		OR @subCategoryName IS NULL)
		begin 
			Set @Mensaje = 'Faltan datos obligatorios'
			set @Resultado = 400
			return
		end

		if not exists(Select 1 from [SQM_CATALOGS].[Tbl_SubCategories] 
		where subCategoryId = @subCategoryId and subCategoryStatusId = 1)
		begin 
			set @Mensaje = 'La subcategoría no existe'
			set @Resultado = 400
			return
		end

		if exists(Select 1 from [SQM_CATALOGS].[Tbl_SubCategories] 
		where subCategoryName = Trim(@subCategoryName) and subCategoryStatusId = 1
		and subCategoryId <> @subCategoryId)
		begin 
			set @Mensaje = 'Otra subcategoría con el mismo nombre ya existe'
			set @Resultado = 400
			return
		end

		else 
		begin 
			begin transaction [trx_update_SubCategories]
			update [SQM_CATALOGS].[Tbl_SubCategories]
			set subCategoryName = Trim(@subCategoryName),
			subCategoryDescription = Trim(@subCategoryDescription),
			subCategoryModificatorId = @subCategoryModificatorId,
			subCategoryModificationDate = @subCategoryModificationDate,
			subCategoryStatusId = 1
			where subCategoryId = @subCategoryId
			commit transaction [trx_update_SubCategories]
			set @Mensaje = 'Subcategoría actualizada correctamente'
			set @Resultado = 200
		end
	End try

	Begin catch
	IF @@TRANCOUNT > 0
	Rollback transaction [trx_update_SubCategories]
	Set @Mensaje = 'Error al actualizar la subcategoría: ' + ERROR_MESSAGE()
	Set @Resultado = 500
	End catch
END
Go
/*Eliminar Sub Categorias actualizando su estado*/
Create or alter procedure [SQM_CATALOGS].[Delete_SubCategories]
(
	@subCategoryId INT,
	@subCategoryModificatorId INT NULL,
	@subCategoryModificationDate DATETIME NULL,
	@Mensaje NVARCHAR(100) OUTPUT,
	@Resultado INT OUTPUT
)
as
BEGIN 
	Begin try
	 if (@subCategoryModificationDate IS NULL)
	 begin 
	 set @subCategoryModificationDate = GETDATE()
	 end

	 if not exists(select 1 from [SQM_CATALOGS].[Tbl_SubCategories] 
	 where subCategoryId = @subCategoryId and subCategoryStatusId = 1)
	 begin 
	  set @Mensaje = 'La subcategoría no existe'
	  set @Resultado = 400
	  return
	 end

	 else
	 begin
	 Begin transaction [trx_delete_SubCategories]
	 update [SQM_CATALOGS].[Tbl_SubCategories]
	 set subCategoryStatusId = 0,
	 subCategoryModificatorId = @subCategoryModificatorId,
	 subCategoryModificationDate = @subCategoryModificationDate
	 where subCategoryId = @subCategoryId
	 Commit transaction [trx_delete_SubCategories]
	 set @Mensaje = 'Subcategoría eliminada correctamente'
	 set @Resultado = 200
	 end
	End try

	Begin catch
	 if @@TRANCOUNT > 0
	 Rollback transaction [trx_delete_SubCategories]
	 set @Mensaje = 'Error al eliminar la subcategoría: ' + ERROR_MESSAGE()
	 set @Resultado = 500
	End catch
END
Go
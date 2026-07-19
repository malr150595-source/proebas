Use DB_ECOMMERCE
Go

--Sp Listar 
Create or alter procedure [SQM_CATALOGS].[List_Tbl_Status]
as
Begin
Select 
	s.statusId as [IdEstado],
	s.statusName as [Estado],
	s.statusCreatorId as [IdCreador],
	s.statusCreationDate as [FechaCreacion],
	s.statusModificatorId as [IdModificador],
	s.statusModificationDate as [FechaModificacion]
from [SQM_CATALOGS].[Tbl_Status] s
Where s.statusStatusId = 1
End 
Go
--Sp Listar con filtro
Create or alter procedure [SQM_CATALOGS].[Filt_List_Tbl_Status]
(
@Criterio VARCHAR(50)
)
as
Begin
Select 
	s.statusId as [IdEstado],
	s.statusName as [Estado],
	s.statusCreatorId as [IdCreador],
	s.statusCreationDate as [FechaCreacion],
	s.statusModificatorId as [IdModificador],
	s.statusModificationDate as [FechaModificacion]
from [SQM_CATALOGS].[Tbl_Status] s
Where s.statusStatusId = 1 
and
(
@Criterio IS NULL 
OR s.statusName like '%' + @Criterio + '%' 
or (s.statusId = try_cast(@Criterio as int)) --Validacion para buscar por Id, solo si el criterio es numerico.
)
End 
Go
--Sp Insertar
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Insert_Tbl_Status]
(
	@StatusName VARCHAR(50) NULL,
	@StatusCreatorId INT,
	@StatusCreationDate DATETIME NULL,
	@Mensaje VARCHAR(250) OUTPUT,
	@Resultado INT OUTPUT
)
AS
BEGIN
	BEGIN TRY -- Inicio del bloque Try para manejo de errores.

		If(@statusCreationDate IS NULL)
		BEGIN 
			set @statusCreationDate = getdate()
		END
		--Validacion para verificar que el campo del nombre del estado no venga vacio, ya que es un campo requerido.
		IF (ISNULL(@StatusName, '') = '')
		BEGIN 
			SET @Mensaje = 'El campo del Estado no puede estar vacio'
			SET @Resultado = 400
			RETURN 
		END
		--Validacion para verificar si el nombre del estado existe y se encuentra activo, en ese caso no se permite la insercion.
		IF EXISTS(Select 1 From [SQM_CATALOGS].[Tbl_Status] 
		Where statusName = Trim(@StatusName) and statusStatusId = 1)
		BEGIN 
			Set @Mensaje = 'El nombre del estado ya existe y esta activo, ¡Verifique!'
			Set @Resultado = 400
			Return
		END 
		--Validacion para verificar si el nombre del estado existe pero se encuentra inactivo, en ese caso se reactiva el registro.
		IF EXISTS(Select 1 From [SQM_CATALOGS].[Tbl_Status] 
		Where statusName = TRIM(@StatusName) and statusStatusId = 0) 
		BEGIN 
			--Actualizacion del Estado a Activo
			begin transaction [trx_reactivacion_status]
			Update [SQM_CATALOGS].[Tbl_Status]
			set statusStatusId = 1,
			statusModificationDate = @StatusCreationDate, --Saber cuando se hizo la reacttivacion.
			statusModificatorId = @StatusCreatorId --Saber quien hizo la reactivacion.
			Where statusName = Trim(@StatusName) and statusStatusId = 0
			commit transaction [trx_reactivacion_status]
			Set @Mensaje = 'El nombre del estado ya existe pero se encuentra inactivo, Se ha Activado nuevamente'
			Set @Resultado = 201
			Return
		END


		ELSE
		BEGIN 
			BEGIN TRANSACTION [trx_Insert_Estatus]
			--Insercion del nuevo Estado, con el comando Trim para eliminar espacios en blanco a ambos lados del nombre del estado.
			INSERT INTO [SQM_CATALOGS].[Tbl_Status]
			(
				statusName,
				statusCreatorId,
				statusCreationDate,
				statusStatusId
			)
			VALUES 
			(
				TRIM(@StatusName), -- Comando Trim para eliminar espacios en blanco a ambos lados.
				@StatusCreatorId,
				@StatusCreationDate,
				1
			)

			COMMIT TRANSACTION [trx_Insert_Estatus]
			
			SET @Mensaje = 'El registro se ha insertado correctamente'
			SET @Resultado = 200
		END 
	END TRY-- Fin del bloque Try para manejo de errores.

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SET @Resultado = 500
		SET @Mensaje = 'Ocurrio un error: ' + ERROR_MESSAGE()
	END CATCH
END
GO
--Sp Actualizar
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[Update_Tbl_Status]
(
	@StatusId INT,
	@StatusName VARCHAR(50) NULL,
	@StatusModificatorId INT,
	@StatusModificationDate DATETIME NULL,
	@Mensaje VARCHAR(250) OUTPUT,
	@Resultado INT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		--Validacion para verificar si la fecha viene vacio, en ese caso se asigna la fecha actual.
		IF(@statusModificationDate IS NULL)
		BEGIN 
			set @statusModificationDate = Getdate()
		END

		IF(@statusId IS NULL or @statusName IS NULL OR
		(ISNULL(@statusName, '')= ''))
		begin 
		set @Mensaje = 'Fatal campos obligatorios'
		set @Resultado = 400
		Return
		end

		--Validacion para no duplicar registros al actualizar. 
		IF Exists (Select 1 From [SQM_CATALOGS].[Tbl_Status] 
		where statusName =  Trim(@statusName) and statusId <> @statusId and statusStatusId = 1)
		BEGIN 
			SET @Mensaje = 'El nombre a editar ya existe con un identificador diferente'
			SET @Resultado = 400
			RETURN 
		END

		ELSE
		BEGIN 
			BEGIN TRANSACTION trx_update_Estatus

			update [SQM_CATALOGS].[Tbl_Status]
			
				set statusName = TRIM(@StatusName),
				statusModificatorId = @StatusModificatorId,
				statusModificationDate = @StatusModificationDate
				where statusId = @StatusId

			COMMIT TRANSACTION trx_update_Estatus
			
			SET @Mensaje = 'El registro se ha actualizado correctamente'
			SET @Resultado = 200
		END 
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SET @Resultado = 500
		SET @Mensaje = 'Ocurrio un error: ' + ERROR_MESSAGE()
	END CATCH
END
GO
--Sp Eliminar (Borrado logico Softlog)
CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[delete_Tbl_Status]
(
	@StatusId INT,
	@StatusModificatorId INT,
	@StatusModificationDate DATETIME NULL,
	@Mensaje VARCHAR(250) OUTPUT,
	@Resultado INT OUTPUT
)
AS
BEGIN
	BEGIN TRY

		If (@statusModificationDate IS NULL)
		BEGIN 
			SET @statusModificationDate = GETDATE()
		END 
		--Validacion de que no exista.
		IF not exists(Select 1 From [SQM_CATALOGS].[Tbl_Status] 
		where statusId =  @statusId and statusStatusId = 1)
		BEGIN 
			SET @Mensaje = 'El Estado esta eliminado o no existe'
			SET @Resultado = 400
			RETURN 
		END

		ELSE
		BEGIN 
			BEGIN TRANSACTION trx_delete_Estatus

			update [SQM_CATALOGS].[Tbl_Status]
			
				set statusStatusId = 0,
				statusModificatorId = @StatusModificatorId,
				statusModificationDate = @StatusModificationDate
				where statusId = @StatusId

			COMMIT TRANSACTION trx_delete_Estatus
			
			SET @Mensaje = 'Registro eliminado correctamente'
			SET @Resultado = 200
		END 
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SET @Resultado = 500
		SET @Mensaje = 'Ocurrio un error: ' + ERROR_MESSAGE()
	END CATCH
END
GO


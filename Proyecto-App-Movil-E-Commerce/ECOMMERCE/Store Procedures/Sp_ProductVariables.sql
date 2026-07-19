Use DB_ECOMMERCE
Go

Create or alter procedure [SQM_GENERAL].[List_ProductVariables]
as
BEGIN
SET NOCOUNT ON;
	SELECT 
        v.productVariableId,
        v.productVariableProductId,
        p.productName AS [productName],
        v.productVariableValue,
        v.productVariablePrice,
        v.productVariableCurrencyId,
        c.currencyName AS [currencyName], 
        v.productVariableCreatorId,
        v.productVariableCreationDate
    FROM [SQM_GENERAL].[Tbl_ProductVariables] v
    INNER JOIN [SQM_GENERAL].[Tbl_Products] p ON v.productVariableProductId = p.productId
    INNER JOIN [SQM_CATALOGS].[Tbl_Currencies] c ON v.productVariableCurrencyId = c.currencyId
    WHERE v.productVariableStatusId = 1
	order by productVariableId desc
END
Go

Create or alter procedure [SQM_GENERAL].[Filt_list_ProductVariables]
(
@Filt Varchar(50)
)
as
BEGIN
SET NOCOUNT ON;
	SELECT 
        v.productVariableId,
        v.productVariableProductId,
        p.productName AS [productName],
        v.productVariableValue,
        v.productVariablePrice,
        v.productVariableCurrencyId,
        c.currencyName AS [currencyName], 
        v.productVariableCreatorId,
        v.productVariableCreationDate
    FROM [SQM_GENERAL].[Tbl_ProductVariables] v
    INNER JOIN [SQM_GENERAL].[Tbl_Products] p ON v.productVariableProductId = p.productId
    INNER JOIN [SQM_CATALOGS].[Tbl_Currencies] c ON v.productVariableCurrencyId = c.currencyId
    WHERE v.productVariableStatusId = 1
	and
	(
	 productVariableValue like '%' + @Filt + '%' 
	 or p.productName like '%' + @Filt + '%' 
	 or c.currencyName  like '%' + @Filt + '%'
	 or (productVariableId = TRY_CAST(@Filt AS INT))
	 or (productVariableProductId = TRY_CAST(@Filt AS INT))
	 or (productVariablePrice = TRY_CAST(@Filt AS DECIMAL))
	 or (productVariableCurrencyId = TRY_CAST(@Filt AS INT))
	)
	order by productVariableId desc
END
Go


Create or alter procedure [SQM_GENERAL].[Insert_ProductVariables]
(
	@productVariableProductId int,
	@productVariableValue VARCHAR(50) NULL,
	@productVariablePrice DECIMAL(18,2) NULL,
	@productVariableCurrencyId INT NULL,
	@productVariableCreatorId INT NULL,
	@productVariableCreationDate DATETIME NULL,
	@Mensaje Varchar(500) OUTPUT,
	@Resultado INT OUTPUT
)
as
BEGIN
SET NOCOUNT ON;
	BEGIN TRY
		IF(@productVariableCreationDate IS NULL)
		begin
			set @productVariableCreationDate = getdate()
		end

		IF(
		(ISNULL(TRIM(@productVariableValue), ' ' ) = ' ' )
		OR @productVariablePrice IS NULL
		OR @productVariableCurrencyId IS NULL
		OR @productVariablePrice <= 0
		OR @productVariableCurrencyId <= 0
		OR @productVariableProductId <= 0
		
		)
		begin 
			set @Mensaje = 'Datos invalidos'
			set @Resultado = 400
			return
		end

		IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductVariables]
		where productVariableValue = @productVariableValue
		and productVariableStatusId = 1)
		begin 
			set @Mensaje = 'Ya existe un registro'
			set @Resultado = 400
			return
		end

		IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductVariables]
		where productVariableValue = @productVariableValue
		and productVariableStatusId = 0)
		begin 
			begin transaction [trx_reactivation]
				update [SQM_GENERAL].[Tbl_ProductVariables]
				SET productVariableStatusId = 1,
				productVariablePrice = @productVariablePrice,
				productVariableCurrencyId = @productVariableCurrencyId,
				productVariableModificatorId = @productVariableCreatorId,
				productVariableModificationDate = @productVariableCreationDate
				where productVariableValue = @productVariableValue
				and productVariableStatusId = 0
			commit transaction [trx_reactivation]
			set @Mensaje = 'Ya existia, esta activo nuevamente'
			set @Resultado = 201
			return
		end

			begin transaction [trx_insert_productsVariables]
		insert into [SQM_GENERAL].[Tbl_ProductVariables]
		(
		 productVariableProductId,
		 productVariableValue,
		 productVariablePrice,
		 productVariableCurrencyId,
		 productVariableCreatorId,
		 productVariableCreationDate,
		 productVariableStatusId
		)
		values
		(
		 @productVariableProductId,
		 @productVariableValue,
		 @productVariablePrice,
		 @productVariableCurrencyId,
		 @productVariableCreatorId,
		 @productVariableCreationDate,
		 1
		)
		commit transaction [trx_insert_productsVariables]
		set @Mensaje = 'Variable producto ingresado correctamente'
		set @Resultado = 200

	END TRY

	BEGIN CATCH
	 IF @@TRANCOUNT > 0
	 begin
		Rollback transaction
	 end
	 set @Mensaje = 'Error: ' + ERROR_MESSAGE()
	 set @Resultado = 500
	END CATCH
END
Go

Create or alter procedure [SQM_GENERAL].[Update_ProductVariables]
(
	@productVariableId INT,
	@productVariableProductId int,
	@productVariableValue VARCHAR(50) NULL,
	@productVariablePrice DECIMAL(18,2) NULL,
	@productVariableCurrencyId INT NULL,
	@productVariableModificatorId INT NULL,
	@productVariableModificationDate DATETIME NULL,
	@Mensaje Varchar(500) OUTPUT,
	@Resultado INT OUTPUT
)
as
BEGIN
SET NOCOUNT ON;
	BEGIN TRY
		IF(@productVariableModificationDate IS NULL)
		begin
			set @productVariableModificationDate = getdate()
		end

		IF(
		(ISNULL(TRIM(@productVariableValue), ' ' ) = ' ' )
		OR @productVariablePrice IS NULL
		OR @productVariableCurrencyId IS NULL
		OR @productVariableId IS NULL
		OR @productVariableProductId IS NULL
		OR @productVariablePrice <= 0
		OR @productVariableCurrencyId <= 0
		OR @productVariableId <= 0
		OR @productVariableProductId <= 0
		)
		begin 
			set @Mensaje = 'Datos invalidos'
			set @Resultado = 400
			return
		end

		IF EXISTS(SELECT 1 FROM [SQM_GENERAL].[Tbl_ProductVariables]
		where productVariableValue = @productVariableValue
		and productVariableStatusId = 1 and productVariableId <> @productVariableId)
		begin 
			set @Mensaje = 'Ya existe un registro, utilice otro nombre'
			set @Resultado = 400
			return
		end

			begin transaction [trx_update_productsVariables]
				update [SQM_GENERAL].[Tbl_ProductVariables]
				SET
				productVariableProductId = @productVariableProductId,
				productVariableValue = @productVariableValue,
				productVariablePrice = @productVariablePrice,
				productVariableCurrencyId = @productVariableCurrencyId,
				productVariableModificatorId = @productVariableModificatorId,
				productVariableModificationDate = @productVariableModificationDate,
				productVariableStatusId = 1
				where productVariableId = @productVariableId
			commit transaction [trx_update_productsVariables]
			set @Mensaje = 'Registro actualizado correctamente'
			set @Resultado = 200

	END TRY

	BEGIN CATCH
	 IF @@TRANCOUNT > 0
	 begin
		Rollback transaction
	 end
	 set @Mensaje = 'Error: ' + ERROR_MESSAGE()
	 set @Resultado = 500
	END CATCH
END
Go

Create or alter procedure [SQM_GENERAL].[Delete_ProductVariables]
(
	@productVariableId INT,
	@productVariableModificatorId INT NULL,
	@productVariableModificationDate DATETIME NULL,
	@Mensaje Varchar(500) OUTPUT,
	@Resultado INT OUTPUT
)
as
BEGIN
SET NOCOUNT ON;
	BEGIN TRY
		IF(@productVariableModificationDate IS NULL)
		begin
			set @productVariableModificationDate = getdate()
		end

		IF(
		@productVariableId IS NULL
		OR @productVariableId <= 0
		)
		begin 
			set @Mensaje = 'Datos invalidos'
			set @Resultado = 400
			return
		end

			begin transaction [trx_delete_productsVariables]
				update [SQM_GENERAL].[Tbl_ProductVariables]
				SET
				productVariableModificatorId = @productVariableModificatorId,
				productVariableModificationDate = @productVariableModificationDate,
				productVariableStatusId = 0
				where productVariableId = @productVariableId
			commit transaction [trx_delete_productsVariables]
			set @Mensaje = 'Registro eliminado correctamente'
			set @Resultado = 200

	END TRY

	BEGIN CATCH
	 IF @@TRANCOUNT > 0
	 begin
		Rollback transaction
	 end
	 set @Mensaje = 'Error: ' + ERROR_MESSAGE()
	 set @Resultado = 500
	END CATCH
END
Go

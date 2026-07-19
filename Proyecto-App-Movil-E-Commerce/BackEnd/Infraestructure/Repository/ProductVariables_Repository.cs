using Application.DTOs;
using Application.Interface;
using Domain;
using Infraestructure.Db;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructure.Repository
{
    public class ProductVariables_Repository(DBConectionFactory connection) : IProductVariablesRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<ProductVariable>> List_ProductVariables()
        {
            List<ProductVariable> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_ProductVariables]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    ProductVariableId = dr["productVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableId"]),
                    ProductVariableProductId = dr["productVariableProductId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableProductId"]),
                    ProductName = dr["productName"] == DBNull.Value ? string.Empty : dr["productName"].ToString()!, // Mapeo nuevo
                    ProductVariableValue = dr["productVariableValue"] == DBNull.Value ? string.Empty : dr["productVariableValue"].ToString()!,
                    ProductVariablePrice = dr["productVariablePrice"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["productVariablePrice"]),
                    ProductVariableCurrencyId = dr["productVariableCurrencyId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableCurrencyId"]),
                    CurrencyName = dr["currencyName"] == DBNull.Value ? string.Empty : dr["currencyName"].ToString()!, // Mapeo nuevo
                    ProductVariableCreatorId = dr["productVariableCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableCreatorId"]),
                    ProductVariableCreationDate = dr["productVariableCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["productVariableCreationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<ProductVariable>> Filt_List_ProductVariables(string filtro)
        {
            List<ProductVariable> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_ProductVariables]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    ProductVariableId = dr["productVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableId"]),
                    ProductVariableProductId = dr["productVariableProductId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableProductId"]),
                    ProductName = dr["productName"] == DBNull.Value ? string.Empty : dr["productName"].ToString()!, // Mapeo nuevo
                    ProductVariableValue = dr["productVariableValue"] == DBNull.Value ? string.Empty : dr["productVariableValue"].ToString()!,
                    ProductVariablePrice = dr["productVariablePrice"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["productVariablePrice"]),
                    ProductVariableCurrencyId = dr["productVariableCurrencyId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableCurrencyId"]),
                    CurrencyName = dr["currencyName"] == DBNull.Value ? string.Empty : dr["currencyName"].ToString()!, // Mapeo nuevo
                    ProductVariableCreatorId = dr["productVariableCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableCreatorId"]),
                    ProductVariableCreationDate = dr["productVariableCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["productVariableCreationDate"])
                });
            }
            return lista;
        }

        // --- FUNCIÓN DE INSERTAR ---
        public async Task<MensajeDTOs> Insert_ProductVariables(ProductVariable_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_ProductVariables]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@productVariableProductId", create.ProductId));
                cmd.Parameters.Add(new SqlParameter("@productVariableValue", create.Value ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productVariablePrice", create.Price));
                cmd.Parameters.Add(new SqlParameter("@productVariableCurrencyId", create.CurrencyId));
                cmd.Parameters.Add(new SqlParameter("@productVariableCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@productVariableCreationDate", (object)create.CreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 500) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString()!;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        // --- FUNCIÓN DE ACTUALIZAR ---
        public async Task<MensajeDTOs> Update_ProductVariables(ProductVariable_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_ProductVariables]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@productVariableId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@productVariableProductId", update.ProductId));
                cmd.Parameters.Add(new SqlParameter("@productVariableValue", update.Value ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productVariablePrice", update.Price));
                cmd.Parameters.Add(new SqlParameter("@productVariableCurrencyId", update.CurrencyId));
                cmd.Parameters.Add(new SqlParameter("@productVariableModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@productVariableModificationDate", (object)update.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 500) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString()!;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        // --- FUNCIÓN DE ELIMINAR ---
        public async Task<MensajeDTOs> Delete_ProductVariables(ProductVariable_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_ProductVariables]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@productVariableId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@productVariableModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@productVariableModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 500) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString()!;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }
    }
}
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
    public class Stocks_Repository(DBConectionFactory connection) : IStocksRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<Stock>> List_Stocks()
        {
            List<Stock> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_Stocks]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    StockId = dr["stockId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockId"]),
                    StockProductVariableId = dr["stockProductVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockProductVariableId"]),
                    ProductVariableValueRef = dr["productVariableValueRef"] == DBNull.Value ? string.Empty : dr["productVariableValueRef"].ToString()!,
                    StockQuantity = dr["stockQuantity"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockQuantity"]),
                    StockFactoryDate = dr["stockFactoryDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockFactoryDate"]),
                    StockExpirationDate = dr["stockExpirationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockExpirationDate"]),
                    StockCreatorId = dr["stockCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockCreatorId"]),
                    StockCreationDate = dr["stockCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockCreationDate"]),
                    StockModificatorId = dr["stockModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["stockModificatorId"]),
                    StockModificationDate = dr["stockModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["stockModificationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<Stock>> Filt_List_Stocks(string filtro)
        {
            List<Stock> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_Stocks]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    StockId = dr["stockId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockId"]),
                    StockProductVariableId = dr["stockProductVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockProductVariableId"]),
                    ProductVariableValueRef = dr["productVariableValueRef"] == DBNull.Value ? string.Empty : dr["productVariableValueRef"].ToString()!,
                    StockQuantity = dr["stockQuantity"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockQuantity"]),
                    StockFactoryDate = dr["stockFactoryDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockFactoryDate"]),
                    StockExpirationDate = dr["stockExpirationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockExpirationDate"]),
                    StockCreatorId = dr["stockCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockCreatorId"]),
                    StockCreationDate = dr["stockCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockCreationDate"]),
                    StockModificatorId = dr["stockModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["stockModificatorId"]),
                    StockModificationDate = dr["stockModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["stockModificationDate"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_Stocks(Stock_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_Stocks]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockProductVariableId", create.ProductVariableId));
                cmd.Parameters.Add(new SqlParameter("@stockQuantity", create.Quantity));
                cmd.Parameters.Add(new SqlParameter("@stockFactoryDate", create.FactoryDate));
                cmd.Parameters.Add(new SqlParameter("@stockExpirationDate", create.ExpirationDate));
                cmd.Parameters.Add(new SqlParameter("@stockCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@stockCreationDate", (object)create.CreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
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

        public async Task<MensajeDTOs> Update_Stocks(Stock_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_Stocks]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@stockProductVariableId", update.ProductVariableId));
                cmd.Parameters.Add(new SqlParameter("@stockQuantity", update.Quantity));
                cmd.Parameters.Add(new SqlParameter("@stockFactoryDate", update.FactoryDate));
                cmd.Parameters.Add(new SqlParameter("@stockExpirationDate", update.ExpirationDate));
                cmd.Parameters.Add(new SqlParameter("@stockModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@stockModificationDate", (object)update.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
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

        public async Task<MensajeDTOs> Delete_Stocks(Stock_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_Stocks]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@stockModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@stockModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
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
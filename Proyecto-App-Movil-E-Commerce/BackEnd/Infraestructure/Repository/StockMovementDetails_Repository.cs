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
    public class StockMovementDetails_Repository(DBConectionFactory connection) : IStockMovementDetailsRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<StockMovementDetail>> List_StockMovementDetails(int? stockMovementDetailMovementId, int? stockMovementDetailStockId)
        {
            List<StockMovementDetail> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_StockMovementDetails]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@stockMovementDetailMovementId", (object)stockMovementDetailMovementId ?? DBNull.Value));
            cmd.Parameters.Add(new SqlParameter("@stockMovementDetailStockId", (object)stockMovementDetailStockId ?? DBNull.Value));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToStockMovementDetail(dr));
            }
            return lista;
        }

        public async Task<IEnumerable<StockMovementDetail>> Filt_List_StockMovementDetails(int filt)
        {
            List<StockMovementDetail> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_StockMovementDetails]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filt));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToStockMovementDetail(dr));
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_StockMovementDetails(StockMovementDetail_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_StockMovementDetails]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailMovementId", create.MovementId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailOrderDetailId", (object)create.OrderDetailId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailStockId", (object)create.StockId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailQuantity", create.Quantity));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailFactoryDate", (object)create.FactoryDate ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailExpirationDate", (object)create.ExpirationDate ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_StockMovementDetails(StockMovementDetail_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_StockMovementDetails]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailQuantity", update.Quantity));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailFactoryDate", (object)update.FactoryDate ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailExpirationDate", (object)update.ExpirationDate ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailModifierId", update.ModifierId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_StockMovementDetails(StockMovementDetail_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_StockMovementDetails]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailModifierId", delete.ModifierId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDetailModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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

        private static StockMovementDetail MapToStockMovementDetail(SqlDataReader dr)
        {
            return new StockMovementDetail
            {
                StockMovementDetailId = dr["stockMovementDetailId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementDetailId"]),
                StockMovementDetailMovementId = dr["stockMovementDetailMovementId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementDetailMovementId"]),
                StockMovementDetailOrderDetailId = dr["stockMovementDetailOrderDetailId"] == DBNull.Value ? null : Convert.ToInt32(dr["stockMovementDetailOrderDetailId"]),
                StockMovementDetailStockId = dr["stockMovementDetailStockId"] == DBNull.Value ? null : Convert.ToInt32(dr["stockMovementDetailStockId"]),
                StockMovementDetailQuantity = dr["stockMovementDetailQuantity"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementDetailQuantity"]),
                StockMovementDetailFactoryDate = dr["stockMovementDetailFactoryDate"] == DBNull.Value ? null : DateOnly.FromDateTime(Convert.ToDateTime(dr["stockMovementDetailFactoryDate"])),
                StockMovementDetailExpirationDate = dr["stockMovementDetailExpirationDate"] == DBNull.Value ? null : DateOnly.FromDateTime(Convert.ToDateTime(dr["stockMovementDetailExpirationDate"])),
                StockMovementDetailCreatorId = dr["stockMovementDetailCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementDetailCreatorId"]),
                StockMovementDetailCreationDate = dr["stockMovementDetailCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockMovementDetailCreationDate"]),
                StockMovementDetailModifierId = dr["stockMovementDetailModifierId"] == DBNull.Value ? null : Convert.ToInt32(dr["stockMovementDetailModifierId"]),
                StockMovementDetailModificationDate = dr["stockMovementDetailModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["stockMovementDetailModificationDate"]),
                StockMovementDetailStatusId = dr["stockMovementDetailStatusId"] != DBNull.Value && Convert.ToBoolean(dr["stockMovementDetailStatusId"])
            };
        }
    }
}
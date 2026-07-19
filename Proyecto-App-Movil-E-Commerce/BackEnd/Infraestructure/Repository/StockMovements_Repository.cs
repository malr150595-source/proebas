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
    public class StockMovements_Repository(DBConectionFactory connection) : IStockMovementsRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<StockMovement>> List_StockMovements(int? stockMovementType, int? stockMovementOrderId)
        {
            List<StockMovement> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_StockMovements]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@stockMovementType", (object)stockMovementType ?? DBNull.Value));
            cmd.Parameters.Add(new SqlParameter("@stockMovementOrderId", (object)stockMovementOrderId ?? DBNull.Value));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToStockMovement(dr));
            }
            return lista;
        }

        public async Task<IEnumerable<StockMovement>> Filt_List_StockMovements(string filt)
        {
            List<StockMovement> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_StockMovements]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filt ?? (object)DBNull.Value));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToStockMovement(dr));
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_StockMovements(StockMovement_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_StockMovements]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockMovementType", create.Type));
                cmd.Parameters.Add(new SqlParameter("@stockMovementOrderId", (object)create.OrderId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementReference", (object)create.Reference ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDate", (object)create.Date ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementStatusId", create.StatusId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_StockMovements(StockMovement_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_StockMovements]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockMovementId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@stockMovementType", update.Type));
                cmd.Parameters.Add(new SqlParameter("@stockMovementOrderId", (object)update.OrderId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementReference", (object)update.Reference ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@stockMovementDate", update.Date));
                cmd.Parameters.Add(new SqlParameter("@stockMovementStatusId", update.StatusId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementModifierId", update.ModifierId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_StockMovements(StockMovement_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_StockMovements]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockMovementId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@stockMovementModifierId", delete.ModifierId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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

        private static StockMovement MapToStockMovement(SqlDataReader dr)
        {
            return new StockMovement
            {
                StockMovementId = dr["stockMovementId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementId"]),
                StockMovementType = dr["stockMovementType"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementType"]),
                StockMovementOrderId = dr["stockMovementOrderId"] == DBNull.Value ? null : Convert.ToInt32(dr["stockMovementOrderId"]),
                StockMovementReference = dr["stockMovementReference"] == DBNull.Value ? null : dr["stockMovementReference"].ToString(),
                StockMovementDate = dr["stockMovementDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockMovementDate"]),
                StockMovementCreatorId = dr["stockMovementCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementCreatorId"]),
                StockMovementCreationDate = dr["stockMovementCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockMovementCreationDate"]),
                StockMovementModifierId = dr["stockMovementModifierId"] == DBNull.Value ? null : Convert.ToInt32(dr["stockMovementModifierId"]),
                StockMovementModificationDate = dr["stockMovementModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["stockMovementModificationDate"]),
                StockMovementStatusId = dr["stockMovementStatusId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementStatusId"])
            };
        }
    }
}
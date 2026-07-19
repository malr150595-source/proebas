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
    public class StockMovementTypes_Repository(DBConectionFactory connection) : IStockMovementTypesRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<StockMovementType>> List_StockMovementTypes()
        {
            List<StockMovementType> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_CATALOGS].[List_StockMovementTypes]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToStockMovementType(dr));
            }
            return lista;
        }

        public async Task<IEnumerable<StockMovementType>> Filt_List_StockMovementTypes(string filt)
        {
            List<StockMovementType> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_CATALOGS].[Filt_list_StockMovementTypes]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filt ?? (object)DBNull.Value));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToStockMovementType(dr));
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_StockMovementTypes(StockMovementType_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_CATALOGS].[Insert_StockMovementTypes]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeName", create.Name));
                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeDescription", create.Description));
                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_StockMovementTypes(StockMovementType_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_CATALOGS].[Update_StockMovementTypes]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeName", update.Name));
                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeDescription", update.Description));
                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_StockMovementTypes(StockMovementType_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_CATALOGS].[Delete_StockMovementTypes]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@stockMovementTypeModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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

        private static StockMovementType MapToStockMovementType(SqlDataReader dr)
        {
            return new StockMovementType
            {
                StockMovementTypeId = dr["stockMovementTypeId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementTypeId"]),
                StockMovementTypeName = dr["stockMovementTypeName"] == DBNull.Value ? string.Empty : dr["stockMovementTypeName"].ToString()!,
                StockMovementTypeDescription = dr["stockMovementTypeDescription"] == DBNull.Value ? string.Empty : dr["stockMovementTypeDescription"].ToString()!,
                StockMovementTypeCreatorId = dr["stockMovementTypeCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["stockMovementTypeCreatorId"]),
                StockMovementTypeCreationDate = dr["stockMovementTypeCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["stockMovementTypeCreationDate"]),
                StockMovementTypeModificatorId = dr["stockMovementTypeModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["stockMovementTypeModificatorId"]),
                StockMovementTypeModificationDate = dr["stockMovementTypeModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["stockMovementTypeModificationDate"])
            };
        }
    }
}
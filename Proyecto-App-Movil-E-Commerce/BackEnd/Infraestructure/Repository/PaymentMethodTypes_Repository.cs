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
    public class PaymentMethodTypes_Repository(DBConectionFactory connection) : IPaymentMethodTypesRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<PaymentMethodType>> List_PaymentMethodTypes()
        {
            List<PaymentMethodType> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_CATALOGS].[List_PaymentMethodTypes]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    PaymentMethodTypeId = dr["paymentMethodTypeId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["paymentMethodTypeId"]),
                    PaymentMethodTypeName = dr["paymentMethodTypeName"] == DBNull.Value ? string.Empty : dr["paymentMethodTypeName"].ToString()!,
                    PaymentMethodTypeDescription = dr["paymentMethodTypeDescription"] == DBNull.Value ? string.Empty : dr["paymentMethodTypeDescription"].ToString()!,
                    PaymentMethodTypeCreatorId = dr["paymentMethodTypeCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["paymentMethodTypeCreatorId"]),
                    UserCreatorNameRef = dr["userCreatorNameRef"] == DBNull.Value ? string.Empty : dr["userCreatorNameRef"].ToString()!,
                    PaymentMethodTypeCreationDate = dr["paymentMethodTypeCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["paymentMethodTypeCreationDate"]),
                    PaymentMethodTypeModificatorId = dr["paymentMethodTypeModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["paymentMethodTypeModificatorId"]),
                    PaymentMethodTypeModificationDate = dr["paymentMethodTypeModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["paymentMethodTypeModificationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<PaymentMethodType>> Filt_List_PaymentMethodTypes(string filtro)
        {
            List<PaymentMethodType> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_CATALOGS].[Filt_list_PaymentMethodTypes]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    PaymentMethodTypeId = dr["paymentMethodTypeId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["paymentMethodTypeId"]),
                    PaymentMethodTypeName = dr["paymentMethodTypeName"] == DBNull.Value ? string.Empty : dr["paymentMethodTypeName"].ToString()!,
                    PaymentMethodTypeDescription = dr["paymentMethodTypeDescription"] == DBNull.Value ? string.Empty : dr["paymentMethodTypeDescription"].ToString()!,
                    PaymentMethodTypeCreatorId = dr["paymentMethodTypeCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["paymentMethodTypeCreatorId"]),
                    UserCreatorNameRef = dr["userCreatorNameRef"] == DBNull.Value ? string.Empty : dr["userCreatorNameRef"].ToString()!,
                    PaymentMethodTypeCreationDate = dr["paymentMethodTypeCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["paymentMethodTypeCreationDate"]),
                    PaymentMethodTypeModificatorId = dr["paymentMethodTypeModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["paymentMethodTypeModificatorId"]),
                    PaymentMethodTypeModificationDate = dr["paymentMethodTypeModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["paymentMethodTypeModificationDate"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_PaymentMethodTypes(PaymentMethodType_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_CATALOGS].[Insert_PaymentMethodTypes]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeName", create.Name));
                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeDescription", create.Description));
                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_PaymentMethodTypes(PaymentMethodType_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_CATALOGS].[Update_PaymentMethodTypes]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeName", update.Name));
                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeDescription", update.Description));
                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_PaymentMethodTypes(PaymentMethodType_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_CATALOGS].[Delete_PaymentMethodTypes]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@paymentMethodTypeModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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
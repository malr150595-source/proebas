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
    public class UserPaymentMethods_Repository(DBConectionFactory connection) : IUserPaymentMethodsRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<UserPaymentMethod>> List_UserPaymentMethods(int userId)
        {
            List<UserPaymentMethod> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_UserPaymentMethods]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@userPaymentMethodUserId", userId));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    UserPaymentMethodId = dr["userPaymentMethodId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userPaymentMethodId"]),
                    UserPaymentMethodUserId = dr["userPaymentMethodUserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userPaymentMethodUserId"]),
                    UserPaymentMethodPaymentMethodTypeId = dr["userPaymentMethodPaymentMethodTypeId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userPaymentMethodPaymentMethodTypeId"]),
                    PaymentMethodTypeName = dr["paymentMethodTypeName"] == DBNull.Value ? string.Empty : dr["paymentMethodTypeName"].ToString()!,
                    UserPaymentMethodCardNumberMasked = dr["userPaymentMethodCardNumber_Masked"] == DBNull.Value ? string.Empty : dr["userPaymentMethodCardNumber_Masked"].ToString()!,
                    UserPaymentMethodExpirationDate = dr["userPaymentMethodExpirationDate"] == DBNull.Value ? string.Empty : dr["userPaymentMethodExpirationDate"].ToString()!,
                    UserPaymentMethodCVV = dr["userPaymentMethodCVV"] == DBNull.Value ? string.Empty : dr["userPaymentMethodCVV"].ToString()!,
                    UserPaymentMethodCardHolderName = dr["userPaymentMethodCardHolderName"] == DBNull.Value ? string.Empty : dr["userPaymentMethodCardHolderName"].ToString()!,
                    UserPaymentMethodCreatorId = dr["userPaymentMethodCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userPaymentMethodCreatorId"]),
                    UserPaymentMethodCreationDate = dr["userPaymentMethodCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["userPaymentMethodCreationDate"]),
                    UserPaymentMethodModificatorId = dr["userPaymentMethodModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["userPaymentMethodModificatorId"]),
                    UserPaymentMethodModificationDate = dr["userPaymentMethodModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["userPaymentMethodModificationDate"])
                });
            }
            return lista;
        }

        public async Task<UserPaymentMethod?> Filt_List_UserPaymentMethods(int id)
        {
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_UserPaymentMethods]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@userPaymentMethodId", id));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            if (await dr.ReadAsync())
            {
                return new UserPaymentMethod
                {
                    UserPaymentMethodId = dr["userPaymentMethodId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userPaymentMethodId"]),
                    UserPaymentMethodUserId = dr["userPaymentMethodUserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userPaymentMethodUserId"]),
                    UserPaymentMethodPaymentMethodTypeId = dr["userPaymentMethodPaymentMethodTypeId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userPaymentMethodPaymentMethodTypeId"]),
                    UserPaymentMethodCardNumberRaw = dr["userPaymentMethodCardNumber_Raw"] == DBNull.Value ? string.Empty : dr["userPaymentMethodCardNumber_Raw"].ToString()!,
                    UserPaymentMethodExpirationDate = dr["userPaymentMethodExpirationDate"] == DBNull.Value ? string.Empty : dr["userPaymentMethodExpirationDate"].ToString()!,
                    UserPaymentMethodCVV = dr["userPaymentMethodCVV"] == DBNull.Value ? string.Empty : dr["userPaymentMethodCVV"].ToString()!,
                    UserPaymentMethodCardHolderName = dr["userPaymentMethodCardHolderName"] == DBNull.Value ? string.Empty : dr["userPaymentMethodCardHolderName"].ToString()!,
                    UserPaymentMethodCreatorId = dr["userPaymentMethodCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userPaymentMethodCreatorId"]),
                    UserPaymentMethodCreationDate = dr["userPaymentMethodCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["userPaymentMethodCreationDate"]),
                    UserPaymentMethodModificatorId = dr["userPaymentMethodModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["userPaymentMethodModificatorId"]),
                    UserPaymentMethodModificationDate = dr["userPaymentMethodModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["userPaymentMethodModificationDate"])
                };
            }
            return null;
        }

        public async Task<MensajeDTOs> Insert_UserPaymentMethods(UserPaymentMethod_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_UserPaymentMethods]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodUserId", create.UserId));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodPaymentMethodTypeId", create.PaymentMethodTypeId));
                cmd.Parameters.Add(new SqlParameter("@CardNumber_Raw", create.CardNumberRaw));
                cmd.Parameters.Add(new SqlParameter("@ExpirationDate_Raw", create.ExpirationDateRaw));
                cmd.Parameters.Add(new SqlParameter("@CVV_Raw", create.CVVRaw));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodCardHolderName", create.CardHolderName));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_UserPaymentMethods(UserPaymentMethod_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_UserPaymentMethods]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodPaymentMethodTypeId", update.PaymentMethodTypeId));
                cmd.Parameters.Add(new SqlParameter("@CardNumber_Raw", update.CardNumberRaw));
                cmd.Parameters.Add(new SqlParameter("@ExpirationDate_Raw", update.ExpirationDateRaw));
                cmd.Parameters.Add(new SqlParameter("@CVV_Raw", update.CVVRaw));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodCardHolderName", update.CardHolderName));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_UserPaymentMethods(UserPaymentMethod_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_UserPaymentMethods]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@userPaymentMethodModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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
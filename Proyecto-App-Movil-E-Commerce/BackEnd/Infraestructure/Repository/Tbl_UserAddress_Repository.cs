using Application.DTOs;
using Application.Interface;
using Infraestructure.Db;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructure.Repository
{
    public class Tbl_UserAddress_Repository : ITbl_UserAddresses
    {
        private readonly DBConectionFactory _connection;

        public Tbl_UserAddress_Repository(DBConectionFactory connection)
        {
            _connection = connection;
        }

        public async Task<IEnumerable<Tbl_UserAddress_DTOs>> List_UserAddresses()
        {
            var lista = new List<Tbl_UserAddress_DTOs>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[List_UserAddresses]", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                {
                    while (await dr.ReadAsync())
                    {
                        lista.Add(new Tbl_UserAddress_DTOs
                        {
                            UserAddressId = dr["userAddressId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressId"]),
                            UserAddressUserId = dr["userAddressUserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressUserId"]),
                            UserAddressCountryId = dr["userAddressCountryId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressCountryId"]),
                            UserAddressZIPCode = dr["userAddressZIPCode"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressZIPCode"]),
                            UserAddressDescription = dr["userAddressDescription"] == DBNull.Value ? string.Empty : dr["userAddressDescription"].ToString(),
                            UserAddressIsPrincipal = dr["userAddressIsPrincipal"] != DBNull.Value && Convert.ToBoolean(dr["userAddressIsPrincipal"]),
                            UserAddressCreatorId = dr["userAddressCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressCreatorId"]),
                            UserAddressCreationDate = dr["userAddressCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["userAddressCreationDate"]),
                            UserAddressModificatorId = dr["userAddressModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["userAddressModificatorId"]),
                            UserAddressModificationDate = dr["userAddressModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["userAddressModificationDate"])
                        });
                    }
                }
            }
            return lista;
        }

        public async Task<IEnumerable<Tbl_UserAddress_DTOs>> Filt_List_UserAddresses(string criterio)
        {
            var lista = new List<Tbl_UserAddress_DTOs>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[Filt_List_UserAddresses]", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@CRITERIO", criterio ?? string.Empty));

                using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                {
                    while (await dr.ReadAsync())
                    {
                        lista.Add(new Tbl_UserAddress_DTOs
                        {
                            UserAddressId = dr["userAddressId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressId"]),
                            UserAddressUserId = dr["userAddressUserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressUserId"]),
                            UserAddressCountryId = dr["userAddressCountryId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressCountryId"]),
                            UserAddressZIPCode = dr["userAddressZIPCode"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressZIPCode"]),
                            UserAddressDescription = dr["userAddressDescription"] == DBNull.Value ? string.Empty : dr["userAddressDescription"].ToString(),
                            UserAddressIsPrincipal = dr["userAddressIsPrincipal"] != DBNull.Value && Convert.ToBoolean(dr["userAddressIsPrincipal"]),
                            UserAddressCreatorId = dr["userAddressCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userAddressCreatorId"]),
                            UserAddressCreationDate = dr["userAddressCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["userAddressCreationDate"]),
                            UserAddressModificatorId = dr["userAddressModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["userAddressModificatorId"]),
                            UserAddressModificationDate = dr["userAddressModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["userAddressModificationDate"])
                        });
                    }
                }
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_UserAddresses(Tbl_UserAddress_Insert_DTOs create)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[Insert_UserAddresses]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@UserAddressUserId", create.UserAddressUserId));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressCountryId", create.UserAddressCountryId));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressZIPCode", create.UserAddressZIPCode));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressDescription", create.UserAddressDescription ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressIsPrincipal", create.UserAddressIsPrincipal));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressCreationDate", (object)create.UserAddressCreationDate ?? DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressCreatorId", create.UserAddressCreatorId));

                    SqlParameter OutMensaje = new SqlParameter("@MENSAJE", SqlDbType.NVarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter OutResultado = new SqlParameter("@RESULTADO", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(OutMensaje);
                    cmd.Parameters.Add(OutResultado);

                    await cmd.ExecuteNonQueryAsync();

                    respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                    respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
                }
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Update_UserAddresses(Tbl_UserAddress_Update_DTOs update)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[Update_UserAddresses]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@UserAddressId", update.UserAddressId));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressUserId", update.UserAddressUserId));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressCountryId", update.UserAddressCountryId));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressZIPCode", update.UserAddressZIPCode));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressDescription", update.UserAddressDescription ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressIsPrincipal", update.UserAddressIsPrincipal));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressModificatorId", update.UserAddressModificatorId));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressModificationDate", (object)update.UserAddressModificationDate ?? DBNull.Value));

                    SqlParameter OutMensaje = new SqlParameter("@MENSAJE", SqlDbType.NVarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter OutResultado = new SqlParameter("@RESULTADO", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(OutMensaje);
                    cmd.Parameters.Add(OutResultado);

                    await cmd.ExecuteNonQueryAsync();

                    respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                    respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
                }
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Delete_UserAddresses(Tbl_UserAddress_Delete_DTOs delete)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[Delete_UserAddresses]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@UserAddressId", delete.UserAddressId));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressModificatorId", delete.UserAddressModificatorId));
                    cmd.Parameters.Add(new SqlParameter("@UserAddressModificationDate", (object)delete.UserAddressModificationDate ?? DBNull.Value));

                    SqlParameter OutMensaje = new SqlParameter("@MENSAJE", SqlDbType.NVarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter OutResultado = new SqlParameter("@RESULTADO", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(OutMensaje);
                    cmd.Parameters.Add(OutResultado);

                    await cmd.ExecuteNonQueryAsync();

                    respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                    respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
                }
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
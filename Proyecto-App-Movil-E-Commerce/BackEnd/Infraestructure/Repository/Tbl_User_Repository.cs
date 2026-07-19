using Application.DTOs;
using Application.Interface;
using Infraestructure.Db;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;

namespace Infraestructure.Repository
{
    public class Tbl_User_Repository : ITbl_Users
    {
        private readonly DBConectionFactory _connection;

        public Tbl_User_Repository(DBConectionFactory connection)
        {
            _connection = connection;
        }

        public async Task<IEnumerable<Tbl_User_DTOs>> List_Users()
        {
            var lista = new List<Tbl_User_DTOs>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[List_Users]", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                {
                    while (dr.Read())
                    {
                        var usuario = new Tbl_User_DTOs
                        {
                            UserId = dr["UserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserId"]),
                            UserFullName = dr["UserFullName"] == DBNull.Value ? string.Empty : dr["UserFullName"].ToString(),
                            UserName = dr["UserName"] == DBNull.Value ? string.Empty : dr["UserName"].ToString(),
                            UserPassword = null,
                            UserEmail = dr["UserEmail"] == DBNull.Value ? string.Empty : dr["UserEmail"].ToString(),
                            UserPhoneNumber = dr["UserPhoneNumber"] == DBNull.Value ? string.Empty : dr["UserPhoneNumber"].ToString(),
                            UserCountryId = dr["UserCountryId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserCountryId"]),
                            UserGenderId = dr["UserGenderId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserGenderId"]),
                            UserBirthDay = dr["UserBirthDay"] == DBNull.Value ? null : Convert.ToDateTime(dr["UserBirthDay"]),
                            UserCreatorId = dr["UserCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserCreatorId"]),
                            UserCreationDate = dr["UserCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["UserCreationDate"]),
                            UserModificatorId = dr["UserModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["UserModificatorId"]),
                            UserModificationDate = dr["UserModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["UserModificationDate"]),
                            Status = dr["Status"] == DBNull.Value ? string.Empty : dr["Status"].ToString()
                        };

                        lista.Add(usuario);
                    }
                }
            }
            return lista;
        }

        public async Task<IEnumerable<Tbl_User_DTOs>> Filt_List_Users(string criterio)
        {
            var lista = new List<Tbl_User_DTOs>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[Filt_List_Users]", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@CRITERIO", criterio ?? string.Empty));

                using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                {
                    while (dr.Read())
                    {
                        var usuario = new Tbl_User_DTOs
                        {
                            UserId = dr["UserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserId"]),
                            UserFullName = dr["UserFullName"] == DBNull.Value ? string.Empty : dr["UserFullName"].ToString(),
                            UserName = dr["UserName"] == DBNull.Value ? string.Empty : dr["UserName"].ToString(),
                            UserPassword = null,
                            UserEmail = dr["UserEmail"] == DBNull.Value ? string.Empty : dr["UserEmail"].ToString(),
                            UserPhoneNumber = dr["UserPhoneNumber"] == DBNull.Value ? string.Empty : dr["UserPhoneNumber"].ToString(),
                            UserCountryId = dr["UserCountryId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserCountryId"]),
                            UserGenderId = dr["UserGenderId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserGenderId"]),
                            UserBirthDay = dr["UserBirthDay"] == DBNull.Value ? null : Convert.ToDateTime(dr["UserBirthDay"]),
                            UserCreatorId = dr["UserCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["UserCreatorId"]),
                            UserCreationDate = dr["UserCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["UserCreationDate"]),
                            UserModificatorId = dr["UserModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["UserModificatorId"]),
                            UserModificationDate = dr["UserModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["UserModificationDate"]),
                            Status = dr["Status"] == DBNull.Value ? string.Empty : dr["Status"].ToString()
                        };

                        lista.Add(usuario);
                    }
                }
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_Users(Tbl_User_Insert_DTOs create)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[Insert_Users]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@UserFullName", create.UserFullName ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserName", create.UserName ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserPasswordText", create.UserPassword ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserEmail", create.UserEmail ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserPhoneNumber", create.UserPhoneNumber ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserCountryId", create.UserCountryId));
                    cmd.Parameters.Add(new SqlParameter("@UserGenderId", create.UserGenderId));
                    cmd.Parameters.Add(new SqlParameter("@UserBirthDay", (object)create.UserBirthDay ?? DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@UserCreatorId", create.UserCreatorId));
                    cmd.Parameters.Add(new SqlParameter("@UserCreationDate", (object)create.UserCreationDate ?? DBNull.Value));

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
                respuesta.Resultado = 0;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Update_Users(Tbl_User_Update_DTOs update)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[Update_Users]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@UserId", update.UserId));
                    cmd.Parameters.Add(new SqlParameter("@UserFullName", update.UserFullName ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserName", update.UserName ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserPasswordText", update.UserPassword ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserEmail", update.UserEmail ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserPhoneNumber", update.UserPhoneNumber ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@UserCountryId", update.UserCountryId));
                    cmd.Parameters.Add(new SqlParameter("@UserGenderId", update.UserGenderId));
                    cmd.Parameters.Add(new SqlParameter("@UserBirthDay", (object)update.UserBirthDay ?? DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@UserModificatorId", update.UserModificatorId));
                    cmd.Parameters.Add(new SqlParameter("@UserModificationDate", (object)update.UserModificationDate ?? DBNull.Value));

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
                respuesta.Resultado = 0;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Delete_Users(Tbl_User_Delete_DTOs delete)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_SECURITY].[Delete_Users]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@UserId", delete.UserId));
                    cmd.Parameters.Add(new SqlParameter("@UserModificatorId", delete.UserModificatorId));
                    cmd.Parameters.Add(new SqlParameter("@UserModificationDate", (object)delete.UserModificationDate ?? DBNull.Value));

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
                respuesta.Resultado = 0;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }
        public async Task<(MensajeDTOs Control, AuthResponseDto? UserData)> ValidateLoginAsync(Login_DTOs loginDto)
        {
            var control = new MensajeDTOs();
            AuthResponseDto? userData = null;

            using var connection = _connection.CreateConetion();
            using var command = new SqlCommand("[SQM_SECURITY].[SP_ValidateUserLogin]", connection);
            command.CommandType = CommandType.StoredProcedure;

            // Parámetros de Entrada
            command.Parameters.Add(new SqlParameter("@Email", loginDto.UserName ?? string.Empty));
            command.Parameters.Add(new SqlParameter("@PasswordText", loginDto.UserPassword ?? string.Empty));

            // Parámetros de Salida (OUTPUT) según tu SP
            var pResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };
            var pMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 255) { Direction = ParameterDirection.Output };
            command.Parameters.Add(pResultado);
            command.Parameters.Add(pMensaje);

            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync();

            // Ejecutamos el Reader asíncronamente para extraer el Recordset del SELECT del SP
            using (var reader = await command.ExecuteReaderAsync())
            {
                if (await reader.ReadAsync())
                {
                    userData = new AuthResponseDto
                    {
                        UserId = reader["UserId"] == DBNull.Value ? 0 : Convert.ToInt32(reader["UserId"]),
                        FullName = reader["FullName"] == DBNull.Value ? string.Empty : reader["FullName"].ToString()!,
                        Email = reader["Email"] == DBNull.Value ? string.Empty : reader["Email"].ToString()!,

                        // ▄ CORRECCIÓN: Leemos el Rol que agregamos en el SELECT de tu Procedimiento Almacenado
                        UserRole = reader["UserRole"] == DBNull.Value ? "Cliente Registrado" : reader["UserRole"].ToString()!
                    };
                }
            }

            // Capturar los valores OUTPUT de manera segura tras cerrar el reader
            control.Resultado = (pResultado.Value != DBNull.Value) ? Convert.ToInt32(pResultado.Value) : 500;
            control.Messaje = (pMensaje.Value != DBNull.Value) ? pMensaje.Value.ToString() : "Error interno en el procesamiento de autenticación.";

            return (control, userData);
        }
    }
}
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
    public class UserRoles_Repository(DBConectionFactory connection) : IUserRolesRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<UserRole>> List_UserRoles()
        {
            List<UserRole> lista = [];
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_SECURITY].[List_UserRoles]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToUserRole(dr));
            }
            return lista;
        }

        public async Task<IEnumerable<UserRole>> Filt_List_UserRoles(string filt)
        {
            List<UserRole> lista = [];
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_SECURITY].[Filt_list_UserRoles]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filt ?? (object)DBNull.Value));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToUserRole(dr));
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_List_UserRoles(UserRole_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Insert_list_UserRoles]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@userRoleUserId", (object?)create.UserRoleUserId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@userRoleRoleId", (object?)create.UserRoleRoleId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@userRoleCreatorId", (object?)create.UserRoleCreatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@userRoleCreationDate", (object?)create.UserRoleCreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Bit) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString() ?? string.Empty;
                bool exito = OutResultado.Value != DBNull.Value && Convert.ToBoolean(OutResultado.Value);
                respuesta.Resultado = exito ? 201 : 400;
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Update_List_UserRoles(UserRole_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Update_list_UserRoles]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@userRoleId", update.UserRoleId));
                cmd.Parameters.Add(new SqlParameter("@userRoleUserId", (object?)update.UserRoleUserId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@userRoleRoleId", (object?)update.UserRoleRoleId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@userRoleCreatorId", (object?)update.UserRoleCreatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@userRoleCreationDate", (object?)update.UserRoleCreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Bit) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString() ?? string.Empty;
                bool exito = OutResultado.Value != DBNull.Value && Convert.ToBoolean(OutResultado.Value);
                respuesta.Resultado = exito ? 200 : 400;
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Delete_List_UserRoles(UserRole_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Delete_list_UserRoles]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@userRoleId", delete.UserRoleId));
                cmd.Parameters.Add(new SqlParameter("@userRoleCreatorId", (object?)delete.UserRoleCreatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@userRoleCreationDate", (object?)delete.UserRoleCreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Bit) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString() ?? string.Empty;
                bool exito = OutResultado.Value != DBNull.Value && Convert.ToBoolean(OutResultado.Value);
                respuesta.Resultado = exito ? 200 : 400;
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        private static UserRole MapToUserRole(SqlDataReader dr)
        {
            return new UserRole
            {
                UserRoleId = dr["userRoleId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userRoleId"]),
                UserRoleUserId = dr["userRoleUserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userRoleUserId"]),
                UserName = dr["userName"] == DBNull.Value ? string.Empty : dr["userName"].ToString() ?? string.Empty,
                UserEmail = dr["userEmail"] == DBNull.Value ? string.Empty : dr["userEmail"].ToString() ?? string.Empty,
                UserRoleRoleId = dr["userRoleRoleId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userRoleRoleId"]),
                RoleName = dr["roleName"] == DBNull.Value ? string.Empty : dr["roleName"].ToString() ?? string.Empty,
                UserRoleCreatorId = dr["userRoleCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["userRoleCreatorId"]),
                UserRoleCreationDate = dr["userRoleCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["userRoleCreationDate"])
            };
        }

        public async Task<MensajeDTOs> AssignRoleBySuperAdminAsync(int targetUserId, int targetRoleId, int adminUserId)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Insert_Assign_UserRole_SuperAdmin]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@userRoleUserId", targetUserId));
                cmd.Parameters.Add(new SqlParameter("@userRoleRoleId", targetRoleId));
                cmd.Parameters.Add(new SqlParameter("@superAdminUserId", adminUserId));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString() ?? string.Empty;
                respuesta.Resultado = OutResultado.Value != DBNull.Value ? Convert.ToInt32(OutResultado.Value) : 500;
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
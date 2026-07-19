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
    public class Roles_Repository(DBConectionFactory connection) : IRolesRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<Role>> List_Roles()
        {
            List<Role> lista = [];
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_SECURITY].[List_Roles]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToRole(dr));
            }
            return lista;
        }

        public async Task<IEnumerable<Role>> Filt_List_Roles(string filt)
        {
            List<Role> lista = [];
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_SECURITY].[Filt_list_Roles]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filt ?? (object)DBNull.Value));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToRole(dr));
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_List_Roles(Role_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Insert_list_Roles]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@roleName", (object?)create.RoleName ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@roleDescription", (object?)create.RoleDescription ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@roleCreatorId", (object?)create.RoleCreatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@roleCreationDate", (object?)create.RoleCreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString() ?? string.Empty;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 500 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Update_List_Roles(Role_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Update_list_Roles]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@roleId", update.RoleId));
                cmd.Parameters.Add(new SqlParameter("@roleName", (object?)update.RoleName ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@roleDescription", (object?)update.RoleDescription ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@roleModificatorId", (object?)update.RoleModificatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@roleModificationDate", (object?)update.RoleModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString() ?? string.Empty;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 500 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Delete_List_Roles(Role_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Delete_list_Roles]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@roleId", delete.RoleId));
                cmd.Parameters.Add(new SqlParameter("@roleModificatorId", (object?)delete.RoleModificatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@roleModificationDate", (object?)delete.RoleModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString() ?? string.Empty;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 500 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        private static Role MapToRole(SqlDataReader dr)
        {
            return new Role
            {
                RoleId = dr["roleId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["roleId"]),
                RoleName = dr["roleName"] == DBNull.Value ? string.Empty : dr["roleName"].ToString() ?? string.Empty,
                RoleDescription = dr["roleDescription"] == DBNull.Value ? string.Empty : dr["roleDescription"].ToString() ?? string.Empty,
                RoleCreatorId = dr["roleCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["roleCreatorId"]),
                RoleCreationDate = dr["roleCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["roleCreationDate"]),
                RoleModificatorId = dr["roleModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["roleModificatorId"]),
                RoleModificationDate = dr["roleModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["roleModificationDate"])
            };
        }
    }
}
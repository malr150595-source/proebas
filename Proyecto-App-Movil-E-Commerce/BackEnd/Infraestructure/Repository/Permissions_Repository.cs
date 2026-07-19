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
    public class Permissions_Repository(DBConectionFactory connection) : IPermissionsRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<Permission>> List_Permissions()
        {
            List<Permission> lista = [];
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_SECURITY].[List_Permissions]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Permission
                {
                    PermissionId = dr["permissionId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["permissionId"]),
                    PermissionName = dr["permissionName"] == DBNull.Value ? string.Empty : dr["permissionName"].ToString() ?? string.Empty,
                    PermissionDescription = dr["permissionDescription"] == DBNull.Value ? string.Empty : dr["permissionDescription"].ToString() ?? string.Empty,
                    PermissionModule = dr["permissionModule"] == DBNull.Value ? string.Empty : dr["permissionModule"].ToString() ?? string.Empty,
                    PermissionCreatorId = dr["permissionCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["permissionCreatorId"]),
                    PermissionCreationDate = dr["permissionCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["permissionCreationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<Permission>> Filt_List_Permissions(string filt)
        {
            List<Permission> lista = [];
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_SECURITY].[Filt_list_Permissions]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filt ?? (object)DBNull.Value));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Permission
                {
                    PermissionId = dr["permissionId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["permissionId"]),
                    PermissionName = dr["permissionName"] == DBNull.Value ? string.Empty : dr["permissionName"].ToString() ?? string.Empty,
                    PermissionDescription = dr["permissionDescription"] == DBNull.Value ? string.Empty : dr["permissionDescription"].ToString() ?? string.Empty,
                    PermissionModule = dr["permissionModule"] == DBNull.Value ? string.Empty : dr["permissionModule"].ToString() ?? string.Empty,
                    PermissionCreatorId = dr["permissionCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["permissionCreatorId"]),
                    PermissionCreationDate = dr["permissionCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["permissionCreationDate"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_List_Permissions(Permission_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Insert_list_Permissions]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@permissionName", (object?)create.PermissionName ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@permissionDescription", (object?)create.PermissionDescription ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@permissionModule", (object?)create.PermissionModule ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@permissionCreatorId", (object?)create.PermissionCreatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@permissionCreationDate", (object?)create.PermissionCreationDate ?? DBNull.Value));

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

        public async Task<IEnumerable<RolePermission>> List_PermissionsByRole(int roleId)
        {
            List<RolePermission> lista = [];
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_SECURITY].[List_PermissionsByRole]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@roleId", roleId));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new RolePermission
                {
                    RolePermissionId = dr["rolePermissionId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["rolePermissionId"]),
                    RolePermissionRoleId = dr["rolePermissionRoleId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["rolePermissionRoleId"]),
                    RoleName = dr["roleName"] == DBNull.Value ? string.Empty : dr["roleName"].ToString() ?? string.Empty,
                    RolePermissionPermissionId = dr["rolePermissionPermissionId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["rolePermissionPermissionId"]),
                    PermissionName = dr["permissionName"] == DBNull.Value ? string.Empty : dr["permissionName"].ToString() ?? string.Empty,
                    PermissionDescription = dr["permissionDescription"] == DBNull.Value ? string.Empty : dr["permissionDescription"].ToString() ?? string.Empty,
                    PermissionModule = dr["permissionModule"] == DBNull.Value ? string.Empty : dr["permissionModule"].ToString() ?? string.Empty
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Assign_PermissionToRole(RolePermission_Assign_DTO assign)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Assign_PermissionToRole]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@roleId", (object?)assign.RoleId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@permissionId", (object?)assign.PermissionId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@creatorId", (object?)assign.CreatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@creationDate", (object?)assign.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Revoke_PermissionFromRole(RolePermission_Revoke_DTO revoke)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Revoke_PermissionFromRole]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@roleId", (object?)revoke.RoleId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@permissionId", (object?)revoke.PermissionId ?? DBNull.Value));

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
    }
}
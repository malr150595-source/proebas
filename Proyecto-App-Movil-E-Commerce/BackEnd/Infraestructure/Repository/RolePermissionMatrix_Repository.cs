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
    public class RolePermissionMatrix_Repository(DBConectionFactory connection) : IRolePermissionMatrixRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<RolePermissionMatrix>> List_RolePermissions()
        {
            List<RolePermissionMatrix> lista = [];
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_SECURITY].[List_RolePermissions]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToMatrix(dr));
            }
            return lista;
        }

        public async Task<IEnumerable<RolePermissionMatrix>> Filt_List_RolePermissions(string filt)
        {
            List<RolePermissionMatrix> lista = [];
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_SECURITY].[Filt_list_RolePermissions]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filt ?? (object)DBNull.Value));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToMatrix(dr));
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_List_RolePermissions(RolePermissionMatrix_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Insert_list_RolePermissions]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@rolePermissionRoleId", (object?)create.RolePermissionRoleId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@rolePermissionPermissionId", (object?)create.RolePermissionPermissionId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@rolePermissionCreatorId", (object?)create.RolePermissionCreatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@rolePermissionCreationDate", (object?)create.RolePermissionCreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_List_RolePermissions(RolePermissionMatrix_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Update_list_RolePermissions]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@rolePermissionId", update.RolePermissionId));
                cmd.Parameters.Add(new SqlParameter("@rolePermissionRoleId", (object?)update.RolePermissionRoleId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@rolePermissionPermissionId", (object?)update.RolePermissionPermissionId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@rolePermissionCreatorId", (object?)update.RolePermissionCreatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@rolePermissionCreationDate", (object?)update.RolePermissionCreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_List_RolePermissions(RolePermissionMatrix_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_SECURITY].[Delete_list_RolePermissions]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@rolePermissionId", delete.RolePermissionId));
                cmd.Parameters.Add(new SqlParameter("@rolePermissionCreatorId", (object?)delete.RolePermissionCreatorId ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@rolePermissionCreationDate", (object?)delete.RolePermissionCreationDate ?? DBNull.Value));

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

        private static RolePermissionMatrix MapToMatrix(SqlDataReader dr)
        {
            return new RolePermissionMatrix
            {
                RolePermissionId = dr["rolePermissionId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["rolePermissionId"]),
                RolePermissionRoleId = dr["rolePermissionRoleId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["rolePermissionRoleId"]),
                RoleName = dr["roleName"] == DBNull.Value ? string.Empty : dr["roleName"].ToString() ?? string.Empty,
                RolePermissionPermissionId = dr["rolePermissionPermissionId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["rolePermissionPermissionId"]),
                PermissionName = dr["permissionName"] == DBNull.Value ? string.Empty : dr["permissionName"].ToString() ?? string.Empty,
                PermissionModule = dr["permissionModule"] == DBNull.Value ? string.Empty : dr["permissionModule"].ToString() ?? string.Empty,
                RolePermissionCreatorId = dr["rolePermissionCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["rolePermissionCreatorId"]),
                RolePermissionCreationDate = dr["rolePermissionCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["rolePermissionCreationDate"])
            };
        }
    }
}
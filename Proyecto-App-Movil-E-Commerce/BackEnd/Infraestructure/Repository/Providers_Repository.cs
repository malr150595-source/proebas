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
    public class Providers_Repository : IProvidersRepository
    {
        private readonly DBConectionFactory _connection;

        public Providers_Repository(DBConectionFactory connection)
        {
            _connection = connection;
        }

        public async Task<IEnumerable<Provider>> List_Providers()
        {
            var lista = new List<Provider>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[List_Providers]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Provider
                {
                    ProveedorId = dr["ProveedorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProveedorId"]),
                    ProveedorNombre = dr["ProveedorNombre"] == DBNull.Value ? string.Empty : dr["ProveedorNombre"].ToString()!,
                    ProveedorDescripcion = dr["ProveedorDescripcion"] == DBNull.Value ? string.Empty : dr["ProveedorDescripcion"].ToString()!,
                    ProveedorCreadorId = dr["ProveedorCreadorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProveedorCreadorId"]),
                    ProveedorCreadorFecha = dr["ProveedorCreadorFecha"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["ProveedorCreadorFecha"]),
                    ProveedorIdModificacion = dr["ProveedorIdModificacion"] == DBNull.Value ? null : Convert.ToInt32(dr["ProveedorIdModificacion"]),
                    ProveedorModificacionFecha = dr["ProveedorModificacionFecha"] == DBNull.Value ? null : Convert.ToDateTime(dr["ProveedorModificacionFecha"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<Provider>> Filt_List_Providers(string filtro)
        {
            var lista = new List<Provider>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Filt_list_Providers]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filtro", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Provider
                {
                    ProveedorId = dr["ProveedorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProveedorId"]),
                    ProveedorNombre = dr["ProveedorNombre"] == DBNull.Value ? string.Empty : dr["ProveedorNombre"].ToString()!,
                    ProveedorDescripcion = dr["ProveedorDescripcion"] == DBNull.Value ? string.Empty : dr["ProveedorDescripcion"].ToString()!,
                    ProveedorCreadorId = dr["ProveedorCreadorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProveedorCreadorId"]),
                    ProveedorCreadorFecha = dr["ProveedorCreadorFecha"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["ProveedorCreadorFecha"]),
                    ProveedorIdModificacion = dr["ProveedorIdModificacion"] == DBNull.Value ? null : Convert.ToInt32(dr["ProveedorIdModificacion"]),
                    ProveedorModificacionFecha = dr["ProveedorModificacionFecha"] == DBNull.Value ? null : Convert.ToDateTime(dr["ProveedorModificacionFecha"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_Providers(Provider_Insert_DTO create)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Insert_Providers]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@ProviderName", create.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@ProviderDescription", create.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@ProviderCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@ProviderCreationDate", (object)create.CreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Update_Providers(Provider_Update_DTO update)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Update_Providers]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@ProviderId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@ProviderName", update.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@ProviderDescription", update.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@ProviderModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@ProviderModificationDate", (object)update.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Delete_Providers(Provider_Delete_DTO delete)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Delete_Providers]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@ProviderId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@ProviderModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@ProviderModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
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
using Application.DTOs;
using Application.Interface;
using Application.Services;
using Domain;
using Infraestructure.Db;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using static Application.DTOs.Sub_CategoryDTO;

namespace Infraestructure.Repository
{
    public class SubCategories_Repository : ISubcategory_Repository
    {
        private readonly DBConectionFactory _connection;

        public SubCategories_Repository(DBConectionFactory connection)
        {
            _connection = connection;
        }

        public async Task<IEnumerable<SubCategory>> List_SubCategories()
        {
            var lista = new List<SubCategory>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[List_SubCategories]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new SubCategory
                {
                    Id = dr["Id"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Id"]),
                    Nombre = dr["Nombre"] == DBNull.Value ? string.Empty : dr["Nombre"].ToString()!,
                    Descripcion = dr["Descripción"] == DBNull.Value ? string.Empty : dr["Descripción"].ToString(),
                    IdCreador = dr["IdCreador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdCreador"]),
                    FechaCreacion = dr["FechaCreación"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["FechaCreación"]),
                    IdModificador = dr["IdModificador"] == DBNull.Value ? null : Convert.ToInt32(dr["IdModificador"]),
                    FechaModificacion = dr["FechaModificación"] == DBNull.Value ? null : Convert.ToDateTime(dr["FechaModificación"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<SubCategory>> Filt_List_SubCategories(string filtro)
        {
            var lista = new List<SubCategory>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Filt_List_SubCategories]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@filtro", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new SubCategory
                {
                    Id = dr["Id"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Id"]),
                    Nombre = dr["Nombre"] == DBNull.Value ? string.Empty : dr["Nombre"].ToString()!,
                    Descripcion = dr["Descripción"] == DBNull.Value ? string.Empty : dr["Descripción"].ToString(),
                    IdCreador = dr["IdCreador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdCreador"]),
                    FechaCreacion = dr["FechaCreación"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["FechaCreación"]),
                    IdModificador = dr["IdModificador"] == DBNull.Value ? null : Convert.ToInt32(dr["IdModificador"]),
                    FechaModificacion = dr["FechaModificación"] == DBNull.Value ? null : Convert.ToDateTime(dr["FechaModificación"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_SubCategories(SubCategory_Insert_DTO create)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Insert_SubCategories]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@subCategoryName", create.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@subCategoryDescription", create.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@subCategoryCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@subCategoryCreationDate", (object)create.CreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 100) { Direction = ParameterDirection.Output };
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

        public async Task<MensajeDTOs> Update_SubCategories(SubCategory_Update_DTO update)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Update_SubCategories]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@subCategoryId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@subCategoryName", update.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@subCategoryDescription", update.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@subCategoryModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@subCategoryModificationDate", (object)update.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 100) { Direction = ParameterDirection.Output };
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

        public async Task<MensajeDTOs> Delete_SubCategories(SubCategory_Delete_DTO delete)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Delete_SubCategories]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@subCategoryId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@subCategoryModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@subCategoryModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 100) { Direction = ParameterDirection.Output };
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
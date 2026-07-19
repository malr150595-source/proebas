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
using static Application.DTOs.Category_DTOs;

namespace Infraestructure.Repository
{
    public class Categories_Repository : ICategoriesRepository
    {
        private readonly DBConectionFactory _connection;

        public Categories_Repository(DBConectionFactory connection)
        {
            _connection = connection;
        }

        public async Task<IEnumerable<Category>> List_Categories()
        {
            var lista = new List<Category>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[List_Categories]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Category
                {
                    Id = dr["Id"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Id"]),
                    Nombre = dr["Nombre"] == DBNull.Value ? string.Empty : dr["Nombre"].ToString()!,
                    Descripcion = dr["Descripción"] == DBNull.Value ? string.Empty : dr["Descripción"].ToString(),
                    IdCreador = dr["Id_Creador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Id_Creador"]),
                    FechaCreacion = dr["Fecha_Creación"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["Fecha_Creación"]),
                    IdModificador = dr["Id_Modificador"] == DBNull.Value ? null : Convert.ToInt32(dr["Id_Modificador"]),
                    FechaModificacion = dr["Fecha_Modificación"] == DBNull.Value ? null : Convert.ToDateTime(dr["Fecha_Modificación"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<Category>> Filt_List_Categories(string criterio)
        {
            var lista = new List<Category>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[filt_List_Categories]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Criterio", criterio ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Category
                {
                    Id = dr["Id"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Id"]),
                    Nombre = dr["Nombre"] == DBNull.Value ? string.Empty : dr["Nombre"].ToString()!,
                    Descripcion = dr["Descripción"] == DBNull.Value ? string.Empty : dr["Descripción"].ToString(),
                    IdCreador = dr["Id_Creador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Id_Creador"]),
                    FechaCreacion = dr["Fecha_Creación"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["Fecha_Creación"]),
                    IdModificador = dr["Id_Modificador"] == DBNull.Value ? null : Convert.ToInt32(dr["Id_Modificador"]),
                    FechaModificacion = dr["Fecha_Modificación"] == DBNull.Value ? null : Convert.ToDateTime(dr["Fecha_Modificación"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_Categories(Category_Insert_DTO create)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Insert_Categories]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@categoryName", create.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@categoryDescription", create.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@categoryCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@categoryCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_Categories(Category_Update_DTO update)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Update_Categories]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@categoryId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@categoryName", update.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@categoryDescription", update.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@categoryModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@categoryModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_Categories(Category_Delete_DTO delete)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Delete_Categories]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@categoryId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@categoryModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@categoryModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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
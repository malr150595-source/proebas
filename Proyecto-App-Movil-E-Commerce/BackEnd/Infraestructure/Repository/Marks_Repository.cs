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
    public class Marks_Repository : IMarksRepository
    {
        private readonly DBConectionFactory _connection;

        public Marks_Repository(DBConectionFactory connection)
        {
            _connection = connection;
        }

        public async Task<IEnumerable<Mark>> List_Marks()
        {
            var lista = new List<Mark>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[List_Marks]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Mark
                {
                    IdMarca = dr["IdMarca"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdMarca"]),
                    NombreMarca = dr["NombreMarca"] == DBNull.Value ? string.Empty : dr["NombreMarca"].ToString()!,
                    DescripcionMarca = dr["DescripcionMarca"] == DBNull.Value ? string.Empty : dr["DescripcionMarca"].ToString()!,
                    CreadorMarcaId = dr["CreadorMarcaId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["CreadorMarcaId"]),
                    CreadorMarcaFecha = dr["CreadorMarcaFecha"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["CreadorMarcaFecha"]),
                    MarcaModificadorId = dr["MarcaModificadorId"] == DBNull.Value ? null : Convert.ToInt32(dr["MarcaModificadorId"]),
                    MarcaModificadorFecha = dr["MarcaModificadorFecha"] == DBNull.Value ? null : Convert.ToDateTime(dr["MarcaModificadorFecha"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<Mark>> Filt_List_Marks(string filtro)
        {
            var lista = new List<Mark>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Filt_list_Marks]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Mark
                {
                    IdMarca = dr["IdMarca"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdMarca"]),
                    NombreMarca = dr["NombreMarca"] == DBNull.Value ? string.Empty : dr["NombreMarca"].ToString()!,
                    DescripcionMarca = dr["DescripcionMarca"] == DBNull.Value ? string.Empty : dr["DescripcionMarca"].ToString()!,
                    CreadorMarcaId = dr["CreadorMarcaId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["CreadorMarcaId"]),
                    CreadorMarcaFecha = dr["CreadorMarcaFecha"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["CreadorMarcaFecha"]),
                    MarcaModificadorId = dr["MarcaModificadorId"] == DBNull.Value ? null : Convert.ToInt32(dr["MarcaModificadorId"]),
                    MarcaModificadorFecha = dr["MarcaModificadorFecha"] == DBNull.Value ? null : Convert.ToDateTime(dr["MarcaModificadorFecha"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_Marks(Mark_Insert_DTO create)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Insert_list_Marks]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@MarkName", create.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@MarkDescription", create.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@MarkCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@MarkCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_Marks(Mark_Update_DTO update)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Update_list_Marks]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@MarkId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@MarkName", update.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@MarkDescription", update.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@MarkModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@MarkModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_Marks(Mark_Delete_DTO delete)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Delete_list_Marks]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@MarkId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@MarkModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@MarkModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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
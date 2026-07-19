using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Text;
using Application.DTOs;
using Infraestructure.Db;
using Microsoft.Data.SqlClient;
using Microsoft.Data;
using System.Data;
using Application.Interface;

namespace Infraestructure.Infraestructure 
{
    public class Tbl_Status_Repository : ITbl_Status
    {
        private readonly DBConectionFactory _connection;

        public Tbl_Status_Repository(DBConectionFactory connection)
        {
            _connection = connection;
        }

        public async Task<IEnumerable<Tbl_Status>> List_Status()
        {
            var lista = new List<Tbl_Status>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[List_Tbl_Status]", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                {
                    while (dr.Read())
                    {
                        lista.Add(new Tbl_Status{
                          StatusId = dr["IdEstado"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdEstado"]),
                          StatusName = dr["Estado"] == DBNull.Value ? string.Empty : dr["Estado"].ToString(),
                          StatusCreatorId = dr["IdCreador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdCreador"]),
                          StatusCreationDate = dr["FechaCreacion"] == DBNull.Value ? null : Convert.ToDateTime(dr["FechaCreacion"]),
                          StatusModificatorId = dr["IdModificador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdModificador"]),
                          StatusModificationDate = dr["FechaModificacion"] == DBNull.Value ? null : Convert.ToDateTime(dr["FechaModificacion"]),
                        });
                    }
                }
            }
            return lista;
        }

        public async Task<IEnumerable<Tbl_Status>> Filt_list_Status(string nombre)
        {
            var lista = new List<Tbl_Status>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Filt_List_Tbl_Status]", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@Criterio", nombre ?? string.Empty));
                using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                {
                    while (dr.Read())
                    {
                        lista.Add(new Tbl_Status{
                          StatusId = dr["IdEstado"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdEstado"]),
                          StatusName = dr["Estado"] == DBNull.Value ? string.Empty : dr["Estado"].ToString(),
                          StatusCreatorId = dr["IdCreador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdCreador"]),
                          StatusCreationDate = dr["FechaCreacion"] == DBNull.Value ? null : Convert.ToDateTime(dr["FechaCreacion"]),
                          StatusModificatorId = dr["IdModificador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdModificador"]),
                          StatusModificationDate = dr["FechaModificacion"] == DBNull.Value ? null : Convert.ToDateTime(dr["FechaModificacion"]),
                        });
                    }
                }
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_Status(Tbl_Create_Status create)
        {
                var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Insert_Tbl_Status]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@StatusName",create.StatusName ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@StatusCreatorId",create.StatusCreatorId));
                    cmd.Parameters.Add(new SqlParameter("@StatusCreationDate", (object)create.StatusCreationDate ?? DBNull.Value));

                    SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output, Value = DBNull.Value };
                    SqlParameter OutResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(OutMensaje);
                    cmd.Parameters.Add(OutResultado);

                    await cmd.ExecuteNonQueryAsync();

                    respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                    respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
                }
            }
            catch(SqlException ex)
            {
                respuesta.Resultado = 0;
                respuesta.Messaje = ex.Message;
            }

            return respuesta;
        }
        public async Task<MensajeDTOs> Update_Status(Tbl_Update_Status update)
        {
                var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Update_Tbl_Status]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@StatusId",update.StatusId));
                    cmd.Parameters.Add(new SqlParameter("@StatusName",update.StatusName ?? string.Empty));
                    cmd.Parameters.Add(new SqlParameter("@StatusModificatorId",update.StatusModificatorId));
                    cmd.Parameters.Add(new SqlParameter("@StatusModificationDate",(object)update.StatusModificationDate ?? DBNull.Value ));

                    SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output, Value = DBNull.Value };
                    SqlParameter OutResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(OutMensaje);
                    cmd.Parameters.Add(OutResultado);

                    await cmd.ExecuteNonQueryAsync();

                    respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                    respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
                }
            }
            catch(SqlException ex)
            {
                respuesta.Resultado = 0;
                respuesta.Messaje = ex.Message;
            }

            return respuesta;
        }
        public async Task<MensajeDTOs> Delete_Status(Tbl_Delete_Status delete)
        {
                var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[delete_Tbl_Status]", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@StatusId",delete.StatusId));
                    cmd.Parameters.Add(new SqlParameter("@StatusModificatorId",delete.StatusModificatorId));
                    cmd.Parameters.Add(new SqlParameter("@StatusModificationDate",(object)delete.StatusModificationDate ?? DBNull.Value));

                    SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output, Value = DBNull.Value };
                    SqlParameter OutResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(OutMensaje);
                    cmd.Parameters.Add(OutResultado);

                    await cmd.ExecuteNonQueryAsync();

                    respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                    respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
                }
            }
            catch(SqlException ex)
            {
                respuesta.Resultado = 0;
                respuesta.Messaje = ex.Message;
            }

            return respuesta;
        }
    }
}

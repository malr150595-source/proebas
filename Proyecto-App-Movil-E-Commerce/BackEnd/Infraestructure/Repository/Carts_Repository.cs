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
    public class Carts_Repository(DBConectionFactory connection) : ICartsRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<Cart>> List_Carts()
        {
            List<Cart> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_Carts]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    CartId = dr["cartId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartId"]),
                    CartUserId = dr["cartUserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartUserId"]),
                    UserFullNameRef = dr["userFullNameRef"] == DBNull.Value ? string.Empty : dr["userFullNameRef"].ToString()!,
                    CartCreatorId = dr["cartCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartCreatorId"]),
                    CartCreationDate = dr["cartCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["cartCreationDate"]),
                    CartModificatorId = dr["cartModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["cartModificatorId"]),
                    CartModificationDate = dr["cartModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["cartModificationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<Cart>> Filt_List_Carts(int filtro)
        {
            List<Cart> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_Carts]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    CartId = dr["cartId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartId"]),
                    CartUserId = dr["cartUserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartUserId"]),
                    UserFullNameRef = dr["userFullNameRef"] == DBNull.Value ? string.Empty : dr["userFullNameRef"].ToString()!,
                    CartCreatorId = dr["cartCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartCreatorId"]),
                    CartCreationDate = dr["cartCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["cartCreationDate"]),
                    CartModificatorId = dr["cartModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["cartModificatorId"]),
                    CartModificationDate = dr["cartModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["cartModificationDate"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_Carts(Cart_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_Carts]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@cartUserId", create.UserId));
                cmd.Parameters.Add(new SqlParameter("@cartCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@cartCreationDate", (object)create.CreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString()!;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Update_Carts(Cart_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_Carts]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@cartId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@cartUserId", update.UserId));
                cmd.Parameters.Add(new SqlParameter("@cartModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@cartModificationDate", (object)update.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString()!;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Delete_Carts(Cart_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_Carts]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@cartId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@cartModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@cartModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString()!;
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
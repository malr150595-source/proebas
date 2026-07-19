using Application.DTOs;
using Application.Interface;
using Domain;
using Infraestructure.Db;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using static Application.DTOs.ProductVariableType_DTOs;

namespace Infraestructure.Repository
{
    public class ProductVariableTypes_Repository(DBConectionFactory connection) : IProductVariableTypesRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<ProductVariableType>> List_ProductVariableTypes()
        {
            List<ProductVariableType> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_CATALOGS].[List_ProductVariableTypes]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    ProductVariableTypeId = dr["productVariableTypeId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableTypeId"]),
                    ProductVariableTypeName = dr["productVariableTypeName"] == DBNull.Value ? string.Empty : dr["productVariableTypeName"].ToString()!,
                    ProductVariableTypeDescription = dr["productVariableTypeDescription"] == DBNull.Value ? string.Empty : dr["productVariableTypeDescription"].ToString()!,
                    ProductVariableTypeCreatorId = dr["productVariableTypeCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableTypeCreatorId"]),
                    ProductVariableTypeCreationDate = dr["productVariableTypeCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["productVariableTypeCreationDate"]),
                    ProductVariableTypeModificatorId = dr["productVariableTypeModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["productVariableTypeModificatorId"]),
                    ProductVariableTypeModificationDate = dr["productVariableTypeModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["productVariableTypeModificationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<ProductVariableType>> Filt_List_ProductVariableTypes(string filtro)
        {
            List<ProductVariableType> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_CATALOGS].[Filt_list_ProductVariableTypes]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    ProductVariableTypeId = dr["productVariableTypeId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableTypeId"]),
                    ProductVariableTypeName = dr["productVariableTypeName"] == DBNull.Value ? string.Empty : dr["productVariableTypeName"].ToString()!,
                    ProductVariableTypeDescription = dr["productVariableTypeDescription"] == DBNull.Value ? string.Empty : dr["productVariableTypeDescription"].ToString()!,
                    ProductVariableTypeCreatorId = dr["productVariableTypeCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productVariableTypeCreatorId"]),
                    ProductVariableTypeCreationDate = dr["productVariableTypeCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["productVariableTypeCreationDate"]),
                    ProductVariableTypeModificatorId = dr["productVariableTypeModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["productVariableTypeModificatorId"]),
                    ProductVariableTypeModificationDate = dr["productVariableTypeModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["productVariableTypeModificationDate"])
                });
            }
            return lista;
        }

        // --- FUNCIÓN DE INSERTAR ---
        public async Task<MensajeDTOs> Insert_ProductVariableTypes(ProductVariableType_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_CATALOGS].[Insert_ProductVariableTypes]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@productVariableTypeName", create.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productVariableTypeDescription", create.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productVariableTypeCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@productVariableTypeCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        // --- FUNCIÓN DE ACTUALIZAR ---
        public async Task<MensajeDTOs> Update_ProductVariableTypes(ProductVariableType_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_CATALOGS].[Update_ProductVariableTypes]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@productVariableTypeId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@productVariableTypeName", update.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productVariableTypeDescription", update.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productVariableTypeModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@productVariableTypeModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        // --- FUNCIÓN DE ELIMINAR ---
        public async Task<MensajeDTOs> Delete_ProductVariableTypes(ProductVariableType_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_CATALOGS].[Delete_ProductVariableTypes]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@productVariableTypeId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@productVariableTypeModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@productVariableTypeModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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
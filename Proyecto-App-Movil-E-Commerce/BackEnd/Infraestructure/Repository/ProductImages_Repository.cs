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
    public class ProductImages_Repository(DBConectionFactory connection) : IProductImagesRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<ProductImage>> List_ProductImages()
        {
            List<ProductImage> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_ProductImages]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    ProductImageId = dr["productImageId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productImageId"]),
                    ProductImageProductId = dr["productImageProductId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productImageProductId"]),
                    ProductImageURL = dr["productImageURL"] == DBNull.Value ? string.Empty : dr["productImageURL"].ToString()!,
                    ProductImageDescription = dr["productImageDescription"] == DBNull.Value ? string.Empty : dr["productImageDescription"].ToString()!,
                    ProductImageIsPrincipal = dr["productImageIsPrincipal"] != DBNull.Value && Convert.ToBoolean(dr["productImageIsPrincipal"]),
                    ProductImageCreatorId = dr["productImageCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productImageCreatorId"]),
                    ProductImageCreationDate = dr["productImageCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["productImageCreationDate"]),
                    ProductImageModificatorId = dr["productImageModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["productImageModificatorId"]),
                    ProductImageModificationDate = dr["productImageModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["productImageModificationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<ProductImage>> Filt_List_ProductImages(string filtro)
        {
            List<ProductImage> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_ProductImages]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    ProductImageId = dr["productImageId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productImageId"]),
                    ProductImageProductId = dr["productImageProductId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productImageProductId"]),
                    ProductImageURL = dr["productImageURL"] == DBNull.Value ? string.Empty : dr["productImageURL"].ToString()!,
                    ProductImageDescription = dr["productImageDescription"] == DBNull.Value ? string.Empty : dr["productImageDescription"].ToString()!,
                    ProductImageIsPrincipal = dr["productImageIsPrincipal"] != DBNull.Value && Convert.ToBoolean(dr["productImageIsPrincipal"]),
                    ProductImageCreatorId = dr["productImageCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["productImageCreatorId"]),
                    ProductImageCreationDate = dr["productImageCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["productImageCreationDate"]),
                    ProductImageModificatorId = dr["productImageModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["productImageModificatorId"]),
                    ProductImageModificationDate = dr["productImageModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["productImageModificationDate"])
                });
            }
            return lista;
        }

        // --- FUNCIÓN DE INSERTAR ---
        public async Task<MensajeDTOs> Insert_ProductImages(ProductImage_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_ProductImages]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@productImageProductId", create.ProductId));
                cmd.Parameters.Add(new SqlParameter("@productImageURL", create.URL ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productImageDescription", create.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productImageIsPrincipal", create.IsPrincipal));
                cmd.Parameters.Add(new SqlParameter("@productImageCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@productImageCreationDate", (object)create.CreationDate ?? DBNull.Value));

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
        public async Task<MensajeDTOs> Update_ProductImages(ProductImage_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_ProductImages]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@productImageId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@productImageProductId", update.ProductId));
                cmd.Parameters.Add(new SqlParameter("@productImageURL", update.URL ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productImageDescription", update.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@productImageIsPrincipal", update.IsPrincipal));
                cmd.Parameters.Add(new SqlParameter("@productImageModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@productImageModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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
        public async Task<MensajeDTOs> Delete_ProductImages(ProductImage_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_ProductImages]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@productImageId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@productImageModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@productImageModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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
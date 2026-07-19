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
    public class CartDetails_Repository(DBConectionFactory connection) : ICartDetailsRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<CartDetail>> List_CartDetails(int cartId)
        {
            List<CartDetail> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_CartDetails]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@cartDetailCartId", cartId));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    CartDetailId = dr["cartDetailId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailId"]),
                    CartDetailCartId = dr["cartDetailCartId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailCartId"]),
                    CartDetailProductVariableId = dr["cartDetailProductVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailProductVariableId"]),
                    ProductVariableValueRef = dr["productVariableValueRef"] == DBNull.Value ? string.Empty : dr["productVariableValueRef"].ToString()!,
                    CartDetailPrice = dr["cartDetailPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailPrice"]),
                    CartDetailQuantity = dr["cartDetailQuantity"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailQuantity"]),
                    CartDetailDiscount = dr["cartDetailDiscount"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailDiscount"]),
                    CartDetailSubTotal = dr["cartDetailSubTotal"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailSubTotal"]),
                    CartDetailTAX = dr["cartDetailTAX"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailTAX"]),
                    CartDetailTotal = dr["cartDetailTotal"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailTotal"]),
                    CartDetailCurrencyId = dr["cartDetailCurrencyId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailCurrencyId"]),
                    CurrencyNameRef = dr["currencyNameRef"] == DBNull.Value ? string.Empty : dr["currencyNameRef"].ToString()!,
                    CartDetailCreatorId = dr["cartDetailCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailCreatorId"]),
                    CartDetailCreationDate = dr["cartDetailCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["cartDetailCreationDate"]),
                    CartDetailModificatorId = dr["cartDetailModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["cartDetailModificatorId"]),
                    CartDetailModificationDate = dr["cartDetailModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["cartDetailModificationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<CartDetail>> Filt_List_CartDetails(int filtro)
        {
            List<CartDetail> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_CartDetails]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    CartDetailId = dr["cartDetailId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailId"]),
                    CartDetailCartId = dr["cartDetailCartId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailCartId"]),
                    CartDetailProductVariableId = dr["cartDetailProductVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailProductVariableId"]),
                    ProductVariableValueRef = dr["productVariableValueRef"] == DBNull.Value ? string.Empty : dr["productVariableValueRef"].ToString()!,
                    CartDetailPrice = dr["cartDetailPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailPrice"]),
                    CartDetailQuantity = dr["cartDetailQuantity"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailQuantity"]),
                    CartDetailDiscount = dr["cartDetailDiscount"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailDiscount"]),
                    CartDetailSubTotal = dr["cartDetailSubTotal"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailSubTotal"]),
                    CartDetailTAX = dr["cartDetailTAX"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailTAX"]),
                    CartDetailTotal = dr["cartDetailTotal"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["cartDetailTotal"]),
                    CartDetailCurrencyId = dr["cartDetailCurrencyId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailCurrencyId"]),
                    CurrencyNameRef = dr["currencyNameRef"] == DBNull.Value ? string.Empty : dr["currencyNameRef"].ToString()!,
                    CartDetailCreatorId = dr["cartDetailCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["cartDetailCreatorId"]),
                    CartDetailCreationDate = dr["cartDetailCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["cartDetailCreationDate"]),
                    CartDetailModificatorId = dr["cartDetailModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["cartDetailModificatorId"]),
                    CartDetailModificationDate = dr["cartDetailModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["cartDetailModificationDate"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_CartDetails(CartDetail_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_CartDetails]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@cartDetailCartId", create.CartId));
                cmd.Parameters.Add(new SqlParameter("@cartDetailProductVariableId", create.ProductVariableId));
                cmd.Parameters.Add(new SqlParameter("@cartDetailPrice", create.Price));
                cmd.Parameters.Add(new SqlParameter("@cartDetailQuantity", create.Quantity));
                cmd.Parameters.Add(new SqlParameter("@cartDetailDiscount", create.Discount));
                cmd.Parameters.Add(new SqlParameter("@cartDetailCurrencyId", create.CurrencyId));
                cmd.Parameters.Add(new SqlParameter("@cartDetailCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@cartDetailCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_CartDetails(CartDetail_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_CartDetails]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@cartDetailId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@cartDetailQuantity", update.Quantity));
                cmd.Parameters.Add(new SqlParameter("@cartDetailDiscount", update.Discount));
                cmd.Parameters.Add(new SqlParameter("@cartDetailModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@cartDetailModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_CartDetails(CartDetail_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_CartDetails]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@cartDetailId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@cartDetailModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@cartDetailModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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
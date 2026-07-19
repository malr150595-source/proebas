using Application.DTOs;
using Application.Interface;
using Domain;
using Infraestructure.Db;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using static Application.DTOs.PaymentOrderDetail_DTOs;

namespace Infraestructure.Repository
{
    public class PaymentOrderDetails_Repository(DBConectionFactory connection) : IPaymentOrderDetailsRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<PaymentOrderDetail>> List_PaymentOrderDetails(int orderDetailOrderId)
        {
            List<PaymentOrderDetail> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_PaymentOrderDetails]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@orderDetailOrderId", orderDetailOrderId));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToOrderDetail(dr));
            }
            return lista;
        }

        public async Task<IEnumerable<PaymentOrderDetail>> Filt_List_PaymentOrderDetails(int filt)
        {
            List<PaymentOrderDetail> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_PaymentOrderDetails]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filt));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToOrderDetail(dr));
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_PaymentOrderDetails(PaymentOrderDetail_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_PaymentOrderDetails]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@orderDetailOrderId", create.OrderId));
                cmd.Parameters.Add(new SqlParameter("@orderDetailProductVariableId", create.ProductVariableId));
                cmd.Parameters.Add(new SqlParameter("@orderDetailPrice", create.Price));
                cmd.Parameters.Add(new SqlParameter("@orderDetailQuantity", create.Quantity));
                cmd.Parameters.Add(new SqlParameter("@orderDetailDiscount", (object)create.Discount ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@orderDetailCurrencyId", create.CurrencyId));
                cmd.Parameters.Add(new SqlParameter("@orderDetailCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@orderDetailCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_PaymentOrderDetails(PaymentOrderDetail_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_PaymentOrderDetails]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@orderDetailId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@orderDetailQuantity", update.Quantity));
                cmd.Parameters.Add(new SqlParameter("@orderDetailDiscount", (object)update.Discount ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@orderDetailModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@orderDetailModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Delete_PaymentOrderDetails(PaymentOrderDetail_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_PaymentOrderDetails]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@orderDetailId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@orderDetailModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@orderDetailModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

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

        private static PaymentOrderDetail MapToOrderDetail(SqlDataReader dr)
        {
            return new PaymentOrderDetail
            {
                OrderDetailId = dr["orderDetailId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderDetailId"]),
                OrderDetailOrderId = dr["orderDetailOrderId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderDetailOrderId"]),
                OrderDetailProductVariableId = dr["orderDetailProductVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderDetailProductVariableId"]),
                OrderDetailPrice = dr["orderDetailPrice"] == DBNull.Value ? 0.00m : Convert.ToDecimal(dr["orderDetailPrice"]),
                OrderDetailQuantity = dr["orderDetailQuantity"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderDetailQuantity"]),
                OrderDetailDiscount = dr["orderDetailDiscount"] == DBNull.Value ? 0.00m : Convert.ToDecimal(dr["orderDetailDiscount"]),
                OrderDetailSubTotal = dr["orderDetailSubTotal"] == DBNull.Value ? 0.00m : Convert.ToDecimal(dr["orderDetailSubTotal"]),
                OrderDetailTAX = dr["orderDetailTAX"] == DBNull.Value ? 0.00m : Convert.ToDecimal(dr["orderDetailTAX"]),
                OrderDetailTotal = dr["orderDetailTotal"] == DBNull.Value ? 0.00m : Convert.ToDecimal(dr["orderDetailTotal"]),
                OrderDetailCurrencyId = dr["orderDetailCurrencyId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderDetailCurrencyId"]),
                OrderDetailCreatorId = dr["orderDetailCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderDetailCreatorId"]),
                OrderDetailCreationDate = dr["orderDetailCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["orderDetailCreationDate"]),
                OrderDetailModificatorId = dr["orderDetailModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["orderDetailModificatorId"]),
                OrderDetailModificationDate = dr["orderDetailModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["orderDetailModificationDate"]),
                OrderDetailStatusId = dr["orderDetailStatusId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderDetailStatusId"])
            };
        }
    }
}
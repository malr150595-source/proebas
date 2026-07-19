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
    public class PaymentOrders_Repository(DBConectionFactory connection) : IPaymentOrdersRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<PaymentOrder>> List_PaymentOrders(int? orderUserId)
        {
            List<PaymentOrder> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_PaymentOrders]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@orderUserId", (object)orderUserId ?? DBNull.Value));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(MapToPaymentOrder(dr));
            }
            return lista;
        }

        public async Task<PaymentOrder?> Filt_List_PaymentOrders(int orderId)
        {
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_PaymentOrders]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", orderId));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            if (await dr.ReadAsync())
            {
                return MapToPaymentOrder(dr);
            }
            return null;
        }

        public async Task<MensajeDTOs> Insert_PaymentOrders(PaymentOrder_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_PaymentOrders]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@orderUserId", create.UserId));
                cmd.Parameters.Add(new SqlParameter("@orderDeliveryAddress", create.DeliveryAddress));
                cmd.Parameters.Add(new SqlParameter("@orderPaymentMethodId", create.PaymentMethodId));
                cmd.Parameters.Add(new SqlParameter("@orderSubtotal", create.Subtotal));
                cmd.Parameters.Add(new SqlParameter("@orderDiscount", (object)create.Discount ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@orderShipping", (object)create.Shipping ?? DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@orderCurrencyId", create.CurrencyId));
                cmd.Parameters.Add(new SqlParameter("@orderCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@orderStatusId", create.StatusId));
                cmd.Parameters.Add(new SqlParameter("@orderCreationDate", (object)create.CreationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_PaymentOrders(PaymentOrder_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_PaymentOrders]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@orderId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@orderDeliveryAddress", update.DeliveryAddress));
                cmd.Parameters.Add(new SqlParameter("@orderShipping", update.Shipping));
                cmd.Parameters.Add(new SqlParameter("@orderStatusId", update.StatusId));
                cmd.Parameters.Add(new SqlParameter("@orderModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@orderModificationDate", (object)update.ModificationDate ?? DBNull.Value));

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

        public async Task<MensajeDTOs> Update_OrderStatus(PaymentOrder_UpdateStatus_DTO updateStatus)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_OrderStatus]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@orderId", updateStatus.Id));
                cmd.Parameters.Add(new SqlParameter("@orderStatusId", updateStatus.StatusId));
                cmd.Parameters.Add(new SqlParameter("@orderModificatorId", updateStatus.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@orderModificationDate", (object)updateStatus.ModificationDate ?? DBNull.Value));

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

        private static PaymentOrder MapToPaymentOrder(SqlDataReader dr)
        {
            return new PaymentOrder
            {
                OrderId = dr["orderId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderId"]),
                OrderUserId = dr["orderUserId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderUserId"]),
                OrderDeliveryAddress = dr["orderDeliveryAddress"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderDeliveryAddress"]),
                OrderPaymentMethodId = dr["orderPaymentMethodId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderPaymentMethodId"]),
                OrderSubtotal = dr["orderSubtotal"] == DBNull.Value ? 0x00000000 : Convert.ToDecimal(dr["orderSubtotal"]),
                OrderDiscount = dr["orderDiscount"] == DBNull.Value ? 0x00000000 : Convert.ToDecimal(dr["orderDiscount"]),
                OrderShipping = dr["orderShipping"] == DBNull.Value ? 0x00000000 : Convert.ToDecimal(dr["orderShipping"]),
                OrderTAX = dr["orderTAX"] == DBNull.Value ? 0x00000000 : Convert.ToDecimal(dr["orderTAX"]),
                OrderTotal = dr["orderTotal"] == DBNull.Value ? 0x00000000 : Convert.ToDecimal(dr["orderTotal"]),
                OrderCurrencyId = dr["orderCurrencyId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderCurrencyId"]),
                OrderCreatorId = dr["orderCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderCreatorId"]),
                OrderCreationDate = dr["orderCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["orderCreationDate"]),
                OrderModificatorId = dr["orderModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["orderModificatorId"]),
                OrderModificationDate = dr["orderModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["orderModificationDate"]),
                OrderStatusId = dr["orderStatusId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["orderStatusId"])
            };
        }
    }
}
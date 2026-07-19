using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class PaymentOrders_Service(IPaymentOrdersRepository repository)
    {
        private readonly IPaymentOrdersRepository _repository = repository;

        public async Task<IEnumerable<PaymentOrder>> List_PaymentOrders(int? orderUserId)
        {
            return await _repository.List_PaymentOrders(orderUserId);
        }

        public async Task<PaymentOrder?> Filt_List_PaymentOrders(int orderId)
        {
            return await _repository.Filt_List_PaymentOrders(orderId);
        }

        public async Task<MensajeDTOs> Insert_PaymentOrders(PaymentOrder_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_PaymentOrders(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_PaymentOrders(PaymentOrder_Update_DTO update)
        {
            try
            {
                return await _repository.Update_PaymentOrders(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_OrderStatus(PaymentOrder_UpdateStatus_DTO updateStatus)
        {
            try
            {
                return await _repository.Update_OrderStatus(updateStatus);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
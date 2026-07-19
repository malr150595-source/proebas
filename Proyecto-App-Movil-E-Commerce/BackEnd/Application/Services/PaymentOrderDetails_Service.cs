using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.PaymentOrderDetail_DTOs;

namespace Application.Services
{
    public class PaymentOrderDetails_Service(IPaymentOrderDetailsRepository repository)
    {
        private readonly IPaymentOrderDetailsRepository _repository = repository;

        public async Task<IEnumerable<PaymentOrderDetail>> List_PaymentOrderDetails(int orderDetailOrderId)
        {
            return await _repository.List_PaymentOrderDetails(orderDetailOrderId);
        }

        public async Task<IEnumerable<PaymentOrderDetail>> Filt_List_PaymentOrderDetails(int filt)
        {
            return await _repository.Filt_List_PaymentOrderDetails(filt);
        }

        public async Task<MensajeDTOs> Insert_PaymentOrderDetails(PaymentOrderDetail_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_PaymentOrderDetails(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_PaymentOrderDetails(PaymentOrderDetail_Update_DTO update)
        {
            try
            {
                return await _repository.Update_PaymentOrderDetails(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_PaymentOrderDetails(PaymentOrderDetail_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_PaymentOrderDetails(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class PaymentMethodTypes_Service(IPaymentMethodTypesRepository repository)
    {
        private readonly IPaymentMethodTypesRepository _repository = repository;

        public async Task<IEnumerable<PaymentMethodType>> List_PaymentMethodTypes()
        {
            return await _repository.List_PaymentMethodTypes();
        }

        public async Task<IEnumerable<PaymentMethodType>> Filt_List_PaymentMethodTypes(string? filtro)
        {
            try
            {
                return await _repository.Filt_List_PaymentMethodTypes(filtro ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_PaymentMethodTypes(PaymentMethodType_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_PaymentMethodTypes(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_PaymentMethodTypes(PaymentMethodType_Update_DTO update)
        {
            try
            {
                return await _repository.Update_PaymentMethodTypes(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_PaymentMethodTypes(PaymentMethodType_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_PaymentMethodTypes(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
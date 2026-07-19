using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IPaymentMethodTypesRepository
    {
        Task<IEnumerable<PaymentMethodType>> List_PaymentMethodTypes();
        Task<IEnumerable<PaymentMethodType>> Filt_List_PaymentMethodTypes(string filtro);
        Task<MensajeDTOs> Insert_PaymentMethodTypes(PaymentMethodType_Insert_DTO create);
        Task<MensajeDTOs> Update_PaymentMethodTypes(PaymentMethodType_Update_DTO update);
        Task<MensajeDTOs> Delete_PaymentMethodTypes(PaymentMethodType_Delete_DTO delete);
    }
}

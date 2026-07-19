using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;
using static Application.DTOs.PaymentOrderDetail_DTOs;

namespace Application.Interface
{
    public interface IPaymentOrderDetailsRepository
    {
        Task<IEnumerable<PaymentOrderDetail>> List_PaymentOrderDetails(int orderDetailOrderId);
        Task<IEnumerable<PaymentOrderDetail>> Filt_List_PaymentOrderDetails(int filt);
        Task<MensajeDTOs> Insert_PaymentOrderDetails(PaymentOrderDetail_Insert_DTO create);
        Task<MensajeDTOs> Update_PaymentOrderDetails(PaymentOrderDetail_Update_DTO update);
        Task<MensajeDTOs> Delete_PaymentOrderDetails(PaymentOrderDetail_Delete_DTO delete);
    }
}

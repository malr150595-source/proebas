using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IPaymentOrdersRepository
    {
        Task<IEnumerable<PaymentOrder>> List_PaymentOrders(int? orderUserId);
        Task<PaymentOrder?> Filt_List_PaymentOrders(int orderId);
        Task<MensajeDTOs> Insert_PaymentOrders(PaymentOrder_Insert_DTO create);
        Task<MensajeDTOs> Update_PaymentOrders(PaymentOrder_Update_DTO update);
        Task<MensajeDTOs> Update_OrderStatus(PaymentOrder_UpdateStatus_DTO updateStatus);
    }
}

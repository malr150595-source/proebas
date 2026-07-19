using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class PaymentOrder_Insert_DTO
    {
        public int UserId { get; set; }
        public int DeliveryAddress { get; set; }
        public int PaymentMethodId { get; set; }
        public decimal Subtotal { get; set; }
        public decimal? Discount { get; set; }
        public decimal? Shipping { get; set; }
        public int CurrencyId { get; set; }
        public int CreatorId { get; set; }
        public int StatusId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class PaymentOrder_Update_DTO
    {
        public int Id { get; set; }
        public int DeliveryAddress { get; set; }
        public decimal Shipping { get; set; }
        public int StatusId { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class PaymentOrder_UpdateStatus_DTO
    {
        public int Id { get; set; }
        public int StatusId { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class PaymentOrderDetail_DTOs
    {
        public class PaymentOrderDetail_Insert_DTO
        {
            public int OrderId { get; set; }
            public int ProductVariableId { get; set; }
            public decimal Price { get; set; }
            public int Quantity { get; set; }
            public decimal? Discount { get; set; }
            public int CurrencyId { get; set; }
            public int CreatorId { get; set; }
            public DateTime? CreationDate { get; set; }
        }

        public class PaymentOrderDetail_Update_DTO
        {
            public int Id { get; set; }
            public int Quantity { get; set; }
            public decimal? Discount { get; set; }
            public int ModificatorId { get; set; }
            public DateTime? ModificationDate { get; set; }
        }

        public class PaymentOrderDetail_Delete_DTO
        {
            public int Id { get; set; }
            public int ModificatorId { get; set; }
            public DateTime? ModificationDate { get; set; }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class CartDetail
    {
        public int CartDetailId { get; set; }
        public int CartDetailCartId { get; set; }
        public int CartDetailProductVariableId { get; set; }
        public string ProductVariableValueRef { get; set; } = string.Empty; // Campo del JOIN
        public decimal CartDetailPrice { get; set; }
        public int CartDetailQuantity { get; set; }
        public decimal CartDetailDiscount { get; set; }
        public decimal CartDetailSubTotal { get; set; }
        public decimal CartDetailTAX { get; set; }
        public decimal CartDetailTotal { get; set; }
        public int CartDetailCurrencyId { get; set; }
        public string CurrencyNameRef { get; set; } = string.Empty;       // Campo del JOIN
        public int CartDetailCreatorId { get; set; }
        public DateTime CartDetailCreationDate { get; set; }
        public int? CartDetailModificatorId { get; set; }
        public DateTime? CartDetailModificationDate { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class PaymentOrder
    {
        public int OrderId { get; set; }
        public int OrderUserId { get; set; }
        public int OrderDeliveryAddress { get; set; }
        public int OrderPaymentMethodId { get; set; }
        public decimal OrderSubtotal { get; set; }
        public decimal OrderDiscount { get; set; }
        public decimal OrderShipping { get; set; }
        public decimal OrderTAX { get; set; }
        public decimal OrderTotal { get; set; }
        public int OrderCurrencyId { get; set; }
        public int OrderCreatorId { get; set; }
        public DateTime OrderCreationDate { get; set; }
        public int? OrderModificatorId { get; set; }
        public DateTime? OrderModificationDate { get; set; }
        public int OrderStatusId { get; set; }
    }
}

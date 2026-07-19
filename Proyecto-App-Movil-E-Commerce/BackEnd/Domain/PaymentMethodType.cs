using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class PaymentMethodType
    {
        public int PaymentMethodTypeId { get; set; }
        public string PaymentMethodTypeName { get; set; } = string.Empty;
        public string PaymentMethodTypeDescription { get; set; } = string.Empty;
        public int PaymentMethodTypeCreatorId { get; set; }
        public string UserCreatorNameRef { get; set; } = string.Empty; // Campo del JOIN
        public DateTime PaymentMethodTypeCreationDate { get; set; }
        public int? PaymentMethodTypeModificatorId { get; set; }
        public DateTime? PaymentMethodTypeModificationDate { get; set; }
    }
}

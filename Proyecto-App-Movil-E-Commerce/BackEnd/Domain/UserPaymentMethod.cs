using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class UserPaymentMethod
    {
        public int UserPaymentMethodId { get; set; }
        public int UserPaymentMethodUserId { get; set; }
        public int UserPaymentMethodPaymentMethodTypeId { get; set; }
        public string PaymentMethodTypeName { get; set; } = string.Empty;
        public string UserPaymentMethodCardNumberMasked { get; set; } = string.Empty;
        public string UserPaymentMethodCardNumberRaw { get; set; } = string.Empty;
        public string UserPaymentMethodExpirationDate { get; set; } = string.Empty;
        public string UserPaymentMethodCVV { get; set; } = string.Empty;
        public string UserPaymentMethodCardHolderName { get; set; } = string.Empty;
        public int UserPaymentMethodCreatorId { get; set; }
        public DateTime UserPaymentMethodCreationDate { get; set; }
        public int? UserPaymentMethodModificatorId { get; set; }
        public DateTime? UserPaymentMethodModificationDate { get; set; }
    }
}

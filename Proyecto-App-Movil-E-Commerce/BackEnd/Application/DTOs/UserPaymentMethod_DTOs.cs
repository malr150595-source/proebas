using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class UserPaymentMethod_Insert_DTO
    {
        public int UserId { get; set; }
        public int PaymentMethodTypeId { get; set; }
        public string CardNumberRaw { get; set; } = string.Empty;
        public string ExpirationDateRaw { get; set; } = string.Empty;
        public string CVVRaw { get; set; } = string.Empty;
        public string CardHolderName { get; set; } = string.Empty;
        public int CreatorId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class UserPaymentMethod_Update_DTO
    {
        public int Id { get; set; }
        public int PaymentMethodTypeId { get; set; }
        public string CardNumberRaw { get; set; } = string.Empty;
        public string ExpirationDateRaw { get; set; } = string.Empty;
        public string CVVRaw { get; set; } = string.Empty;
        public string CardHolderName { get; set; } = string.Empty;
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class UserPaymentMethod_Delete_DTO
    {
        public int Id { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

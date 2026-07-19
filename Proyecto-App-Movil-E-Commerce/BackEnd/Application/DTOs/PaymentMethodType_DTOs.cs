using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class PaymentMethodType_Insert_DTO
    {
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int CreatorId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class PaymentMethodType_Update_DTO
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class PaymentMethodType_Delete_DTO
    {
        public int Id { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

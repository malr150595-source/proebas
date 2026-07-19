using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class ProductVariable_Insert_DTO
    {
        public int ProductId { get; set; }
        public string Value { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int CurrencyId { get; set; }
        public int CreatorId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class ProductVariable_Update_DTO
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public string Value { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int CurrencyId { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class ProductVariable_Delete_DTO
    {
        public int Id { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

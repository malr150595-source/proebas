using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class ProductImage_Insert_DTO
    {
        public int ProductId { get; set; }
        public string URL { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public bool IsPrincipal { get; set; }
        public int CreatorId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class ProductImage_Update_DTO
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public string URL { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public bool IsPrincipal { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class ProductImage_Delete_DTO
    {
        public int Id { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

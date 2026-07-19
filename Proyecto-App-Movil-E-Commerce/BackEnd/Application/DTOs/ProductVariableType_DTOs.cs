using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class ProductVariableType_DTOs
    {
        public class ProductVariableType_Insert_DTO
        {
            public string Name { get; set; } = string.Empty;
            public string Description { get; set; } = string.Empty;
            public int CreatorId { get; set; }
            public DateTime? CreationDate { get; set; }
        }

        public class ProductVariableType_Update_DTO
        {
            public int Id { get; set; }
            public string Name { get; set; } = string.Empty;
            public string Description { get; set; } = string.Empty;
            public int ModificatorId { get; set; }
            public DateTime? ModificationDate { get; set; }
        }

        public class ProductVariableType_Delete_DTO
        {
            public int Id { get; set; }
            public int ModificatorId { get; set; }
            public DateTime? ModificationDate { get; set; }
        }
    }
}

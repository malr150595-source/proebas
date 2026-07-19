using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class AttributeProductVariable_Insert_DTO
    {
        public int ProductVariableId { get; set; }
        public int AttributeProductId { get; set; }
        public string Value { get; set; } = string.Empty;
        public int CreatorId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class AttributeProductVariable_Update_DTO
    {
        public int Id { get; set; }
        public int ProductVariableId { get; set; }
        public int AttributeProductId { get; set; }
        public string Value { get; set; } = string.Empty;
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class AttributeProductVariable_Delete_DTO
    {
        public int Id { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class ProductVariableType
    {
        public int ProductVariableTypeId { get; set; }
        public string ProductVariableTypeName { get; set; } = string.Empty;
        public string ProductVariableTypeDescription { get; set; } = string.Empty;
        public int ProductVariableTypeCreatorId { get; set; }
        public DateTime ProductVariableTypeCreationDate { get; set; }
        public int? ProductVariableTypeModificatorId { get; set; }
        public DateTime? ProductVariableTypeModificationDate { get; set; }
    }
}

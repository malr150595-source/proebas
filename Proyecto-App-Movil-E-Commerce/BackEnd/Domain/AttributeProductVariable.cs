using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class AttributeProductVariable
    {
        public int AttributeProductVariableId { get; set; }
        public int AttributeProductVariableProductVariableId { get; set; }
        public string ProductVariableValueRef { get; set; } = string.Empty; // Campo del JOIN
        public int AttributeProductVariableAttributeProductId { get; set; }
        public string AttributeProductName { get; set; } = string.Empty;   // Campo del JOIN
        public string AttributeProductVariableValue { get; set; } = string.Empty;
        public int AttributeProductVariableCreatorId { get; set; }
        public DateTime AttributeProductVariableCreationDate { get; set; }
        public int? AttributeProductVariableModificatorId { get; set; }
        public DateTime? AttributeProductVariableModificationDate { get; set; }
    }
}

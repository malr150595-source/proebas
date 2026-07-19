using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class ProductVariable
    {
        public int ProductVariableId { get; set; }
        public int ProductVariableProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public string ProductVariableValue { get; set; } = string.Empty;
        public decimal ProductVariablePrice { get; set; }
        public int ProductVariableCurrencyId { get; set; }
        public string CurrencyName { get; set; } = string.Empty;
        public int ProductVariableCreatorId { get; set; }
        public DateTime ProductVariableCreationDate { get; set; }
    }
}

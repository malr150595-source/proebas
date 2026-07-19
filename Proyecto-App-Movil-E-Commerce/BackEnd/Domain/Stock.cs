using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class Stock
    {
        public int StockId { get; set; }
        public int StockProductVariableId { get; set; }
        public string ProductVariableValueRef { get; set; } = string.Empty; // Campo del JOIN
        public int StockQuantity { get; set; }
        public DateTime StockFactoryDate { get; set; }
        public DateTime StockExpirationDate { get; set; }
        public int StockCreatorId { get; set; }
        public DateTime StockCreationDate { get; set; }
        public int? StockModificatorId { get; set; }
        public DateTime? StockModificationDate { get; set; }
    }
}

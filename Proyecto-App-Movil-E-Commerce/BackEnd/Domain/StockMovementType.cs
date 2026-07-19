using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class StockMovementType
    {
        public int StockMovementTypeId { get; set; }
        public string StockMovementTypeName { get; set; } = string.Empty;
        public string StockMovementTypeDescription { get; set; } = string.Empty;
        public int StockMovementTypeCreatorId { get; set; }
        public DateTime StockMovementTypeCreationDate { get; set; }
        public int? StockMovementTypeModificatorId { get; set; }
        public DateTime? StockMovementTypeModificationDate { get; set; }
    }
}

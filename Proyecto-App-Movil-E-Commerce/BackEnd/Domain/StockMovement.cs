using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class StockMovement
    {
        public int StockMovementId { get; set; }
        public int StockMovementType { get; set; }
        public int? StockMovementOrderId { get; set; }
        public string? StockMovementReference { get; set; }
        public DateTime StockMovementDate { get; set; }
        public int StockMovementCreatorId { get; set; }
        public DateTime StockMovementCreationDate { get; set; }
        public int? StockMovementModifierId { get; set; }
        public DateTime? StockMovementModificationDate { get; set; }
        public int StockMovementStatusId { get; set; }
    }
}

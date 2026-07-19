using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class StockMovementDetail
    {
        public int StockMovementDetailId { get; set; }
        public int StockMovementDetailMovementId { get; set; }
        public int? StockMovementDetailOrderDetailId { get; set; }
        public int? StockMovementDetailStockId { get; set; }
        public int StockMovementDetailQuantity { get; set; }
        public DateOnly? StockMovementDetailFactoryDate { get; set; }
        public DateOnly? StockMovementDetailExpirationDate { get; set; }
        public int StockMovementDetailCreatorId { get; set; }
        public DateTime StockMovementDetailCreationDate { get; set; }
        public int? StockMovementDetailModifierId { get; set; }
        public DateTime? StockMovementDetailModificationDate { get; set; }
        public bool StockMovementDetailStatusId { get; set; }
    }
}

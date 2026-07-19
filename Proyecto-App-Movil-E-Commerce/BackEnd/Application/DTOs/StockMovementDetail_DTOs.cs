using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class StockMovementDetail_Insert_DTO
    {
        public int MovementId { get; set; }
        public int? OrderDetailId { get; set; }
        public int? StockId { get; set; }
        public int Quantity { get; set; }
        public DateOnly? FactoryDate { get; set; }
        public DateOnly? ExpirationDate { get; set; }
        public int CreatorId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class StockMovementDetail_Update_DTO
    {
        public int Id { get; set; }
        public int Quantity { get; set; }
        public DateOnly? FactoryDate { get; set; }
        public DateOnly? ExpirationDate { get; set; }
        public int ModifierId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class StockMovementDetail_Delete_DTO
    {
        public int Id { get; set; }
        public int ModifierId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

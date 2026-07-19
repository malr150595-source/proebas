using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class StockMovement_Insert_DTO
    {
        public int Type { get; set; }
        public int? OrderId { get; set; }
        public string? Reference { get; set; }
        public DateTime? Date { get; set; }
        public int CreatorId { get; set; }
        public int StatusId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class StockMovement_Update_DTO
    {
        public int Id { get; set; }
        public int Type { get; set; }
        public int? OrderId { get; set; }
        public string? Reference { get; set; }
        public DateTime Date { get; set; }
        public int StatusId { get; set; }
        public int ModifierId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class StockMovement_Delete_DTO
    {
        public int Id { get; set; }
        public int ModifierId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

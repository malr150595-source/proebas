using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class Stock_Insert_DTO
    {
        public int ProductVariableId { get; set; }
        public int Quantity { get; set; }
        public DateTime FactoryDate { get; set; }
        public DateTime ExpirationDate { get; set; }
        public int CreatorId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class Stock_Update_DTO
    {
        public int Id { get; set; }
        public int ProductVariableId { get; set; }
        public int Quantity { get; set; }
        public DateTime FactoryDate { get; set; }
        public DateTime ExpirationDate { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class Stock_Delete_DTO
    {
        public int Id { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class Cart_Insert_DTO
    {
        public int UserId { get; set; }
        public int CreatorId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class Cart_Update_DTO
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }

    public class Cart_Delete_DTO
    {
        public int Id { get; set; }
        public int ModificatorId { get; set; }
        public DateTime? ModificationDate { get; set; }
    }
}

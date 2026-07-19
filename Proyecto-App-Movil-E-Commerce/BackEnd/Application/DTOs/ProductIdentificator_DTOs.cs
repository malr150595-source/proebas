using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class ProductIdentificator_DTOs
    {
        public class ProductIdentificator_Insert_DTO
        {
            public int CategoryId { get; set; }
            public int SubCategoryId { get; set; }
            public int SegmentId { get; set; }
            public int CreatorId { get; set; }
            public DateTime? CreationDate { get; set; }
        }

        public class ProductIdentificator_Update_DTO
        {
            public int Id { get; set; }
            public int CategoryId { get; set; }
            public int SubCategoryId { get; set; }
            public int SegmentId { get; set; }
            public int ModificatorId { get; set; }
            public DateTime? ModificationDate { get; set; }
        }

        public class ProductIdentificator_Delete_DTO
        {
            public int Id { get; set; }
            public int ModificatorId { get; set; }
            public DateTime? ModificationDate { get; set; }
        }
    }
}

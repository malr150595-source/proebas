using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class Tbl_Status
    {
        public int StatusId { get; set; }
        public string? StatusName { get; set; }
        public int StatusCreatorId { get; set; }
        public DateTime? StatusCreationDate { get; set; }
        public int StatusModificatorId { get; set; }
        public DateTime? StatusModificationDate { get; set; }
    }

    public class Tbl_Create_Status
    {
        public string? StatusName { get; set; }
        public int StatusCreatorId { get; set; }
        public DateTime? StatusCreationDate { get; set; }
    }

    public class Tbl_Update_Status
    {
        public int StatusId { get; set; }
        public string? StatusName { get; set; }
        public int StatusModificatorId { get; set; }
        public DateTime? StatusModificationDate { get; set; }
    }

    public class Tbl_Delete_Status
    {
        public int StatusId { get; set; }
        public int StatusModificatorId { get; set; }
        public DateTime? StatusModificationDate { get; set; }
    }
}

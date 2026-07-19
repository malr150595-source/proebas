using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class Tbl_Status
    {
        public int StatusId { get; set; }
        public string? StatusName { get; set; }
        public int StatusCreatorId { get; set; }
        public DateTime StatusCreationDate { get; set; }
        public int StatusModificatorId { get; set; }
        public DateTime StatusModificationDate { get; set; }
        public int StatusStatusId { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class Cart
    {
        public int CartId { get; set; }
        public int CartUserId { get; set; }
        public string UserFullNameRef { get; set; } = string.Empty; // Campo del JOIN
        public int CartCreatorId { get; set; }
        public DateTime CartCreationDate { get; set; }
        public int? CartModificatorId { get; set; }
        public DateTime? CartModificationDate { get; set; }
    }
}

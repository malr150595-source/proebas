using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class Role
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; } = string.Empty;
        public string RoleDescription { get; set; } = string.Empty;
        public int RoleCreatorId { get; set; }
        public DateTime RoleCreationDate { get; set; }
        public int? RoleModificatorId { get; set; }
        public DateTime? RoleModificationDate { get; set; }
    }
}

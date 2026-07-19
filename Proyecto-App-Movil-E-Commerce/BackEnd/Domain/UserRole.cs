using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class UserRole
    {
        public int UserRoleId { get; set; }
        public int UserRoleUserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string UserEmail { get; set; } = string.Empty;
        public int UserRoleRoleId { get; set; }
        public string RoleName { get; set; } = string.Empty;
        public int UserRoleCreatorId { get; set; }
        public DateTime UserRoleCreationDate { get; set; }
    }
}

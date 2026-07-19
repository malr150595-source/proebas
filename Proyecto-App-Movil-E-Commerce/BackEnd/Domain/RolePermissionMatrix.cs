using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class RolePermissionMatrix
    {
        public int RolePermissionId { get; set; }
        public int RolePermissionRoleId { get; set; }
        public string RoleName { get; set; } = string.Empty;
        public int RolePermissionPermissionId { get; set; }
        public string PermissionName { get; set; } = string.Empty;
        public string PermissionModule { get; set; } = string.Empty;
        public int RolePermissionCreatorId { get; set; }
        public DateTime RolePermissionCreationDate { get; set; }
    }
}

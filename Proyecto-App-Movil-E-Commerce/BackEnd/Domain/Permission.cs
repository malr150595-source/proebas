using System;
using System.Collections.Generic;
using System.Text;

namespace Domain
{
    public class Permission
    {
        public int PermissionId { get; set; }
        public string PermissionName { get; set; } = string.Empty;
        public string PermissionDescription { get; set; } = string.Empty;
        public string PermissionModule { get; set; } = string.Empty;
        public int PermissionCreatorId { get; set; }
        public DateTime PermissionCreationDate { get; set; }
    }

    public class RolePermission
    {
        public int RolePermissionId { get; set; }
        public int RolePermissionRoleId { get; set; }
        public string RoleName { get; set; } = string.Empty;
        public int RolePermissionPermissionId { get; set; }
        public string PermissionName { get; set; } = string.Empty;
        public string PermissionDescription { get; set; } = string.Empty;
        public string PermissionModule { get; set; } = string.Empty;
    }
}

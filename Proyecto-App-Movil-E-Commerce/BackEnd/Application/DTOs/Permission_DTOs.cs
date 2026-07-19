using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class Permission_Insert_DTO
    {
        public string? PermissionName { get; set; }
        public string? PermissionDescription { get; set; }
        public string? PermissionModule { get; set; }
        public int? PermissionCreatorId { get; set; }
        public DateTime? PermissionCreationDate { get; set; }
    }

    public class RolePermission_Assign_DTO
    {
        public int? RoleId { get; set; }
        public int? PermissionId { get; set; }
        public int? CreatorId { get; set; }
        public DateTime? CreationDate { get; set; }
    }

    public class RolePermission_Revoke_DTO
    {
        public int? RoleId { get; set; }
        public int? PermissionId { get; set; }
    }
}

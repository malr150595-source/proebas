using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class RolePermissionMatrix_Insert_DTO
    {
        public int? RolePermissionRoleId { get; set; }
        public int? RolePermissionPermissionId { get; set; }
        public int? RolePermissionCreatorId { get; set; }
        public DateTime? RolePermissionCreationDate { get; set; }
    }

    public class RolePermissionMatrix_Update_DTO
    {
        public int RolePermissionId { get; set; }
        public int? RolePermissionRoleId { get; set; }
        public int? RolePermissionPermissionId { get; set; }
        public int? RolePermissionCreatorId { get; set; }
        public DateTime? RolePermissionCreationDate { get; set; }
    }

    public class RolePermissionMatrix_Delete_DTO
    {
        public int RolePermissionId { get; set; }
        public int? RolePermissionCreatorId { get; set; }
        public DateTime? RolePermissionCreationDate { get; set; }
    }
}

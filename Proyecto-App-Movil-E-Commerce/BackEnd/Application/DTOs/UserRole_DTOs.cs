using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class UserRole_Insert_DTO
    {
        public int? UserRoleUserId { get; set; }
        public int? UserRoleRoleId { get; set; }
        public int? UserRoleCreatorId { get; set; }
        public DateTime? UserRoleCreationDate { get; set; }
    }

    public class UserRole_Update_DTO
    {
        public int UserRoleId { get; set; }
        public int? UserRoleUserId { get; set; }
        public int? UserRoleRoleId { get; set; }
        public int? UserRoleCreatorId { get; set; }
        public DateTime? UserRoleCreationDate { get; set; }
    }

    public class UserRole_Delete_DTO
    {
        public int UserRoleId { get; set; }
        public int? UserRoleCreatorId { get; set; }
        public DateTime? UserRoleCreationDate { get; set; }
    }
}

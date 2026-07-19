using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class Role_Insert_DTO
    {
        public string? RoleName { get; set; }
        public string? RoleDescription { get; set; }
        public int? RoleCreatorId { get; set; }
        public DateTime? RoleCreationDate { get; set; }
    }

    public class Role_Update_DTO
    {
        public int RoleId { get; set; }
        public string? RoleName { get; set; }
        public string? RoleDescription { get; set; }
        public int? RoleModificatorId { get; set; }
        public DateTime? RoleModificationDate { get; set; }
    }

    public class Role_Delete_DTO
    {
        public int RoleId { get; set; }
        public int? RoleModificatorId { get; set; }
        public DateTime? RoleModificationDate { get; set; }
    }
}

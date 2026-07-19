using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class SuperAdminRoleAssignmentDto
    {
        public int TargetUserId { get; set; }
        public int TargetRoleId { get; set; }
    }
}

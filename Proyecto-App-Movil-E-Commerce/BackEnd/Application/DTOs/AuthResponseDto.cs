using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs
{
    public class AuthResponseDto
    {
        public int UserId { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string UserRole { get; set; } = string.Empty;
        public string Token { get; set; } = string.Empty;
    }
}

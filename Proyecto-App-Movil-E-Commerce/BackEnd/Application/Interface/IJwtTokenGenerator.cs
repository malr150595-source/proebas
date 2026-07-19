using Application.DTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IJwtTokenGenerator
    {
        string GenerateToken(AuthResponseDto user);
    }
}

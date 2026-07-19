using Application.DTOs;
using Application.Interface;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Services
{
    public class JwtTokenGenerator_service(ITbl_Users usersRepository, IJwtTokenGenerator jwtTokenGenerator)
    {
        private readonly ITbl_Users _usersRepository = usersRepository;
        private readonly IJwtTokenGenerator _jwtTokenGenerator = jwtTokenGenerator;

        public async Task<(MensajeDTOs Control, AuthResponseDto? Data)> LoginAsync(Login_DTOs loginDto)
        {
            var (control, userData) = await _usersRepository.ValidateLoginAsync(loginDto);

            if (control.Resultado != 200 || userData == null)
            {
                return (control, null);
            }

            // GENERACIÓN REAL DEL TOKEN JWT CRIPTOGRÁFICO
            userData.Token = _jwtTokenGenerator.GenerateToken(userData);

            return (control, userData);
        }
    }
}

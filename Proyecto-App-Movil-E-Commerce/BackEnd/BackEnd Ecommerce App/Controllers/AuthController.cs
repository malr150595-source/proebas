using Application.DTOs;
using Application.Services;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace BackEnd_Ecommerce_App.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase // Cambiado de Controller a ControllerBase
    {
        private readonly JwtTokenGenerator_service _authService;

        public AuthController(JwtTokenGenerator_service authService)
        {
            _authService = authService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] Login_DTOs loginDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var (control, data) = await _authService.LoginAsync(loginDto);

            // Evaluamos el resultado que viene directamente desde el Stored Procedure
            if (control.Resultado == 200 && data != null)
            {
                // ▄ MODIFICADO: Devolvemos únicamente un objeto anónimo con la propiedad token
                return Ok(new { token = data.Token });
            }

            // Si hay un error (ej. 400 o 401), seguimos enviando el control con el mensaje de error
            return StatusCode(control.Resultado, new { control });
        }
    }
}
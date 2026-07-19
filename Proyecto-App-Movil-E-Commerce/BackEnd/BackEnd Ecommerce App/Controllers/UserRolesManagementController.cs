using Application.DTOs;
using Application.Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Security.Claims;
using System.Threading.Tasks;

namespace BackEnd_Ecommerce_App.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize] // Protegido por Token JWT: solo usuarios autenticados pueden acceder
    public class UserRolesManagementController : ControllerBase
    {
        private readonly IUserRolesRepository _repository;

        // Inyección de dependencias de tu repositorio nativo
        public UserRolesManagementController(IUserRolesRepository repository)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
        }

        [HttpPost("assign-role-global")]
        public async Task<IActionResult> AssignRoleGlobal([FromBody] SuperAdminRoleAssignmentDto dto)
        {
            // 1. Validar que el DTO sea correcto
            if (dto == null || dto.TargetUserId <= 0 || dto.TargetRoleId <= 0)
            {
                return BadRequest(new { mensaje = "Los identificadores de usuario y rol son obligatorios y deben ser mayores a 0." });
            }

            try
            {
                // 2. Extraer el NameIdentifier (ID del SuperAdmin autenticado) desde los Claims del Token JWT
                var adminIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

                if (string.IsNullOrEmpty(adminIdClaim) || !int.TryParse(adminIdClaim, out int adminUserId))
                {
                    return Unauthorized(new { mensaje = "Token inválido, vencido o no contiene el ID de usuario." });
                }

                // 3. Ejecutar el Stored Procedure asíncrono a través de tu repositorio de infraestructura
                MensajeDTOs respuesta = await _repository.AssignRoleBySuperAdminAsync(dto.TargetUserId, dto.TargetRoleId, adminUserId);

                // 4. Evaluar la respuesta basándonos en tu propiedad nativa .Resultado y .Messaje
                return respuesta.Resultado switch
                {
                    200 => Ok(new { mensaje = respuesta.Messaje }),       // Operación exitosa o actualización
                    201 => StatusCode(201, new { mensaje = respuesta.Messaje }), // Creado con éxito
                    400 => BadRequest(new { mensaje = respuesta.Messaje }),   // Error de validación en BD o negocio
                    401 => StatusCode(401, new { mensaje = respuesta.Messaje }), // No autorizado (ej. si el SP valida que no eres SuperAdmin)
                    404 => NotFound(new { mensaje = respuesta.Messaje }),     // No se encontró el usuario o el rol
                    _ => StatusCode(500, new { mensaje = $"Error interno del servidor en BD: {respuesta.Messaje}" })
                };
            }
            catch (Exception ex)
            {
                // Control de excepciones a nivel de controlador
                return StatusCode(500, new { mensaje = $"Error crítico en el servidor: {ex.Message}" });
            }
        }
    }
}
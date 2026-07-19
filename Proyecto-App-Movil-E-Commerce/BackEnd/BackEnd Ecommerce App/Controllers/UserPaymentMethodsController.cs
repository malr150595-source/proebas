using Application.DTOs;
using Application.Services;
using Domain;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserPaymentMethodsController(UserPaymentMethods_Service service) : ControllerBase
    {
        private readonly UserPaymentMethods_Service _service = service;

        [HttpGet("List/{userId:int}")]
        public async Task<ActionResult<IEnumerable<UserPaymentMethod>>> ListUserPaymentMethods(int userId)
        {
            var data = await _service.List_UserPaymentMethods(userId);
            return Ok(data);
        }

        [HttpGet("Filter/{id:int}")]
        public async Task<ActionResult<UserPaymentMethod>> FilterUserPaymentMethod(int id)
        {
            var data = await _service.Filt_List_UserPaymentMethods(id);
            if (data == null)
                return NotFound(new MensajeDTOs { Resultado = 404, Messaje = "Método de pago no encontrado o inactivo." });

            return Ok(data);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertUserPaymentMethod([FromBody] UserPaymentMethod_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Insert_UserPaymentMethods(createDto);

                return respuesta.Resultado switch
                {
                    200 => Ok(respuesta),
                    400 => BadRequest(respuesta),
                    _ => StatusCode(500, respuesta)
                };
            }
            catch (Exception ex)
            {
                return StatusCode(500, new MensajeDTOs { Resultado = 500, Messaje = ex.Message });
            }
        }

        [HttpPut("Update")]
        public async Task<IActionResult> UpdateUserPaymentMethod([FromBody] UserPaymentMethod_Update_DTO updateDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Update_UserPaymentMethods(updateDto);

                return respuesta.Resultado switch
                {
                    200 => Ok(respuesta),
                    400 => BadRequest(respuesta),
                    404 => NotFound(respuesta),
                    _ => StatusCode(500, respuesta)
                };
            }
            catch (Exception ex)
            {
                return StatusCode(500, new MensajeDTOs { Resultado = 500, Messaje = ex.Message });
            }
        }

        [HttpDelete("Delete")]
        public async Task<IActionResult> DeleteUserPaymentMethod([FromBody] UserPaymentMethod_Delete_DTO deleteDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Delete_UserPaymentMethods(deleteDto);

                return respuesta.Resultado switch
                {
                    200 => Ok(respuesta),
                    400 => BadRequest(respuesta),
                    404 => NotFound(respuesta),
                    _ => StatusCode(500, respuesta)
                };
            }
            catch (Exception ex)
            {
                return StatusCode(500, new MensajeDTOs { Resultado = 500, Messaje = ex.Message });
            }
        }
    }
}
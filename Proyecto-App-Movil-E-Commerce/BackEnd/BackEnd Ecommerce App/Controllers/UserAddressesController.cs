using Application.DTOs;
using Application.Interface;
using Application.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserAddressesController : ControllerBase
    {
        private readonly Tbl_UserAddresses_Service _addressService;

        public UserAddressesController(Tbl_UserAddresses_Service addressService)
        {
            _addressService = addressService;
        }

        [HttpGet("List")]
        public async Task<IActionResult> ListUserAddresses()
        {
            var addresses = await _addressService.List_UserAddresses();
            return Ok(addresses);
        }

        [HttpGet("Filter")]
        public async Task<IActionResult> FilterUserAddresses([FromQuery] string criterio)
        {
            var addresses = await _addressService.Filt_List_UserAddresses(criterio);
            return Ok(addresses);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertUserAddress([FromBody] Tbl_UserAddress_Insert_DTOs createUserAddress)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuestas = await _addressService.Insert_UserAddresses(createUserAddress);

                if (respuestas.Resultado != 200 && respuestas.Resultado != 201)
                {
                    return BadRequest(respuestas);
                }
                return Ok(respuestas);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new MensajeDTOs { Resultado = 500, Messaje = ex.Message });
            }
        }

        [HttpPut("Update")]
        public async Task<IActionResult> UpdateUserAddress([FromBody] Tbl_UserAddress_Update_DTOs updateUserAddress)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _addressService.Update_UserAddresses(updateUserAddress);

                if (respuesta.Resultado != 200 && respuesta.Resultado != 201)
                {
                    return BadRequest(respuesta);
                }
                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new MensajeDTOs { Resultado = 500, Messaje = ex.Message });
            }
        }

        [HttpDelete("Delete")]
        public async Task<IActionResult> DeleteUserAddress([FromBody] Tbl_UserAddress_Delete_DTOs deleteUserAddress)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _addressService.Delete_UserAddresses(deleteUserAddress);

                if (respuesta.Resultado != 200 && respuesta.Resultado != 201)
                {
                    return BadRequest(respuesta);
                }
                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new MensajeDTOs { Resultado = 500, Messaje = ex.Message });
            }
        }
    }
}
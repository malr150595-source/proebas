using Application.DTOs;
using Application.Interface;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly ITbl_Users _userRepository;

        public UsersController(ITbl_Users userRepository)
        {
            _userRepository = userRepository;
        }

        [HttpGet("List")]
        public async Task<IActionResult> ListUsers()
        {
            var users = await _userRepository.List_Users();
            return Ok(users);
        }

        [HttpGet("Filter")]
        public async Task<IActionResult> FilterUsers([FromQuery] string criterio)
        {
            var users = await _userRepository.Filt_List_Users(criterio);
            return Ok(users);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertUser([FromBody] Tbl_User_Insert_DTOs createUser)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuestas = await _userRepository.Insert_Users(createUser);

                if (respuestas.Resultado != 200 && respuestas.Resultado != 201)
                {
                    return BadRequest(respuestas);
                }
                return Ok(respuestas);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpPut("Update")]
        public async Task<IActionResult> UpdateUser([FromBody] Tbl_User_Update_DTOs updateUser)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _userRepository.Update_Users(updateUser);

                if (respuesta.Resultado != 200 && respuesta.Resultado != 201)
                {
                    return BadRequest(respuesta);
                }
                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpDelete("Delete")]
        public async Task<IActionResult> DeleteUser([FromBody] Tbl_User_Delete_DTOs deleteUser)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _userRepository.Delete_Users(deleteUser);

                if (respuesta.Resultado != 200 && respuesta.Resultado != 201)
                {
                    return BadRequest(respuesta);
                }
                return Ok(respuesta);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        
    }
}   
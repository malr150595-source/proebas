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
    public class RolePermissionMatrixController(RolePermissionMatrix_Service service) : ControllerBase
    {
        private readonly RolePermissionMatrix_Service _service = service;

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<RolePermissionMatrix>>> ListRolePermissions()
        {
            var data = await _service.List_RolePermissions();
            return Ok(data);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<RolePermissionMatrix>>> FilterRolePermissions([FromQuery] string filt)
        {
            var data = await _service.Filt_List_RolePermissions(filt);
            return Ok(data);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertRolePermission([FromBody] RolePermissionMatrix_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Insert_List_RolePermissions(createDto);

                return respuesta.Resultado switch
                {
                    201 => Created(string.Empty, respuesta),
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
        public async Task<IActionResult> UpdateRolePermission([FromBody] RolePermissionMatrix_Update_DTO updateDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Update_List_RolePermissions(updateDto);

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

        [HttpDelete("Delete")]
        public async Task<IActionResult> DeleteRolePermission([FromBody] RolePermissionMatrix_Delete_DTO deleteDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Delete_List_RolePermissions(deleteDto);

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
    }
}
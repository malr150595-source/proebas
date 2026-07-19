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
    public class PermissionsController(Permissions_Service service) : ControllerBase
    {
        private readonly Permissions_Service _service = service;

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<Permission>>> ListPermissions()
        {
            var data = await _service.List_Permissions();
            return Ok(data);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<Permission>>> FilterPermissions([FromQuery] string filt)
        {
            var data = await _service.Filt_List_Permissions(filt);
            return Ok(data);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertPermission([FromBody] Permission_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Insert_List_Permissions(createDto);

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

        [HttpGet("ByRole/{roleId:int}")]
        public async Task<ActionResult<IEnumerable<RolePermission>>> ListPermissionsByRole(int roleId)
        {
            var data = await _service.List_PermissionsByRole(roleId);
            return Ok(data);
        }

        [HttpPost("Assign")]
        public async Task<IActionResult> AssignPermissionToRole([FromBody] RolePermission_Assign_DTO assignDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Assign_PermissionToRole(assignDto);

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

        [HttpPost("Revoke")]
        public async Task<IActionResult> RevokePermissionFromRole([FromBody] RolePermission_Revoke_DTO revokeDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Revoke_PermissionFromRole(revokeDto);

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
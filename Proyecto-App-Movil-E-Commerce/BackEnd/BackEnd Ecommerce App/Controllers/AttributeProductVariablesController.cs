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
    public class AttributeProductVariablesController(AttributeProductVariables_Service service) : ControllerBase
    {
        private readonly AttributeProductVariables_Service _service = service;

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<AttributeProductVariable>>> ListAttributeProductVariables()
        {
            var data = await _service.List_AttributeProductVariables();
            return Ok(data);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<AttributeProductVariable>>> FilterAttributeProductVariables([FromQuery] string filtro)
        {
            var data = await _service.Filt_List_AttributeProductVariables(filtro);
            return Ok(data);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertAttributeProductVariable([FromBody] AttributeProductVariable_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Insert_AttributeProductVariables(createDto);

                return respuesta.Resultado switch
                {
                    200 => Ok(respuesta),
                    201 => StatusCode(201, respuesta),
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
        public async Task<IActionResult> UpdateAttributeProductVariable([FromBody] AttributeProductVariable_Update_DTO updateDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Update_AttributeProductVariables(updateDto);

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
        public async Task<IActionResult> DeleteAttributeProductVariable([FromBody] AttributeProductVariable_Delete_DTO deleteDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Delete_AttributeProductVariables(deleteDto);

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
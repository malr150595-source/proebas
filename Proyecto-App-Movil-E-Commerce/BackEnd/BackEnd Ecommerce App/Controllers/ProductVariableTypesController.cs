using Application.DTOs;
using Application.Services;
using Domain;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.ProductVariableType_DTOs;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductVariableTypesController(ProductVariableTypes_Service service) : ControllerBase
    {
        private readonly ProductVariableTypes_Service _service = service;

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<ProductVariableType>>> ListProductVariableTypes()
        {
            var data = await _service.List_ProductVariableTypes();
            return Ok(data);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<ProductVariableType>>> FilterProductVariableTypes([FromQuery] string filtro)
        {
            var data = await _service.Filt_List_ProductVariableTypes(filtro);
            return Ok(data);
        }

        // --- FUNCIÓN DE INSERTAR ---
        [HttpPost("Insert")]
        public async Task<IActionResult> InsertProductVariableType([FromBody] ProductVariableType_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Insert_ProductVariableTypes(createDto);

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

        // --- FUNCIÓN DE ACTUALIZAR ---
        [HttpPut("Update")]
        public async Task<IActionResult> UpdateProductVariableType([FromBody] ProductVariableType_Update_DTO updateDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Update_ProductVariableTypes(updateDto);

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

        // --- FUNCIÓN DE ELIMINAR ---
        [HttpDelete("Delete")]
        public async Task<IActionResult> DeleteProductVariableType([FromBody] ProductVariableType_Delete_DTO deleteDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Delete_ProductVariableTypes(deleteDto);

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
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
    public class StockMovementTypesController(StockMovementTypes_Service service) : ControllerBase
    {
        private readonly StockMovementTypes_Service _service = service;

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<StockMovementType>>> ListStockMovementTypes()
        {
            var data = await _service.List_StockMovementTypes();
            return Ok(data);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<StockMovementType>>> FilterStockMovementTypes([FromQuery] string filt)
        {
            var data = await _service.Filt_List_StockMovementTypes(filt);
            return Ok(data);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertStockMovementType([FromBody] StockMovementType_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Insert_StockMovementTypes(createDto);

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
        public async Task<IActionResult> UpdateStockMovementType([FromBody] StockMovementType_Update_DTO updateDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Update_StockMovementTypes(updateDto);

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
        public async Task<IActionResult> DeleteStockMovementType([FromBody] StockMovementType_Delete_DTO deleteDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Delete_StockMovementTypes(deleteDto);

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
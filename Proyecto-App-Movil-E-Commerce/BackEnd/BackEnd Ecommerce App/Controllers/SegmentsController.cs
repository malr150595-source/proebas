using Application.DTOs;
using Application.Interface;
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
    public class SegmentsController : ControllerBase
    {
        // CORREGIDO: Usamos la interfaz para mantener la consistencia arquitectónica
        private readonly Segments_Service _segmentsService;

        public SegmentsController(Segments_Service segmentsService)
        {
            _segmentsService = segmentsService;
        }

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<Segment>>> ListSegments()
        {
            var segments = await _segmentsService.List_Segments();
            return Ok(segments);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<Segment>>> FilterSegments([FromQuery] string filtro)
        {
            var segments = await _segmentsService.Filt_List_Segments(filtro);
            return Ok(segments);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertSegment([FromBody] Segment_Insert_DTO createSegment)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _segmentsService.Insert_Segments(createSegment);

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

        [HttpPut("Update")]
        public async Task<IActionResult> UpdateSegment([FromBody] Segment_Update_DTO updateSegment)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _segmentsService.Update_Segments(updateSegment);

                if (respuesta.Resultado != 200)
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
        public async Task<IActionResult> DeleteSegment([FromBody] Segment_Delete_DTO deleteSegment)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _segmentsService.Delete_Segments(deleteSegment);

                if (respuesta.Resultado != 200)
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
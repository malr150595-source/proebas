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
    public class MarksController : ControllerBase
    {
        private readonly Marks_Service _marksService;

        public MarksController(Marks_Service marksService)
        {
            _marksService = marksService;
        }

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<Mark>>> ListMarks()
        {
            var marks = await _marksService.List_Marks();
            return Ok(marks);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<Mark>>> FilterMarks([FromQuery] string filtro)
        {
            var marks = await _marksService.Filt_List_Marks(filtro);
            return Ok(marks);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertMark([FromBody] Mark_Insert_DTO createMark)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _marksService.Insert_Marks(createMark);

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
        public async Task<IActionResult> UpdateMark([FromBody] Mark_Update_DTO updateMark)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _marksService.Update_Marks(updateMark);

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
        public async Task<IActionResult> DeleteMark([FromBody] Mark_Delete_DTO deleteMark)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _marksService.Delete_Marks(deleteMark);

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
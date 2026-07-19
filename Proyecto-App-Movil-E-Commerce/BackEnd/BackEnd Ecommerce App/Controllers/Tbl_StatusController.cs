using Application.DTOs;
using Application.Interface;
using Infraestructure.Infraestructure;
using Microsoft.AspNetCore.Mvc;

namespace BackEnd_Ecommerce_App.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class Tbl_StatusController : ControllerBase
    {
        private readonly ITbl_Status _status;

        public Tbl_StatusController(ITbl_Status status)
        {
            _status = status;
        }

        //Listar los estados
        [HttpGet("Listar")]
        public async Task<IActionResult> List_Status()
        {
            try
            {
                var lista = await _status.List_Status();
                return StatusCode(200,lista);
            }
            catch(Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpGet("Filtrar")]
        public async Task<IActionResult> Filt_list_Status([FromQuery] string nombre)
        {
            try
            {
                var lista = await _status.Filt_list_Status(nombre);
                return StatusCode(200, lista);
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpPost("Insertar_Estado")]
        public async Task<IActionResult> Insert_Status([FromBody] Tbl_Create_Status create)
        {
            try
            {
                MensajeDTOs respuesta = await _status.Insert_Status(create);

                if (respuesta.Resultado != 200)
                {
                   return BadRequest(respuesta);
                }
                return StatusCode(200, respuesta);
            }
            catch(Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpPut("Editar_Estado")]
        public async Task<IActionResult> Update_Status([FromBody] Tbl_Update_Status update)
        {
            try
            {
                MensajeDTOs respuesta = await _status.Update_Status(update);
                if(respuesta.Resultado != 200)
                {
                   return BadRequest(respuesta);
                }

                return StatusCode(200, respuesta);
            }
            catch(Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        [HttpDelete("Eliminar_Estado")]
        public async Task<IActionResult> Delete_status([FromBody] Tbl_Delete_Status delete)
        {
            try
            {
                MensajeDTOs respuesta = await _status.Delete_Status(delete);
                if (respuesta.Resultado != 200)
                {
                   return BadRequest(respuesta);
                }

                return StatusCode(200, respuesta);
            }
            catch(Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}

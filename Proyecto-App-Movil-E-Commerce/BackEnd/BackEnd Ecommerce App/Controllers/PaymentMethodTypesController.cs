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
    public class PaymentMethodTypesController(PaymentMethodTypes_Service service) : ControllerBase
    {
        private readonly PaymentMethodTypes_Service _service = service;

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<PaymentMethodType>>> ListPaymentMethodTypes()
        {
            var data = await _service.List_PaymentMethodTypes();
            return Ok(data);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<PaymentMethodType>>> FilterPaymentMethodTypes([FromQuery] string filtro)
        {
            var data = await _service.Filt_List_PaymentMethodTypes(filtro);
            return Ok(data);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertPaymentMethodType([FromBody] PaymentMethodType_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Insert_PaymentMethodTypes(createDto);

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
        public async Task<IActionResult> UpdatePaymentMethodType([FromBody] PaymentMethodType_Update_DTO updateDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Update_PaymentMethodTypes(updateDto);

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
        public async Task<IActionResult> DeletePaymentMethodType([FromBody] PaymentMethodType_Delete_DTO deleteDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Delete_PaymentMethodTypes(deleteDto);

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
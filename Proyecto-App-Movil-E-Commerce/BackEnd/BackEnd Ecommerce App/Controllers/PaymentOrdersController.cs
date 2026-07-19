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
    public class PaymentOrdersController(PaymentOrders_Service service) : ControllerBase
    {
        private readonly PaymentOrders_Service _service = service;

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<PaymentOrder>>> ListPaymentOrders([FromQuery] int? orderUserId)
        {
            var data = await _service.List_PaymentOrders(orderUserId);
            return Ok(data);
        }

        [HttpGet("Filter/{id:int}")]
        public async Task<ActionResult<PaymentOrder>> FilterPaymentOrder(int id)
        {
            var data = await _service.Filt_List_PaymentOrders(id);
            if (data == null)
                return NotFound(new MensajeDTOs { Resultado = 404, Messaje = "La orden de pago especificada no existe." });

            return Ok(data);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertPaymentOrder([FromBody] PaymentOrder_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Insert_PaymentOrders(createDto);

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
        public async Task<IActionResult> UpdatePaymentOrder([FromBody] PaymentOrder_Update_DTO updateDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Update_PaymentOrders(updateDto);

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

        [HttpPatch("UpdateStatus")]
        public async Task<IActionResult> UpdateOrderStatus([FromBody] PaymentOrder_UpdateStatus_DTO updateStatusDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Update_OrderStatus(updateStatusDto);

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
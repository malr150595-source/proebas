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
    public class ProductImagesController(ProductImages_Service service) : ControllerBase
    {
        private readonly ProductImages_Service _service = service;

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<ProductImage>>> ListProductImages()
        {
            var data = await _service.List_ProductImages();
            return Ok(data);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<ProductImage>>> FilterProductImages([FromQuery] string filtro)
        {
            var data = await _service.Filt_List_ProductImages(filtro);
            return Ok(data);
        }

        // --- FUNCIÓN DE INSERTAR ---
        [HttpPost("Insert")]
        public async Task<IActionResult> InsertProductImage([FromBody] ProductImage_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Insert_ProductImages(createDto);

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
        public async Task<IActionResult> UpdateProductImage([FromBody] ProductImage_Update_DTO updateDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Update_ProductImages(updateDto);

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
        public async Task<IActionResult> DeleteProductImage([FromBody] ProductImage_Delete_DTO deleteDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _service.Delete_ProductImages(deleteDto);

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
using Application.DTOs;
using Application.Services;
using Domain;
using Infraestructure.Repository;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.ProductIdentificator_DTOs;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductIdentificatorsController : ControllerBase
    {
        private readonly ProductIdentificators_Service _repository;

        public ProductIdentificatorsController(ProductIdentificators_Service repository)
        {
            _repository = repository;
        }

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<ProductIdentificator>>> ListProductIdentificators()
        {
            var data = await _repository.List_ProductIdentificators();
            return Ok(data);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<ProductIdentificator>>> FilterProductIdentificators([FromQuery] string filtro)
        {
            var data = await _repository.Filt_List_ProductIdentificators(filtro);
            return Ok(data);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertProductIdentificator([FromBody] ProductIdentificator_Insert_DTO createDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _repository.Insert_ProductIdentificators(createDto);

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
        public async Task<IActionResult> UpdateProductIdentificator([FromBody] ProductIdentificator_Update_DTO updateDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _repository.Update_ProductIdentificators(updateDto);

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
        public async Task<IActionResult> DeleteProductIdentificator([FromBody] ProductIdentificator_Delete_DTO deleteDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _repository.Delete_ProductIdentificators(deleteDto);

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
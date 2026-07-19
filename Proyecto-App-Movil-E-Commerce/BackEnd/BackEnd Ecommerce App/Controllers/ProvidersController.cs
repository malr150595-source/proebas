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
    public class ProvidersController : ControllerBase
    {
        private readonly Providers_Service _providersService;

        public ProvidersController(Providers_Service providersService)
        {
            _providersService = providersService;
        }

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<Provider>>> ListProviders()
        {
            var providers = await _providersService.List_Providers();
            return Ok(providers);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<Provider>>> FilterProviders([FromQuery] string filtro)
        {
            var providers = await _providersService.Filt_List_Providers(filtro);
            return Ok(providers);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertProvider([FromBody] Provider_Insert_DTO createProvider)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _providersService.Insert_Providers(createProvider);

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
        public async Task<IActionResult> UpdateProvider([FromBody] Provider_Update_DTO updateProvider)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _providersService.Update_Providers(updateProvider);

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
        public async Task<IActionResult> DeleteProvider([FromBody] Provider_Delete_DTO deleteProvider)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _providersService.Delete_Providers(deleteProvider);

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
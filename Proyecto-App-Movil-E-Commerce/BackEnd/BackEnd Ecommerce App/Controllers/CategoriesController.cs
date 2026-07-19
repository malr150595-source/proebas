using Application.DTOs;
using Application.Interface;
using Application.Services;
using Domain;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.Category_DTOs;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CategoriesController : ControllerBase
    {
        private readonly Categories_Service _categoriesService;

        public CategoriesController(Categories_Service categoriesService)
        {
            _categoriesService = categoriesService;
        }

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<Category>>> ListCategories()
        {
            var categories = await _categoriesService.List_Categories();
            return Ok(categories);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<Category>>> FilterCategories([FromQuery] string criterio)
        {
            var categories = await _categoriesService.Filt_List_Categories(criterio);
            return Ok(categories);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertCategory([FromBody] Category_Insert_DTO createCategory)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _categoriesService.Insert_Categories(createCategory);

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
        public async Task<IActionResult> UpdateCategory([FromBody] Category_Update_DTO updateCategory)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _categoriesService.Update_Categories(updateCategory);

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
        public async Task<IActionResult> DeleteCategory([FromBody] Category_Delete_DTO deleteCategory)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _categoriesService.Delete_Categories(deleteCategory);

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
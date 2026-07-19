using Application.DTOs;
using Application.Interface;
using Application.Services;
using Domain;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.Sub_CategoryDTO;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SubCategoriesController : ControllerBase
    {
        private readonly SubCategories_Service _subCategoriesService;

        public SubCategoriesController(SubCategories_Service subCategoriesService)
        {
            _subCategoriesService = subCategoriesService;
        }

        [HttpGet("List")]
        public async Task<ActionResult<IEnumerable<SubCategory>>> ListSubCategories()
        {
            var subCategories = await _subCategoriesService.List_SubCategories();
            return Ok(subCategories);
        }

        [HttpGet("Filter")]
        public async Task<ActionResult<IEnumerable<SubCategory>>> FilterSubCategories([FromQuery] string filtro)
        {
            var subCategories = await _subCategoriesService.Filt_List_SubCategories(filtro);
            return Ok(subCategories);
        }

        [HttpPost("Insert")]
        public async Task<IActionResult> InsertSubCategory([FromBody] SubCategory_Insert_DTO createSubCategory)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _subCategoriesService.Insert_SubCategories(createSubCategory);

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
        public async Task<IActionResult> UpdateSubCategory([FromBody] SubCategory_Update_DTO updateSubCategory)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _subCategoriesService.Update_SubCategories(updateSubCategory);

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
        public async Task<IActionResult> DeleteSubCategory([FromBody] SubCategory_Delete_DTO deleteSubCategory)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                MensajeDTOs respuesta = await _subCategoriesService.Delete_SubCategories(deleteSubCategory);

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
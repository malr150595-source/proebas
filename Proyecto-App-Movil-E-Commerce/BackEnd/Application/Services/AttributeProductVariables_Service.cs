using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class AttributeProductVariables_Service(IAttributeProductVariablesRepository repository)
    {
        private readonly IAttributeProductVariablesRepository _repository = repository;

        public async Task<IEnumerable<AttributeProductVariable>> List_AttributeProductVariables()
        {
            return await _repository.List_AttributeProductVariables();
        }

        public async Task<IEnumerable<AttributeProductVariable>> Filt_List_AttributeProductVariables(string? criterio)
        {
            try
            {
                return await _repository.Filt_List_AttributeProductVariables(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_AttributeProductVariables(AttributeProductVariable_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_AttributeProductVariables(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_AttributeProductVariables(AttributeProductVariable_Update_DTO update)
        {
            try
            {
                return await _repository.Update_AttributeProductVariables(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_AttributeProductVariables(AttributeProductVariable_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_AttributeProductVariables(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
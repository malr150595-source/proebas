using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.ProductVariableType_DTOs;

namespace Application.Services
{
    public class ProductVariableTypes_Service(IProductVariableTypesRepository repository)
    {
        private readonly IProductVariableTypesRepository _repository = repository;

        public async Task<IEnumerable<ProductVariableType>> List_ProductVariableTypes()
        {
            return await _repository.List_ProductVariableTypes();
        }

        public async Task<IEnumerable<ProductVariableType>> Filt_List_ProductVariableTypes(string? criterio)
        {
            try
            {
                return await _repository.Filt_List_ProductVariableTypes(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        // --- FUNCIÓN DE INSERTAR ---
        public async Task<MensajeDTOs> Insert_ProductVariableTypes(ProductVariableType_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_ProductVariableTypes(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        // --- FUNCIÓN DE ACTUALIZAR ---
        public async Task<MensajeDTOs> Update_ProductVariableTypes(ProductVariableType_Update_DTO update)
        {
            try
            {
                return await _repository.Update_ProductVariableTypes(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        // --- FUNCIÓN DE ELIMINAR ---
        public async Task<MensajeDTOs> Delete_ProductVariableTypes(ProductVariableType_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_ProductVariableTypes(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
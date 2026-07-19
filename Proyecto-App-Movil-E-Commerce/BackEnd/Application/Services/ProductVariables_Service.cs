using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class ProductVariables_Service(IProductVariablesRepository repository)
    {
        private readonly IProductVariablesRepository _repository = repository;

        public async Task<IEnumerable<ProductVariable>> List_ProductVariables()
        {
            return await _repository.List_ProductVariables();
        }

        public async Task<IEnumerable<ProductVariable>> Filt_List_ProductVariables(string? criterio)
        {
            try
            {
                return await _repository.Filt_List_ProductVariables(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        // --- FUNCIÓN DE INSERTAR ---
        public async Task<MensajeDTOs> Insert_ProductVariables(ProductVariable_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_ProductVariables(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        // --- FUNCIÓN DE ACTUALIZAR ---
        public async Task<MensajeDTOs> Update_ProductVariables(ProductVariable_Update_DTO update)
        {
            try
            {
                return await _repository.Update_ProductVariables(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        // --- FUNCIÓN DE ELIMINAR ---
        public async Task<MensajeDTOs> Delete_ProductVariables(ProductVariable_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_ProductVariables(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class StockMovementTypes_Service(IStockMovementTypesRepository repository)
    {
        private readonly IStockMovementTypesRepository _repository = repository;

        public async Task<IEnumerable<StockMovementType>> List_StockMovementTypes()
        {
            return await _repository.List_StockMovementTypes();
        }

        public async Task<IEnumerable<StockMovementType>> Filt_List_StockMovementTypes(string filt)
        {
            return await _repository.Filt_List_StockMovementTypes(filt);
        }

        public async Task<MensajeDTOs> Insert_StockMovementTypes(StockMovementType_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_StockMovementTypes(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_StockMovementTypes(StockMovementType_Update_DTO update)
        {
            try
            {
                return await _repository.Update_StockMovementTypes(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_StockMovementTypes(StockMovementType_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_StockMovementTypes(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
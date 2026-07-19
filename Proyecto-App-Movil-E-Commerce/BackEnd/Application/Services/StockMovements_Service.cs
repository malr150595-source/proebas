using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class StockMovements_Service(IStockMovementsRepository repository)
    {
        private readonly IStockMovementsRepository _repository = repository;

        public async Task<IEnumerable<StockMovement>> List_StockMovements(int? stockMovementType, int? stockMovementOrderId)
        {
            return await _repository.List_StockMovements(stockMovementType, stockMovementOrderId);
        }

        public async Task<IEnumerable<StockMovement>> Filt_List_StockMovements(string filt)
        {
            return await _repository.Filt_List_StockMovements(filt);
        }

        public async Task<MensajeDTOs> Insert_StockMovements(StockMovement_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_StockMovements(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_StockMovements(StockMovement_Update_DTO update)
        {
            try
            {
                return await _repository.Update_StockMovements(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_StockMovements(StockMovement_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_StockMovements(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
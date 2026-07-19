using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class StockMovementDetails_Service(IStockMovementDetailsRepository repository)
    {
        private readonly IStockMovementDetailsRepository _repository = repository;

        public async Task<IEnumerable<StockMovementDetail>> List_StockMovementDetails(int? stockMovementDetailMovementId, int? stockMovementDetailStockId)
        {
            return await _repository.List_StockMovementDetails(stockMovementDetailMovementId, stockMovementDetailStockId);
        }

        public async Task<IEnumerable<StockMovementDetail>> Filt_List_StockMovementDetails(int filt)
        {
            return await _repository.Filt_List_StockMovementDetails(filt);
        }

        public async Task<MensajeDTOs> Insert_StockMovementDetails(StockMovementDetail_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_StockMovementDetails(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_StockMovementDetails(StockMovementDetail_Update_DTO update)
        {
            try
            {
                return await _repository.Update_StockMovementDetails(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_StockMovementDetails(StockMovementDetail_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_StockMovementDetails(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IStockMovementDetailsRepository
    {
        Task<IEnumerable<StockMovementDetail>> List_StockMovementDetails(int? stockMovementDetailMovementId, int? stockMovementDetailStockId);
        Task<IEnumerable<StockMovementDetail>> Filt_List_StockMovementDetails(int filt);
        Task<MensajeDTOs> Insert_StockMovementDetails(StockMovementDetail_Insert_DTO create);
        Task<MensajeDTOs> Update_StockMovementDetails(StockMovementDetail_Update_DTO update);
        Task<MensajeDTOs> Delete_StockMovementDetails(StockMovementDetail_Delete_DTO delete);
    }
}

using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IStockMovementsRepository
    {
        Task<IEnumerable<StockMovement>> List_StockMovements(int? stockMovementType, int? stockMovementOrderId);
        Task<IEnumerable<StockMovement>> Filt_List_StockMovements(string filt);
        Task<MensajeDTOs> Insert_StockMovements(StockMovement_Insert_DTO create);
        Task<MensajeDTOs> Update_StockMovements(StockMovement_Update_DTO update);
        Task<MensajeDTOs> Delete_StockMovements(StockMovement_Delete_DTO delete);
    }
}

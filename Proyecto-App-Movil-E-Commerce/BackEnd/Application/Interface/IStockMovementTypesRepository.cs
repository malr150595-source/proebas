using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IStockMovementTypesRepository
    {
        Task<IEnumerable<StockMovementType>> List_StockMovementTypes();
        Task<IEnumerable<StockMovementType>> Filt_List_StockMovementTypes(string filt);
        Task<MensajeDTOs> Insert_StockMovementTypes(StockMovementType_Insert_DTO create);
        Task<MensajeDTOs> Update_StockMovementTypes(StockMovementType_Update_DTO update);
        Task<MensajeDTOs> Delete_StockMovementTypes(StockMovementType_Delete_DTO delete);
    }
}

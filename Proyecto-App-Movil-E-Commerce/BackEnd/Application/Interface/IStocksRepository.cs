using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IStocksRepository
    {
        Task<IEnumerable<Stock>> List_Stocks();
        Task<IEnumerable<Stock>> Filt_List_Stocks(string filtro);
        Task<MensajeDTOs> Insert_Stocks(Stock_Insert_DTO create);
        Task<MensajeDTOs> Update_Stocks(Stock_Update_DTO update);
        Task<MensajeDTOs> Delete_Stocks(Stock_Delete_DTO delete);
    }
}

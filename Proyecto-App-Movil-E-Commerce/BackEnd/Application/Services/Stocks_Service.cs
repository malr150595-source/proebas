using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class Stocks_Service(IStocksRepository repository)
    {
        private readonly IStocksRepository _repository = repository;

        public async Task<IEnumerable<Stock>> List_Stocks()
        {
            return await _repository.List_Stocks();
        }

        public async Task<IEnumerable<Stock>> Filt_List_Stocks(string? criterio)
        {
            try
            {
                return await _repository.Filt_List_Stocks(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_Stocks(Stock_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_Stocks(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_Stocks(Stock_Update_DTO update)
        {
            try
            {
                return await _repository.Update_Stocks(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_Stocks(Stock_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_Stocks(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
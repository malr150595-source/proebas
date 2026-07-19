using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class Carts_Service(ICartsRepository repository)
    {
        private readonly ICartsRepository _repository = repository;

        public async Task<IEnumerable<Cart>> List_Carts()
        {
            return await _repository.List_Carts();
        }

        public async Task<IEnumerable<Cart>> Filt_List_Carts(int filtro)
        {
            try
            {
                return await _repository.Filt_List_Carts(filtro);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_Carts(Cart_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_Carts(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_Carts(Cart_Update_DTO update)
        {
            try
            {
                return await _repository.Update_Carts(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_Carts(Cart_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_Carts(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
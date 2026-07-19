using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class CartDetails_Service(ICartDetailsRepository repository)
    {
        private readonly ICartDetailsRepository _repository = repository;

        public async Task<IEnumerable<CartDetail>> List_CartDetails(int cartId)
        {
            return await _repository.List_CartDetails(cartId);
        }

        public async Task<IEnumerable<CartDetail>> Filt_List_CartDetails(int filtro)
        {
            try
            {
                return await _repository.Filt_List_CartDetails(filtro);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_CartDetails(CartDetail_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_CartDetails(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_CartDetails(CartDetail_Update_DTO update)
        {
            try
            {
                return await _repository.Update_CartDetails(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_CartDetails(CartDetail_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_CartDetails(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
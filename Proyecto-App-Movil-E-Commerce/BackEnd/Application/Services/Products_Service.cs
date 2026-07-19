using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class Products_Service
    {
        private readonly IProductsRepository _repository;

        public Products_Service(IProductsRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Product>> List_Products()
        {
            return await _repository.List_Products();
        }

        public async Task<IEnumerable<Product>> Filt_List_Products(string? criterio)
        {
            try
            {
                return await _repository.Filt_List_Products(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_Products(Product_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_Products(create);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_Products(Product_Update_DTO update)
        {
            try
            {
                return await _repository.Update_Products(update);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_Products(Product_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_Products(delete);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
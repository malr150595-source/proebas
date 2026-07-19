using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.ProductIdentificator_DTOs;

namespace Application.Services
{
    public class ProductIdentificators_Service
    {
        private readonly IProductIdentificatorsRepository _productIdentificatorsRepository;

        public ProductIdentificators_Service(IProductIdentificatorsRepository productIdentificatorsRepository)
        {
            _productIdentificatorsRepository = productIdentificatorsRepository;
        }

        public async Task<IEnumerable<ProductIdentificator>> List_ProductIdentificators()
        {
            return await _productIdentificatorsRepository.List_ProductIdentificators();
        }

        public async Task<IEnumerable<ProductIdentificator>> Filt_List_ProductIdentificators(string? criterio)
        {
            try
            {
                return await _productIdentificatorsRepository.Filt_List_ProductIdentificators(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_ProductIdentificators(ProductIdentificator_Insert_DTO create)
        {
            try
            {
                return await _productIdentificatorsRepository.Insert_ProductIdentificators(create);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_ProductIdentificators(ProductIdentificator_Update_DTO update)
        {
            try
            {
                return await _productIdentificatorsRepository.Update_ProductIdentificators(update);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_ProductIdentificators(ProductIdentificator_Delete_DTO delete)
        {
            try
            {
                return await _productIdentificatorsRepository.Delete_ProductIdentificators(delete);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
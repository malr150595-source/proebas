using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.Category_DTOs;

namespace Application.Services
{
    public class Categories_Service : ICategoriesRepository
    {
        private readonly ICategoriesRepository _repository;

        public Categories_Service(ICategoriesRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Category>> List_Categories()
        {
            return await _repository.List_Categories();
        }

        public async Task<IEnumerable<Category>> Filt_List_Categories(string criterio)
        {
            try
            {
                return await _repository.Filt_List_Categories(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_Categories(Category_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_Categories(create);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_Categories(Category_Update_DTO update)
        {
            try
            {
                return await _repository.Update_Categories(update);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_Categories(Category_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_Categories(delete);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
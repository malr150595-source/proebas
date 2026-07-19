using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.Sub_CategoryDTO;

namespace Application.Services
{
    public class SubCategories_Service : ISubcategory_Repository
    {
        private readonly ISubcategory_Repository _repository;

        public SubCategories_Service(ISubcategory_Repository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<SubCategory>> List_SubCategories()
        {
            return await _repository.List_SubCategories();
        }

        public async Task<IEnumerable<SubCategory>> Filt_List_SubCategories(string filtro)
        {
            return await _repository.Filt_List_SubCategories(filtro ?? string.Empty);
        }

        public async Task<MensajeDTOs> Insert_SubCategories(SubCategory_Insert_DTO create)
        {
            return await _repository.Insert_SubCategories(create);
        }

        public async Task<MensajeDTOs> Update_SubCategories(SubCategory_Update_DTO update)
        {
            return await _repository.Update_SubCategories(update);
        }

        public async Task<MensajeDTOs> Delete_SubCategories(SubCategory_Delete_DTO delete)
        {
            return await _repository.Delete_SubCategories(delete);
        }
    }
}
using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;
using static Application.DTOs.Sub_CategoryDTO;

namespace Application.Interface
{
    public interface ISubcategory_Repository
    {
        Task<IEnumerable<SubCategory>> List_SubCategories();
        Task<IEnumerable<SubCategory>> Filt_List_SubCategories(string filtro);
        Task<MensajeDTOs> Insert_SubCategories(SubCategory_Insert_DTO create);
        Task<MensajeDTOs> Update_SubCategories(SubCategory_Update_DTO update);
        Task<MensajeDTOs> Delete_SubCategories(SubCategory_Delete_DTO delete);
    }
}

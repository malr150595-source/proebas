using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;
using static Application.DTOs.Category_DTOs;

namespace Application.Interface
{
    public interface ICategoriesRepository
    {
        Task<IEnumerable<Category>> List_Categories();
        Task<IEnumerable<Category>> Filt_List_Categories(string criterio);
        Task<MensajeDTOs> Insert_Categories(Category_Insert_DTO create);
        Task<MensajeDTOs> Update_Categories(Category_Update_DTO update);
        Task<MensajeDTOs> Delete_Categories(Category_Delete_DTO delete);
    }
}

using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IMarksRepository
    {
        Task<IEnumerable<Mark>> List_Marks();
        Task<IEnumerable<Mark>> Filt_List_Marks(string filtro);
        Task<MensajeDTOs> Insert_Marks(Mark_Insert_DTO create);
        Task<MensajeDTOs> Update_Marks(Mark_Update_DTO update);
        Task<MensajeDTOs> Delete_Marks(Mark_Delete_DTO delete);
    }
}

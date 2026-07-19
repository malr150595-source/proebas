using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IRolesRepository
    {
        Task<IEnumerable<Role>> List_Roles();
        Task<IEnumerable<Role>> Filt_List_Roles(string filt);
        Task<MensajeDTOs> Insert_List_Roles(Role_Insert_DTO create);
        Task<MensajeDTOs> Update_List_Roles(Role_Update_DTO update);
        Task<MensajeDTOs> Delete_List_Roles(Role_Delete_DTO delete);
    }
}

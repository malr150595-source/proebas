using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IUserRolesRepository
    {
        Task<IEnumerable<UserRole>> List_UserRoles();
        Task<IEnumerable<UserRole>> Filt_List_UserRoles(string filt);
        Task<MensajeDTOs> Insert_List_UserRoles(UserRole_Insert_DTO create);
        Task<MensajeDTOs> Update_List_UserRoles(UserRole_Update_DTO update);
        Task<MensajeDTOs> Delete_List_UserRoles(UserRole_Delete_DTO delete);
        Task<MensajeDTOs> AssignRoleBySuperAdminAsync(int targetUserId, int targetRoleId, int adminUserId);
    }
}

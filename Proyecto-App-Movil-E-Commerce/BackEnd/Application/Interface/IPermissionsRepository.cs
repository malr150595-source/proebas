using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IPermissionsRepository
    {
        Task<IEnumerable<Permission>> List_Permissions();
        Task<IEnumerable<Permission>> Filt_List_Permissions(string filt);
        Task<MensajeDTOs> Insert_List_Permissions(Permission_Insert_DTO create);
        Task<IEnumerable<RolePermission>> List_PermissionsByRole(int roleId);
        Task<MensajeDTOs> Assign_PermissionToRole(RolePermission_Assign_DTO assign);
        Task<MensajeDTOs> Revoke_PermissionFromRole(RolePermission_Revoke_DTO revoke);
    }
}

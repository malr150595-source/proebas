using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IRolePermissionMatrixRepository
    {
        Task<IEnumerable<RolePermissionMatrix>> List_RolePermissions();
        Task<IEnumerable<RolePermissionMatrix>> Filt_List_RolePermissions(string filt);
        Task<MensajeDTOs> Insert_List_RolePermissions(RolePermissionMatrix_Insert_DTO create);
        Task<MensajeDTOs> Update_List_RolePermissions(RolePermissionMatrix_Update_DTO update);
        Task<MensajeDTOs> Delete_List_RolePermissions(RolePermissionMatrix_Delete_DTO delete);
    }
}

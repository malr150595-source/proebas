using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class UserRoles_Service(IUserRolesRepository repository)
    {
        private readonly IUserRolesRepository _repository = repository;

        public async Task<IEnumerable<UserRole>> List_UserRoles() => await _repository.List_UserRoles();

        public async Task<IEnumerable<UserRole>> Filt_List_UserRoles(string filt) => await _repository.Filt_List_UserRoles(filt);

        public async Task<MensajeDTOs> Insert_List_UserRoles(UserRole_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_List_UserRoles(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_List_UserRoles(UserRole_Update_DTO update)
        {
            try
            {
                return await _repository.Update_List_UserRoles(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_List_UserRoles(UserRole_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_List_UserRoles(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> AssignRoleBySuperAdminAsync(int targetUserId, int targetRoleId, int adminUserId)
        {
            return await _repository.AssignRoleBySuperAdminAsync(targetUserId, targetRoleId, adminUserId);
        }
    }
}
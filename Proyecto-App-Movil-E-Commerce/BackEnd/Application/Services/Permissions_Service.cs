using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class Permissions_Service(IPermissionsRepository repository)
    {
        private readonly IPermissionsRepository _repository = repository;

        public async Task<IEnumerable<Permission>> List_Permissions() => await _repository.List_Permissions();

        public async Task<IEnumerable<Permission>> Filt_List_Permissions(string filt) => await _repository.Filt_List_Permissions(filt);

        public async Task<MensajeDTOs> Insert_List_Permissions(Permission_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_List_Permissions(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<IEnumerable<RolePermission>> List_PermissionsByRole(int roleId) => await _repository.List_PermissionsByRole(roleId);

        public async Task<MensajeDTOs> Assign_PermissionToRole(RolePermission_Assign_DTO assign)
        {
            try
            {
                return await _repository.Assign_PermissionToRole(assign);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Revoke_PermissionFromRole(RolePermission_Revoke_DTO revoke)
        {
            try
            {
                return await _repository.Revoke_PermissionFromRole(revoke);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
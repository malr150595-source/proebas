using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class RolePermissionMatrix_Service(IRolePermissionMatrixRepository repository)
    {
        private readonly IRolePermissionMatrixRepository _repository = repository;

        public async Task<IEnumerable<RolePermissionMatrix>> List_RolePermissions() => await _repository.List_RolePermissions();

        public async Task<IEnumerable<RolePermissionMatrix>> Filt_List_RolePermissions(string filt) => await _repository.Filt_List_RolePermissions(filt);

        public async Task<MensajeDTOs> Insert_List_RolePermissions(RolePermissionMatrix_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_List_RolePermissions(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_List_RolePermissions(RolePermissionMatrix_Update_DTO update)
        {
            try
            {
                return await _repository.Update_List_RolePermissions(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_List_RolePermissions(RolePermissionMatrix_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_List_RolePermissions(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
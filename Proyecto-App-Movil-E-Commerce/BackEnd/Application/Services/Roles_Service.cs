using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class Roles_Service(IRolesRepository repository)
    {
        private readonly IRolesRepository _repository = repository;

        public async Task<IEnumerable<Role>> List_Roles() => await _repository.List_Roles();

        public async Task<IEnumerable<Role>> Filt_List_Roles(string filt) => await _repository.Filt_List_Roles(filt);

        public async Task<MensajeDTOs> Insert_List_Roles(Role_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_List_Roles(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_List_Roles(Role_Update_DTO update)
        {
            try
            {
                return await _repository.Update_List_Roles(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_List_Roles(Role_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_List_Roles(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
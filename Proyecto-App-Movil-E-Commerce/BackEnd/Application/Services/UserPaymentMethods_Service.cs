using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class UserPaymentMethods_Service(IUserPaymentMethodsRepository repository)
    {
        private readonly IUserPaymentMethodsRepository _repository = repository;

        public async Task<IEnumerable<UserPaymentMethod>> List_UserPaymentMethods(int userId)
        {
            return await _repository.List_UserPaymentMethods(userId);
        }

        public async Task<UserPaymentMethod?> Filt_List_UserPaymentMethods(int id)
        {
            try
            {
                return await _repository.Filt_List_UserPaymentMethods(id);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_UserPaymentMethods(UserPaymentMethod_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_UserPaymentMethods(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_UserPaymentMethods(UserPaymentMethod_Update_DTO update)
        {
            try
            {
                return await _repository.Update_UserPaymentMethods(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_UserPaymentMethods(UserPaymentMethod_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_UserPaymentMethods(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
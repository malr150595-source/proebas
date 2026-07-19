using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IUserPaymentMethodsRepository
    {
        Task<IEnumerable<UserPaymentMethod>> List_UserPaymentMethods(int userId);
        Task<UserPaymentMethod?> Filt_List_UserPaymentMethods(int id);
        Task<MensajeDTOs> Insert_UserPaymentMethods(UserPaymentMethod_Insert_DTO create);
        Task<MensajeDTOs> Update_UserPaymentMethods(UserPaymentMethod_Update_DTO update);
        Task<MensajeDTOs> Delete_UserPaymentMethods(UserPaymentMethod_Delete_DTO delete);
    }
}

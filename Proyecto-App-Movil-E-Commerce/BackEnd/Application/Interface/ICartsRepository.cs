using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface ICartsRepository
    {
        Task<IEnumerable<Cart>> List_Carts();
        Task<IEnumerable<Cart>> Filt_List_Carts(int filtro);
        Task<MensajeDTOs> Insert_Carts(Cart_Insert_DTO create);
        Task<MensajeDTOs> Update_Carts(Cart_Update_DTO update);
        Task<MensajeDTOs> Delete_Carts(Cart_Delete_DTO delete);
    }
}

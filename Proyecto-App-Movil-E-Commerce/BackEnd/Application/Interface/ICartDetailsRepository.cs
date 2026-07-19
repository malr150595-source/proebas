using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface ICartDetailsRepository
    {
        Task<IEnumerable<CartDetail>> List_CartDetails(int cartId);
        Task<IEnumerable<CartDetail>> Filt_List_CartDetails(int filtro);
        Task<MensajeDTOs> Insert_CartDetails(CartDetail_Insert_DTO create);
        Task<MensajeDTOs> Update_CartDetails(CartDetail_Update_DTO update);
        Task<MensajeDTOs> Delete_CartDetails(CartDetail_Delete_DTO delete);
    }
}

using Application.DTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface ITbl_UserAddresses
    {
        Task<IEnumerable<Tbl_UserAddress_DTOs>> List_UserAddresses();
        Task<IEnumerable<Tbl_UserAddress_DTOs>> Filt_List_UserAddresses(string criterio);
        Task<MensajeDTOs> Insert_UserAddresses(Tbl_UserAddress_Insert_DTOs create);
        Task<MensajeDTOs> Update_UserAddresses(Tbl_UserAddress_Update_DTOs update);
        Task<MensajeDTOs> Delete_UserAddresses(Tbl_UserAddress_Delete_DTOs delete);
    }
}

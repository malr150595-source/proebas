using Application.DTOs;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface ITbl_Users
    {
        Task<IEnumerable<Tbl_User_DTOs>> List_Users();
        Task<IEnumerable<Tbl_User_DTOs>> Filt_List_Users(string criterio);
        Task<MensajeDTOs> Insert_Users(Tbl_User_Insert_DTOs create);
        Task<MensajeDTOs> Update_Users(Tbl_User_Update_DTOs update);
        Task<MensajeDTOs> Delete_Users(Tbl_User_Delete_DTOs delete);
        Task<(MensajeDTOs Control, AuthResponseDto? UserData)> ValidateLoginAsync(Login_DTOs loginDto);
    }
}

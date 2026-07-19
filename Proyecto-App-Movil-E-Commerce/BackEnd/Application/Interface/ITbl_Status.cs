using System;
using System.Collections.Generic;
using System.Text;
using Application.DTOs;

namespace Application.Interface
{
    public interface ITbl_Status
    {
        Task<IEnumerable<Tbl_Status>> List_Status(); 
        Task<IEnumerable<Tbl_Status>> Filt_list_Status(string Filt);
        Task<MensajeDTOs> Insert_Status(Tbl_Create_Status tbl_Create); 
        Task<MensajeDTOs> Update_Status(Tbl_Update_Status tbl_Update); 
        Task<MensajeDTOs> Delete_Status(Tbl_Delete_Status tbl_Delete); 
    }
}

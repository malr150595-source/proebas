using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IProvidersRepository
    {
        Task<IEnumerable<Provider>> List_Providers();
        Task<IEnumerable<Provider>> Filt_List_Providers(string filtro);
        Task<MensajeDTOs> Insert_Providers(Provider_Insert_DTO create);
        Task<MensajeDTOs> Update_Providers(Provider_Update_DTO update);
        Task<MensajeDTOs> Delete_Providers(Provider_Delete_DTO delete);
    }
}

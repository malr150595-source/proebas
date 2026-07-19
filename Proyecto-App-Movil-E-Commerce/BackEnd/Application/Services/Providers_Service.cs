using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class Providers_Service
    {
        private readonly IProvidersRepository _providersRepository;

        public Providers_Service(IProvidersRepository providersRepository)
        {
            _providersRepository = providersRepository;
        }

        public async Task<IEnumerable<Provider>> List_Providers()
        {
            return await _providersRepository.List_Providers();
        }

        public async Task<IEnumerable<Provider>> Filt_List_Providers(string? criterio)
        {
            try
            {
                return await _providersRepository.Filt_List_Providers(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_Providers(Provider_Insert_DTO create)
        {
            try
            {
                return await _providersRepository.Insert_Providers(create);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_Providers(Provider_Update_DTO update)
        {
            try
            {
                return await _providersRepository.Update_Providers(update);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_Providers(Provider_Delete_DTO delete)
        {
            try
            {
                return await _providersRepository.Delete_Providers(delete);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
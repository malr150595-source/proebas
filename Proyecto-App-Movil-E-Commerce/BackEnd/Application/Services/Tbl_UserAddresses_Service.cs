using Application.DTOs;
using Application.Interface;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class Tbl_UserAddresses_Service : ITbl_UserAddresses
    {
        private readonly ITbl_UserAddresses _repository;

        public Tbl_UserAddresses_Service(ITbl_UserAddresses repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Tbl_UserAddress_DTOs>> List_UserAddresses()
        {
            return await _repository.List_UserAddresses();
        }

        public async Task<IEnumerable<Tbl_UserAddress_DTOs>> Filt_List_UserAddresses(string? criterio)
        {
            try
            {
                return await _repository.Filt_List_UserAddresses(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_UserAddresses(Tbl_UserAddress_Insert_DTOs create)
        {
            try
            {
                return await _repository.Insert_UserAddresses(create);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_UserAddresses(Tbl_UserAddress_Update_DTOs update)
        {
            try
            {
                return await _repository.Update_UserAddresses(update);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_UserAddresses(Tbl_UserAddress_Delete_DTOs delete)
        {
            try
            {
                return await _repository.Delete_UserAddresses(delete);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
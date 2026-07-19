using Application.DTOs;
using Application.Interface;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Services
{
    public class Tbl_Users_Service
    {
        private readonly ITbl_Users _usersRepository;

        public Tbl_Users_Service(ITbl_Users usersRepository)
        {
            _usersRepository = usersRepository;
        }

        public async Task<IEnumerable<Tbl_User_DTOs>> List_Users()
        {
            return await _usersRepository.List_Users();
        }

        public async Task<IEnumerable<Tbl_User_DTOs>> Filt_List_Users(string? criterio)
        {
            try
            {
                return await _usersRepository.Filt_List_Users(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_Users(Tbl_User_Insert_DTOs create)
        {
            try
            {
                return await _usersRepository.Insert_Users(create);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 0, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_Users(Tbl_User_Update_DTOs update)
        {
            try
            {
                return await _usersRepository.Update_Users(update);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 0, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_Users(Tbl_User_Delete_DTOs delete)
        {
            try
            {
                return await _usersRepository.Delete_Users(delete);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 0, Messaje = ex.Message };
            }
        }
    }
}

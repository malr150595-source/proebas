using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class Marks_Service
    {
        private readonly IMarksRepository _marksRepository;

        public Marks_Service(IMarksRepository marksRepository)
        {
            _marksRepository = marksRepository;
        }

        public async Task<IEnumerable<Mark>> List_Marks()
        {
            return await _marksRepository.List_Marks();
        }

        public async Task<IEnumerable<Mark>> Filt_List_Marks(string? criterio)
        {
            try
            {
                return await _marksRepository.Filt_List_Marks(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<MensajeDTOs> Insert_Marks(Mark_Insert_DTO create)
        {
            try
            {
                return await _marksRepository.Insert_Marks(create);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_Marks(Mark_Update_DTO update)
        {
            try
            {
                return await _marksRepository.Update_Marks(update);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_Marks(Mark_Delete_DTO delete)
        {
            try
            {
                return await _marksRepository.Delete_Marks(delete);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
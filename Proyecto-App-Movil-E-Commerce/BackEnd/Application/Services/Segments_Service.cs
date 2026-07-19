using Application.DTOs;
using Application.Interface;
using Domain;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class Segments_Service : ISegmentRepository
    {
        private readonly ISegmentRepository _repository;

        public Segments_Service(ISegmentRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Segment>> List_Segments()
        {
            return await _repository.List_Segments();
        }

        public async Task<IEnumerable<Segment>> Filt_List_Segments(string filtro)
        {
            return await _repository.Filt_List_Segments(filtro ?? string.Empty);
        }

        // CORREGIDO: Debe usar Segment_Insert_DTO
        public async Task<MensajeDTOs> Insert_Segments(Segment_Insert_DTO create)
        {
            return await _repository.Insert_Segments(create);
        }

        // CORREGIDO: Debe usar Segment_Update_DTO
        public async Task<MensajeDTOs> Update_Segments(Segment_Update_DTO update)
        {
            return await _repository.Update_Segments(update);
        }

        // CORREGIDO: Debe usar Segment_Delete_DTO
        public async Task<MensajeDTOs> Delete_Segments(Segment_Delete_DTO delete)
        {
            return await _repository.Delete_Segments(delete);
        }
    }
}
using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface ISegmentRepository
    {
        Task<IEnumerable<Segment>> List_Segments();
        Task<IEnumerable<Segment>> Filt_List_Segments(string filtro);
        Task<MensajeDTOs> Insert_Segments(Segment_Insert_DTO create);
        Task<MensajeDTOs> Update_Segments(Segment_Update_DTO update);
        Task<MensajeDTOs> Delete_Segments(Segment_Delete_DTO delete);
    }
}

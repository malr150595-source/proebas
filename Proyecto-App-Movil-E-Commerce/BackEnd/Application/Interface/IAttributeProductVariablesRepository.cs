using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IAttributeProductVariablesRepository
    {
        Task<IEnumerable<AttributeProductVariable>> List_AttributeProductVariables();
        Task<IEnumerable<AttributeProductVariable>> Filt_List_AttributeProductVariables(string filtro);
        Task<MensajeDTOs> Insert_AttributeProductVariables(AttributeProductVariable_Insert_DTO create);
        Task<MensajeDTOs> Update_AttributeProductVariables(AttributeProductVariable_Update_DTO update);
        Task<MensajeDTOs> Delete_AttributeProductVariables(AttributeProductVariable_Delete_DTO delete);
    }
}

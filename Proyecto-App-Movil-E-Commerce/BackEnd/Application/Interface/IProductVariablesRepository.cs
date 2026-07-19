using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IProductVariablesRepository
    {
        Task<IEnumerable<ProductVariable>> List_ProductVariables();
        Task<IEnumerable<ProductVariable>> Filt_List_ProductVariables(string filtro);
        Task<MensajeDTOs> Insert_ProductVariables(ProductVariable_Insert_DTO create);
        Task<MensajeDTOs> Update_ProductVariables(ProductVariable_Update_DTO update);
        Task<MensajeDTOs> Delete_ProductVariables(ProductVariable_Delete_DTO delete);
    }
}

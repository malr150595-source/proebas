using Application.DTOs;
using Domain;
using System.Collections.Generic;
using System.Threading.Tasks;
using static Application.DTOs.ProductVariableType_DTOs;

namespace Application.Interface
{
    public interface IProductVariableTypesRepository
    {
        Task<IEnumerable<ProductVariableType>> List_ProductVariableTypes();
        Task<IEnumerable<ProductVariableType>> Filt_List_ProductVariableTypes(string filtro);
        Task<MensajeDTOs> Insert_ProductVariableTypes(ProductVariableType_Insert_DTO create);
        Task<MensajeDTOs> Update_ProductVariableTypes(ProductVariableType_Update_DTO update);
        Task<MensajeDTOs> Delete_ProductVariableTypes(ProductVariableType_Delete_DTO delete);
    }
}
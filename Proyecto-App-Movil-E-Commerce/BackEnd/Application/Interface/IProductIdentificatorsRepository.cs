using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;
using static Application.DTOs.ProductIdentificator_DTOs;

namespace Application.Interface
{
    public interface IProductIdentificatorsRepository
    {
        Task<IEnumerable<ProductIdentificator>> List_ProductIdentificators();
        Task<IEnumerable<ProductIdentificator>> Filt_List_ProductIdentificators(string filtro);
        Task<MensajeDTOs> Insert_ProductIdentificators(ProductIdentificator_Insert_DTO create);
        Task<MensajeDTOs> Update_ProductIdentificators(ProductIdentificator_Update_DTO update);
        Task<MensajeDTOs> Delete_ProductIdentificators(ProductIdentificator_Delete_DTO delete);
    }
}

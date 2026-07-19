using Application.DTOs;
using Domain;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Interface
{
    public interface IProductsRepository
    {
        Task<IEnumerable<Product>> List_Products();
        Task<IEnumerable<Product>> Filt_List_Products(string filtro);
        Task<MensajeDTOs> Insert_Products(Product_Insert_DTO create);
        Task<MensajeDTOs> Update_Products(Product_Update_DTO update);
        Task<MensajeDTOs> Delete_Products(Product_Delete_DTO delete);
    }
}
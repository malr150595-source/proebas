using Application.DTOs;
using Domain;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface
{
    public interface IProductImagesRepository
    {
        Task<IEnumerable<ProductImage>> List_ProductImages();
        Task<IEnumerable<ProductImage>> Filt_List_ProductImages(string filtro);
        Task<MensajeDTOs> Insert_ProductImages(ProductImage_Insert_DTO create);
        Task<MensajeDTOs> Update_ProductImages(ProductImage_Update_DTO update);
        Task<MensajeDTOs> Delete_ProductImages(ProductImage_Delete_DTO delete);
    }
}

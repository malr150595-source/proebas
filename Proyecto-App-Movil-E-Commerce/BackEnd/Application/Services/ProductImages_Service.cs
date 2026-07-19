using Application.DTOs;
using Application.Interface;
using Domain;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Application.Services
{
    public class ProductImages_Service(IProductImagesRepository repository)
    {
        private readonly IProductImagesRepository _repository = repository;

        public async Task<IEnumerable<ProductImage>> List_ProductImages()
        {
            return await _repository.List_ProductImages();
        }

        public async Task<IEnumerable<ProductImage>> Filt_List_ProductImages(string? criterio)
        {
            try
            {
                return await _repository.Filt_List_ProductImages(criterio ?? string.Empty);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        // --- FUNCIÓN DE INSERTAR ---
        public async Task<MensajeDTOs> Insert_ProductImages(ProductImage_Insert_DTO create)
        {
            try
            {
                return await _repository.Insert_ProductImages(create);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        // --- FUNCIÓN DE ACTUALIZAR ---
        public async Task<MensajeDTOs> Update_ProductImages(ProductImage_Update_DTO update)
        {
            try
            {
                return await _repository.Update_ProductImages(update);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }

        // --- FUNCIÓN DE ELIMINAR ---
        public async Task<MensajeDTOs> Delete_ProductImages(ProductImage_Delete_DTO delete)
        {
            try
            {
                return await _repository.Delete_ProductImages(delete);
            }
            catch (Exception ex)
            {
                return new() { Resultado = 500, Messaje = ex.Message };
            }
        }
    }
}
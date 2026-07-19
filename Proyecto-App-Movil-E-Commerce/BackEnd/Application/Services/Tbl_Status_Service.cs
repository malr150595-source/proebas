using Application.Interface;
using System;
using System.Collections.Generic;
using System.Text;
using Application.Services;
using Application.DTOs;

namespace Application.Services
{
    public class Tbl_Status_Service : ITbl_Status
    {
        private readonly ITbl_Status _Status;

        public Tbl_Status_Service(ITbl_Status Status)
        {
            _Status = Status;
        }

        public async Task<IEnumerable<Tbl_Status>> List_Status()
        {
            var olist = await _Status.List_Status();
            return olist.Select(p => new Tbl_Status
            {
                StatusId = p.StatusId,
                StatusName = p.StatusName,
                StatusCreatorId = p.StatusCreatorId,
                StatusCreationDate = p.StatusCreationDate,
                StatusModificatorId = p.StatusModificatorId,
                StatusModificationDate = p.StatusModificationDate
            });
        }

        public async Task<IEnumerable<Tbl_Status>> Filt_list_Status(string? Nombre)
        {
            try
            {
                var olist = await _Status.Filt_list_Status(Nombre!);
                return olist.Select(p => new Tbl_Status
                {
                    StatusId = p.StatusId,
                    StatusName = p.StatusName,
                    StatusCreatorId = p.StatusCreatorId,
                    StatusCreationDate = p.StatusCreationDate,
                    StatusModificatorId = p.StatusModificatorId,
                    StatusModificationDate = p.StatusModificationDate
                });
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public async Task<MensajeDTOs> Insert_Status(Tbl_Create_Status create)
        {
            try
            {
                var olist = new Tbl_Create_Status
                {
                    StatusName = create.StatusName,
                    StatusCreatorId = create.StatusCreatorId,
                    StatusCreationDate = create.StatusCreationDate
                };
                return await _Status.Insert_Status(create);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 0, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Update_Status(Tbl_Update_Status update)
        {
            try
            {
                var olist = new Tbl_Update_Status
                {
                    StatusName = update.StatusName,
                    StatusModificatorId = update.StatusModificatorId,
                    StatusModificationDate = update.StatusModificationDate
                };
                return await _Status.Update_Status(update);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 0, Messaje = ex.Message };
            }
        }

        public async Task<MensajeDTOs> Delete_Status(Tbl_Delete_Status delete)
        {
            try
            {
                return await _Status.Delete_Status(delete);
            }
            catch (Exception ex)
            {
                return new MensajeDTOs { Resultado = 0, Messaje = ex.Message };
            }
        }
    }
}

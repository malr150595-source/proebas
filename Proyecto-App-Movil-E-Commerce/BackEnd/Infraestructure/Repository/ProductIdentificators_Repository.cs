using Application.DTOs;
using Application.Interface;
using Domain;
using Infraestructure.Db;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using static Application.DTOs.ProductIdentificator_DTOs;

namespace Infraestructure.Repository
{
    public class ProductIdentificators_Repository : IProductIdentificatorsRepository
    {
        private readonly DBConectionFactory _connection;

        public ProductIdentificators_Repository(DBConectionFactory connection)
        {
            _connection = connection;
        }

        public async Task<IEnumerable<ProductIdentificator>> List_ProductIdentificators()
        {
            var lista = new List<ProductIdentificator>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[List_ProductIdentificators]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new ProductIdentificator
                {
                    Id = dr["Id"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Id"]),
                    IdCategoria = dr["IdCategoria"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdCategoria"]),
                    NombreCategoria = dr["NombreCategoria"] == DBNull.Value ? string.Empty : dr["NombreCategoria"].ToString()!,
                    IdSubCategoria = dr["IdSubCategoria"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdSubCategoria"]),
                    NombreSubCategoria = dr["NombreSubCategoria"] == DBNull.Value ? string.Empty : dr["NombreSubCategoria"].ToString()!,
                    IdSegmento = dr["IdSegmento"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdSegmento"]),
                    NombreSegmento = dr["NombreSegmento"] == DBNull.Value ? string.Empty : dr["NombreSegmento"].ToString()!,
                    IdCreador = dr["IdCreador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdCreador"]),
                    FechaCreacion = dr["FechaCreacion"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["FechaCreacion"]),
                    IdModificador = dr["IdModificador"] == DBNull.Value ? null : Convert.ToInt32(dr["IdModificador"]),
                    FechaModificacion = dr["FechaModificacion"] == DBNull.Value ? null : Convert.ToDateTime(dr["FechaModificacion"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<ProductIdentificator>> Filt_List_ProductIdentificators(string filtro)
        {
            var lista = new List<ProductIdentificator>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Filt_List_ProductIdentificators]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@filtro", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new ProductIdentificator
                {
                    Id = dr["Id"] == DBNull.Value ? 0 : Convert.ToInt32(dr["Id"]),
                    IdCategoria = dr["IdCategoria"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdCategoria"]),
                    NombreCategoria = dr["NombreCategoria"] == DBNull.Value ? string.Empty : dr["NombreCategoria"].ToString()!,
                    IdSubCategoria = dr["IdSubCategoria"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdSubCategoria"]),
                    NombreSubCategoria = dr["NombreSubCategoria"] == DBNull.Value ? string.Empty : dr["NombreSubCategoria"].ToString()!,
                    IdSegmento = dr["IdSegmento"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdSegmento"]),
                    NombreSegmento = dr["NombreSegmento"] == DBNull.Value ? string.Empty : dr["NombreSegmento"].ToString()!,
                    IdCreador = dr["IdCreador"] == DBNull.Value ? 0 : Convert.ToInt32(dr["IdCreador"]),
                    FechaCreacion = dr["FechaCreacion"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["FechaCreacion"]),
                    IdModificador = dr["IdModificador"] == DBNull.Value ? null : Convert.ToInt32(dr["IdModificador"]),
                    FechaModificacion = dr["FechaModificacion"] == DBNull.Value ? null : Convert.ToDateTime(dr["FechaModificacion"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_ProductIdentificators(ProductIdentificator_Insert_DTO create)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Insert_ProductIdentificators]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorCategoryId", create.CategoryId));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorSubCategoryId", create.SubCategoryId));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorSegmentId", create.SegmentId));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorCreationDate", (object)create.CreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 100) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Update_ProductIdentificators(ProductIdentificator_Update_DTO update)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Update_ProductIdentificators]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorCategoryId", update.CategoryId));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorSubCategoryId", update.SubCategoryId));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorSegmentId", update.SegmentId));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorModificationDate", (object)update.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 100) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        public async Task<MensajeDTOs> Delete_ProductIdentificators(ProductIdentificator_Delete_DTO delete)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_CATALOGS].[Delete_ProductIdentificators]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@ProductIdentificatorModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.NVarChar, 100) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new SqlParameter("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString();
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }
    }
}
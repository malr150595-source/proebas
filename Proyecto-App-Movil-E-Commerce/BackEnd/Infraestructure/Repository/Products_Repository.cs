using Application.DTOs;
using Application.Interface;
using Domain;
using Infraestructure.Db;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructure.Repository
{
    public class Products_Repository : IProductsRepository
    {
        private readonly DBConectionFactory _connection;

        public Products_Repository(DBConectionFactory connection)
        {
            _connection = connection;
        }

        public async Task<IEnumerable<Product>> List_Products()
        {
            var lista = new List<Product>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[List_Products]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Product
                {
                    ProductId = dr["ProductId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProductId"]),
                    ProductName = dr["ProductName"] == DBNull.Value ? string.Empty : dr["ProductName"].ToString()!,
                    ProductDescription = dr["ProductDescription"] == DBNull.Value ? string.Empty : dr["ProductDescription"].ToString()!,
                    ProductProductIdentificatorId = dr["ProductProductIdentificatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProductProductIdentificatorId"]),

                    // Mapeo de campos del INNER JOIN (Identificadores)
                    CategoryName = dr["CategoryName"] == DBNull.Value ? string.Empty : dr["CategoryName"].ToString()!,
                    SubCategoryName = dr["SubCategoryName"] == DBNull.Value ? string.Empty : dr["SubCategoryName"].ToString()!,
                    SegmentName = dr["SegmentName"] == DBNull.Value ? string.Empty : dr["SegmentName"].ToString()!,

                    ProductMarkByProviderId = dr["ProductMarkByProviderId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProductMarkByProviderId"]),

                    // Mapeo de campos del INNER JOIN (Marcas y Proveedores)
                    MarkName = dr["MarkName"] == DBNull.Value ? string.Empty : dr["MarkName"].ToString()!,
                    ProviderName = dr["ProviderName"] == DBNull.Value ? string.Empty : dr["ProviderName"].ToString()!,

                    ProductCreatorId = dr["ProductCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProductCreatorId"]),
                    ProductCreationDate = dr["ProductCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["ProductCreationDate"]),
                    ProductModificatorId = dr["ProductModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["ProductModificatorId"]),
                    ProductModificationDate = dr["ProductModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["ProductModificationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<Product>> Filt_List_Products(string filtro)
        {
            var lista = new List<Product>();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[Filt_List_Products]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new Product
                {
                    ProductId = dr["ProductId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProductId"]),
                    ProductName = dr["ProductName"] == DBNull.Value ? string.Empty : dr["ProductName"].ToString()!,
                    ProductDescription = dr["ProductDescription"] == DBNull.Value ? string.Empty : dr["ProductDescription"].ToString()!,
                    ProductProductIdentificatorId = dr["ProductProductIdentificatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProductProductIdentificatorId"]),

                    // Mapeo de campos del INNER JOIN (Identificadores)
                    CategoryName = dr["CategoryName"] == DBNull.Value ? string.Empty : dr["CategoryName"].ToString()!,
                    SubCategoryName = dr["SubCategoryName"] == DBNull.Value ? string.Empty : dr["SubCategoryName"].ToString()!,
                    SegmentName = dr["SegmentName"] == DBNull.Value ? string.Empty : dr["SegmentName"].ToString()!,

                    ProductMarkByProviderId = dr["ProductMarkByProviderId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProductMarkByProviderId"]),

                    // Mapeo de campos del INNER JOIN (Marcas y Proveedores)
                    MarkName = dr["MarkName"] == DBNull.Value ? string.Empty : dr["MarkName"].ToString()!,
                    ProviderName = dr["ProviderName"] == DBNull.Value ? string.Empty : dr["ProviderName"].ToString()!,

                    ProductCreatorId = dr["ProductCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["ProductCreatorId"]),
                    ProductCreationDate = dr["ProductCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["ProductCreationDate"]),
                    ProductModificatorId = dr["ProductModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["ProductModificatorId"]),
                    ProductModificationDate = dr["ProductModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["ProductModificationDate"])
                });
            }
            return lista;
        }

        public async Task<MensajeDTOs> Insert_Products(Product_Insert_DTO create)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[Insert_Products]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@ProductName", create.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@ProductDescription", create.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@ProductProductIdentificatorId", create.ProductIdentificatorId));
                cmd.Parameters.Add(new SqlParameter("@ProductMarkByProviderId", create.MarkByProviderId));
                cmd.Parameters.Add(new SqlParameter("@ProductCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@ProductCreationDate", (object)create.CreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
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

        public async Task<MensajeDTOs> Update_Products(Product_Update_DTO update)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[Update_Products]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@ProductId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@ProductName", update.Name ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@ProductDescription", update.Description ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@ProductProductIdentificatorId", update.ProductIdentificatorId));
                cmd.Parameters.Add(new SqlParameter("@ProductMarkByProviderId", update.MarkByProviderId));
                cmd.Parameters.Add(new SqlParameter("@ProductModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@ProductModificationDate", (object)update.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
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

        public async Task<MensajeDTOs> Delete_Products(Product_Delete_DTO delete)
        {
            var respuesta = new MensajeDTOs();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new SqlCommand("[SQM_GENERAL].[Delete_Products]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@ProductId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@ProductModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@ProductModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new SqlParameter("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
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
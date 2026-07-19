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
    public class AttributeProductVariables_Repository(DBConectionFactory connection) : IAttributeProductVariablesRepository
    {
        private readonly DBConectionFactory _connection = connection;

        public async Task<IEnumerable<AttributeProductVariable>> List_AttributeProductVariables()
        {
            List<AttributeProductVariable> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[List_AttributeProductVariables]", con);
            cmd.CommandType = CommandType.StoredProcedure;

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    AttributeProductVariableId = dr["attributeProductVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["attributeProductVariableId"]),
                    AttributeProductVariableProductVariableId = dr["attributeProductVariableProductVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["attributeProductVariableProductVariableId"]),
                    ProductVariableValueRef = dr["productVariableValueRef"] == DBNull.Value ? string.Empty : dr["productVariableValueRef"].ToString()!,
                    AttributeProductVariableAttributeProductId = dr["attributeProductVariableAttributeProductId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["attributeProductVariableAttributeProductId"]),
                    AttributeProductName = dr["attributeProductName"] == DBNull.Value ? string.Empty : dr["attributeProductName"].ToString()!,
                    AttributeProductVariableValue = dr["attributeProductVariableValue"] == DBNull.Value ? string.Empty : dr["attributeProductVariableValue"].ToString()!,
                    AttributeProductVariableCreatorId = dr["attributeProductVariableCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["attributeProductVariableCreatorId"]),
                    AttributeProductVariableCreationDate = dr["attributeProductVariableCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["attributeProductVariableCreationDate"]),
                    AttributeProductVariableModificatorId = dr["attributeProductVariableModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["attributeProductVariableModificatorId"]),
                    AttributeProductVariableModificationDate = dr["attributeProductVariableModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["attributeProductVariableModificationDate"])
                });
            }
            return lista;
        }

        public async Task<IEnumerable<AttributeProductVariable>> Filt_List_AttributeProductVariables(string filtro)
        {
            List<AttributeProductVariable> lista = new();
            using var con = _connection.CreateConetion();
            await con.OpenAsync();

            using SqlCommand cmd = new("[SQM_GENERAL].[Filt_list_AttributeProductVariables]", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@Filt", filtro ?? string.Empty));

            using SqlDataReader dr = await cmd.ExecuteReaderAsync();
            while (await dr.ReadAsync())
            {
                lista.Add(new()
                {
                    AttributeProductVariableId = dr["attributeProductVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["attributeProductVariableId"]),
                    AttributeProductVariableProductVariableId = dr["attributeProductVariableProductVariableId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["attributeProductVariableProductVariableId"]),
                    ProductVariableValueRef = dr["productVariableValueRef"] == DBNull.Value ? string.Empty : dr["productVariableValueRef"].ToString()!,
                    AttributeProductVariableAttributeProductId = dr["attributeProductVariableAttributeProductId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["attributeProductVariableAttributeProductId"]),
                    AttributeProductName = dr["attributeProductName"] == DBNull.Value ? string.Empty : dr["attributeProductName"].ToString()!,
                    AttributeProductVariableValue = dr["attributeProductVariableValue"] == DBNull.Value ? string.Empty : dr["attributeProductVariableValue"].ToString()!,
                    AttributeProductVariableCreatorId = dr["attributeProductVariableCreatorId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["attributeProductVariableCreatorId"]),
                    AttributeProductVariableCreationDate = dr["attributeProductVariableCreationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dr["attributeProductVariableCreationDate"]),
                    AttributeProductVariableModificatorId = dr["attributeProductVariableModificatorId"] == DBNull.Value ? null : Convert.ToInt32(dr["attributeProductVariableModificatorId"]),
                    AttributeProductVariableModificationDate = dr["attributeProductVariableModificationDate"] == DBNull.Value ? null : Convert.ToDateTime(dr["attributeProductVariableModificationDate"])
                });
            }
            return lista;
        }

        // --- FUNCIÓN DE INSERTAR ---
        public async Task<MensajeDTOs> Insert_AttributeProductVariables(AttributeProductVariable_Insert_DTO create)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Insert_AttributeProductVariables]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableProductVariableId", create.ProductVariableId));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableAttributeProductId", create.AttributeProductId));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableValue", create.Value ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableCreatorId", create.CreatorId));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableCreationDate", (object)create.CreationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString()!;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        // --- FUNCIÓN DE ACTUALIZAR ---
        public async Task<MensajeDTOs> Update_AttributeProductVariables(AttributeProductVariable_Update_DTO update)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Update_AttributeProductVariables]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableId", update.Id));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableProductVariableId", update.ProductVariableId));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableAttributeProductId", update.AttributeProductId));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableValue", update.Value ?? (object)DBNull.Value));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableModificatorId", update.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableModificationDate", (object)update.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString()!;
                respuesta.Resultado = OutResultado.Value == DBNull.Value ? 0 : Convert.ToInt32(OutResultado.Value);
            }
            catch (SqlException ex)
            {
                respuesta.Resultado = 500;
                respuesta.Messaje = ex.Message;
            }
            return respuesta;
        }

        // --- FUNCIÓN DE ELIMINAR ---
        public async Task<MensajeDTOs> Delete_AttributeProductVariables(AttributeProductVariable_Delete_DTO delete)
        {
            MensajeDTOs respuesta = new();
            try
            {
                using var con = _connection.CreateConetion();
                await con.OpenAsync();

                using SqlCommand cmd = new("[SQM_GENERAL].[Delete_AttributeProductVariables]", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableId", delete.Id));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableModificatorId", delete.ModificatorId));
                cmd.Parameters.Add(new SqlParameter("@attributeProductVariableModificationDate", (object)delete.ModificationDate ?? DBNull.Value));

                SqlParameter OutMensaje = new("@Mensaje", SqlDbType.VarChar, 250) { Direction = ParameterDirection.Output };
                SqlParameter OutResultado = new("@Resultado", SqlDbType.Int) { Direction = ParameterDirection.Output };

                cmd.Parameters.Add(OutMensaje);
                cmd.Parameters.Add(OutResultado);

                await cmd.ExecuteNonQueryAsync();

                respuesta.Messaje = OutMensaje.Value == DBNull.Value ? string.Empty : OutMensaje.Value.ToString()!;
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
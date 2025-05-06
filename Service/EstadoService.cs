using BD.AppWeb.Data;
using BD.AppWeb.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace BD.AppWeb.Service
{
    public class EstadoService
    {
        private readonly AppDBContext _dbContext;

        public EstadoService(AppDBContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task InsertarEstadoAsync(Estado pEstado)
        {
            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_InsertarEstado";
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@Nombre", pEstado.Nombre));

                    try
                    {
                        await command.ExecuteNonQueryAsync();
                    }
                    catch (SqlException ex)
                    {
                        Console.WriteLine($"Error de SQL al insertar estado: {ex.Message}");
                        throw;
                    }
                }
            }
        }

        public async Task<List<Estado>> ObtenerEstadosAsync()
        {
            var estados = new List<Estado>();

            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_ObtenerEstados";
                    command.CommandType = System.Data.CommandType.StoredProcedure;

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            var estado = new Estado
                            {
                                IdEstado = reader.GetInt32(reader.GetOrdinal("Código")), 
                                Nombre = reader.GetString(reader.GetOrdinal("Nombre"))
                            };
                            estados.Add(estado);
                        }
                    }
                }
            }

            return estados;
        }

      

        public async Task<Estado> ObtenerEstadoPorIdAsync(Estado pEstado)
        {
            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_ObtenerEstadoPorId";
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@IdEstado", pEstado.IdEstado));

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            var estado = new Estado
                            {
                                IdEstado = reader.GetInt32(reader.GetOrdinal("Código")), 
                                Nombre = reader.GetString(reader.GetOrdinal("Nombre"))
                            };
                            return estado;
                        }
                        else
                        {
                            return null;
                        }
                    }
                }
            }
        }
    }
}

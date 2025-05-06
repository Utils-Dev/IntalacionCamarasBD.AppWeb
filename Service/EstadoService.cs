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
            Console.WriteLine("CONEXIÓN ESTADO: " + dbContext.Database.GetConnectionString());
            _dbContext = dbContext;
        }

        public async Task InsertarEstadoAsync(Estado pEstado)
        {
            var connectionString = _dbContext.Database.GetConnectionString(); // Get the connection string
            using (var connection = new SqlConnection(connectionString)) // Initialize SqlConnection with the string
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
            var connectionString = _dbContext.Database.GetConnectionString(); // Get the connection string

            try
            {
                using (var connection = new SqlConnection(connectionString)) // Initialize SqlConnection with the string
                {
                    if (connection.State == System.Data.ConnectionState.Closed)
                    {
                        await connection.OpenAsync();
                    }

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
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener estados: {ex.Message}");
                throw;
            }

            return estados;
        }



        public async Task<Estado> ObtenerEstadoPorIdAsync(Estado pEstado)
        {
            var connectionString = _dbContext.Database.GetConnectionString(); // Get the connection string
            using (var connection = new SqlConnection(connectionString)) // Initialize SqlConnection with the string
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

        public async Task<bool> ModificarEstadoAsync(Estado pEstado)
        {
            var connectionString = _dbContext.Database.GetConnectionString(); // Get the connection string
            using (var connection = new SqlConnection(connectionString)) // Initialize SqlConnection with the string
            {
                await connection.OpenAsync();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_ActualizarEstado";
                    command.CommandType = System.Data.CommandType.StoredProcedure;

                    command.Parameters.Add(new SqlParameter("@IdEstado", pEstado.IdEstado));
                    command.Parameters.Add(new SqlParameter("@NuevoNombre", pEstado.Nombre));

                    var filasAfectadas = await command.ExecuteNonQueryAsync();

                    return filasAfectadas > 0;
                }
            }
        }
        public async Task<bool> EliminarEstadoAsync(int idEstado)
        {
            var connectionString = _dbContext.Database.GetConnectionString(); // Get the connection string
            using (var connection = new SqlConnection(connectionString)) // Initialize SqlConnection with the string
            {
                await connection.OpenAsync();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_EliminarEstado";
                    command.CommandType = System.Data.CommandType.StoredProcedure;

                    command.Parameters.Add(new SqlParameter("@IdEstado", idEstado));

                    var filasAfectadas = await command.ExecuteNonQueryAsync();

                    return filasAfectadas > 0;
                }
            }
        }
    }
}
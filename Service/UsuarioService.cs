using BD.AppWeb.Data;
using BD.AppWeb.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace BD.AppWeb.Service
{
    public class UsuarioService
    {
        private readonly AppDBContext _dbContext;

        public UsuarioService(AppDBContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task InsertarUsuarioAsync(Usuario pUsuario)
        {
            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "RecursosHumanos.SP_InsertarUsuario";
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@Nombre", pUsuario.Nombre));
                    command.Parameters.Add(new SqlParameter("@Correo", pUsuario.Correo));
                    command.Parameters.Add(new SqlParameter("@Password", pUsuario.Password));
                    command.Parameters.Add(new SqlParameter("@IdRol", pUsuario.IdRol));
                    command.Parameters.Add(new SqlParameter("@IdEstado", pUsuario.IdEstado));

                    try
                    {
                        await command.ExecuteNonQueryAsync();
                    }
                    catch (SqlException ex)
                    {
                        Console.WriteLine($"Error de SQL al insertar usuario: {ex.Message}");
                        throw;
                    }
                }
            }
        }

        public async Task<List<Usuario>> ObtenerUsuariosPorEstadoAsync(byte estado)
        {
            var usuariosConEstado = new List<Usuario>();

            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "RecursosHumanos.SP_ObtenerUsuariosPorEstado";
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@Estado", estado));

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            var usuarioConEstado = new Usuario
                            {
                                IdUsuario = reader.GetInt32(reader.GetOrdinal("Código")),
                                Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                                Correo = reader.GetString(reader.GetOrdinal("Correo")),
                                IdRol = reader.GetInt32(reader.GetOrdinal("IdRol")),
                                FechaRegistro = reader.GetDateTime(reader.GetOrdinal("FechaRegistro")),
                                IdEstado = reader.GetByte(reader.GetOrdinal("IdEstado")),
                                Estado = new Estado
                                {
                                    Nombre = reader.GetString(reader.GetOrdinal("Estado"))
                                }
                            };
                            usuariosConEstado.Add(usuarioConEstado);
                        }
                    }
                }
            }

            return usuariosConEstado;
        }
    }
}

using BD.AppWeb.Data;
using BD.AppWeb.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace BD.AppWeb.Service
{
    public class UsuarioService
    {
        private readonly AppDBContext _dbContext;

        public UsuarioService(AppDBContext dbContext)
        {
            _dbContext = dbContext;
        }
        public async Task InsertarUsuarioAsync(Usuario usuario)
        {
            using var connection = _dbContext.Database.GetDbConnection();
            await connection.OpenAsync();

            using var command = connection.CreateCommand();
            command.CommandText = "RecursosHumanos.SP_InsertarUsuario";
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.Add(new SqlParameter("@Nombre", usuario.Nombre));
            command.Parameters.Add(new SqlParameter("@Correo", usuario.Correo));
            command.Parameters.Add(new SqlParameter("@Password", usuario.Password));
            command.Parameters.Add(new SqlParameter("@IdRol", usuario.IdRol));
            command.Parameters.Add(new SqlParameter("@IdEstado", usuario.IdEstado));

            await command.ExecuteNonQueryAsync();
        }
        public async Task ActualizarUsuarioAsync(Usuario usuario)
        {
            using var connection = _dbContext.Database.GetDbConnection();
            await connection.OpenAsync();

            using var command = connection.CreateCommand();
            command.CommandText = "RecursosHumanos.SP_ActualizarUsuario";
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.Add(new SqlParameter("@IdUsuario", usuario.IdUsuario));
            command.Parameters.Add(new SqlParameter("@NuevoNombre", usuario.Nombre));
            command.Parameters.Add(new SqlParameter("@NuevoCorreo", usuario.Correo));
            command.Parameters.Add(new SqlParameter("@NuevoPassword", usuario.Password));
            command.Parameters.Add(new SqlParameter("@NuevoIdRol", usuario.IdRol));
            command.Parameters.Add(new SqlParameter("@IdEstado", usuario.IdEstado));

            await command.ExecuteNonQueryAsync();
        }

        public async Task<Usuario?> ObtenerUsuarioPorIdAsync(int id)
        {
            using var connection = _dbContext.Database.GetDbConnection();
            await connection.OpenAsync();

            using var command = connection.CreateCommand();
            command.CommandText = "RecursosHumanos.SP_ObtenerUsuarioPorId";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@IdUsuario", id));

            using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                return new Usuario
                {
                    IdUsuario = reader.GetInt32(reader.GetOrdinal("Código")),
                    Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                    Correo = reader.GetString(reader.GetOrdinal("Correo")),
                    IdRol = reader.GetInt32(reader.GetOrdinal("IdRol")),
                    FechaRegistro = reader.GetDateTime(reader.GetOrdinal("FechaRegistro")),
                    Rol = new Rol { Nombre = reader.GetString(reader.GetOrdinal("Rol")) },
                    IdEstado = reader.GetInt32(reader.GetOrdinal("IdEstado")),
                    Estado = new Estado { Nombre = reader.GetString(reader.GetOrdinal("Estado")) }
                };
            }

            return null;
        }

        public async Task<List<Usuario>> ObtenerUsuariosPorEstadoAsync(int estado)
        {
            var usuarios = new List<Usuario>();

            using var connection = _dbContext.Database.GetDbConnection();
            await connection.OpenAsync();

            using var command = connection.CreateCommand();
            command.CommandText = "RecursosHumanos.SP_ObtenerUsuariosPorEstado";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@Estado", estado));

            using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                usuarios.Add(new Usuario
                {
                    IdUsuario = reader.GetInt32(reader.GetOrdinal("Código")),
                    Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                    Correo = reader.GetString(reader.GetOrdinal("Correo")),
                    IdRol = reader.GetInt32(reader.GetOrdinal("IdRol")),
                    Rol = new Rol { Nombre = reader.GetString(reader.GetOrdinal("Rol")) },
                    FechaRegistro = reader.GetDateTime(reader.GetOrdinal("FechaRegistro")),
                    IdEstado = reader.GetInt32(reader.GetOrdinal("IdEstado")),
                    Estado = new Estado { Nombre = reader.GetString(reader.GetOrdinal("Estado")) }
                });
            }

            return usuarios;
        }

    }
}

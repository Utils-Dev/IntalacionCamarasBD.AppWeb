using BD.AppWeb.Data;
using BD.AppWeb.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace BD.AppWeb.Service
{
    public class RolService
    {
        private readonly AppDBContext _dbContext;

        public RolService(AppDBContext dbContext)
        {
            _dbContext = dbContext;
        }
        public async Task<bool> InsertarRolAsync(Rol pRol)
        {
            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_InsertarRol";
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@Nombre", pRol.Nombre));

                    var filas = await command.ExecuteNonQueryAsync();
                    return filas > 0;
                }
            }
        }
        public async Task<bool> ActualizarRolAsync(Rol pRol)
        {
            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_ActualizarRol";
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@IdRol", pRol.IdRol));
                    command.Parameters.Add(new SqlParameter("@NuevoNombre", pRol.Nombre));

                    var filas = await command.ExecuteNonQueryAsync();
                    return filas > 0;
                }
            }
        }
        public async Task<List<Rol>> ObtenerRolesAsync()
        {
            var roles = new List<Rol>();

            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_ObtenerRoles";
                    command.CommandType = CommandType.StoredProcedure;

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            roles.Add(new Rol
                            {
                                IdRol = reader.GetInt32(reader.GetOrdinal("Código")),
                                Nombre = reader.GetString(reader.GetOrdinal("Nombre"))
                            });
                        }
                    }
                }
            }

            return roles;
        }
        public async Task<Rol?> ObtenerRolPorIdAsync(Rol pRol)
        {
            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_ObtenerRolPorId";
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@IdRol", pRol.IdRol));

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            return new Rol
                            {
                                IdRol = reader.GetInt32(reader.GetOrdinal("Código")),
                                Nombre = reader.GetString(reader.GetOrdinal("Nombre"))
                            };
                        }
                    }
                }
            }

            return null;
        }
        public async Task EliminarRolAsync(Rol pRol)
        {
            using (var connection = _dbContext.Database.GetDbConnection())
            {
                await connection.OpenAsync();

                using (var command = connection.CreateCommand())
                {
                    command.CommandText = "Configuracion.SP_EliminarRol";
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.Add(new SqlParameter("@IdRol", pRol.IdRol));

                    await command.ExecuteNonQueryAsync();
                }
            }
        }


    }
}

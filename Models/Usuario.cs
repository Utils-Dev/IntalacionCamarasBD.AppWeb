namespace BD.AppWeb.Models
{
    public class Usuario
    {
        public int IdUsuario { get; set; }
        public string Nombre { get; set; }
        public string Correo { get; set; }
        public string Password { get; set; }
        public int IdRol { get; set; }
        public DateTime FechaRegistro { get; set; }
        public int IdEstado { get; set; }
        public Estado Estado { get; set; }
        public Rol Rol { get; set; }

        public List<Rol> Roles { get; set; }
        public List<Estado> Estados { get; set; }

    }
}

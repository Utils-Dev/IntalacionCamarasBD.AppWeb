namespace BD.AppWeb.Models
{
    public class Empleado
    {
        public int IdEmpleado { get; set; }
        public string Nombre { get; set; }
        public string Telefono { get; set; }
        public string Correo { get; set; }
        public DateTime FechaContratacion { get; set; }
        public int IdUsuario { get; set; }
        public int IdEstado { get; set; }
    }
}

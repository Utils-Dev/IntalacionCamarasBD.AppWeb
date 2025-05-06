namespace BD.AppWeb.Models
{
    public class Cliente
    {
        public int IdCliente { get; set; }
        public string Nombre { get; set; }
        public string Telefono { get; set; }
        public string DUI { get; set; }
        public string Correo { get; set; }
        public DateTime FechaRegistro { get; set; }
        public DateTime FechaModificacion { get; set; }

        public int IdUsuarioModificacion { get; set; }
        public int IdEstado { get; set; }
    }
}

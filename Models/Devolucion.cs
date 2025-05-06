namespace BD.AppWeb.Models
{
    public class Devolucion
    {
        public int IdDevolucion { get; set; }
        public int IdVenta { get; set; }
        public int IdUsuario { get; set; }
        public DateTime FechaDevolucion { get; set; }
        public decimal TotalDevuelto { get; set; }
        public string Observaciones { get; set; }
        public int IdEstado { get; set; }

    }
}

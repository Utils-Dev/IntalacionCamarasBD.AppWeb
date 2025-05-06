namespace BD.AppWeb.Models
{
    public class Venta
    {
        public int IdVenta { get; set; }
        public int IdCliente { get; set; }
        public int IdUsuarioCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public DateTime FechaVenta { get; set; }
        public DateTime FechaModificacion { get; set; }
        public decimal Total { get; set; }
        public decimal IVA { get; set; }
        public int IdEstado { get; set; }

    }
}

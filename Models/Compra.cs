namespace BD.AppWeb.Models
{
    public class Compra
    {
        public int IdCompra { get; set; }
        public int IdUsuarioCreacion { get; set; }
        public int IdUsuarioModificacion { get; set; }
        public int IdProveedor { get; set; }
        public decimal IVA { get; set; }
        public DateTime Fecha { get; set; }
        public decimal Total { get; set; }
        public int IdEstado { get; set; }

    }
}

namespace BD.AppWeb.Models
{
    public class DetalleDevolucion
    {
        public int IdDetalleDevolucion { get; set; }
        public int IdDevolucion { get; set; }

        public int IdProducto { get; set; }
        public int IdServicio { get; set; }
        public int Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal SubTotal { get; set; }   
        public string Motivo { get; set; }
    }
}

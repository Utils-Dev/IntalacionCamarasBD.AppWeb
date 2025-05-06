namespace BD.AppWeb.Models
{
    public class CierreCaja
    {
        public int IdCierreCaja { get; set; }
        public int IdUsuario { get; set; }
        public DateTime FechaCierre { get; set; }
        public decimal TotalVentas { get; set; }
        public decimal TotalEfectivo { get; set; }
        public decimal TotalTarjeta { get; set; }

    }
}

using BD.AppWeb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace BD.AppWeb.Controllers
{
    public class CompraController : Controller
    {
        // GET: CompraController
        public ActionResult Index()
        {
            return View();
        }

        // GET: CompraController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: CompraController/Create
        public ActionResult Create()
        {
            var proveedoresDestacados = new List<Proveedor>()
            {
                new Proveedor { IdProveedor = -1, Nombre = "Proveedor Ejemplo 1 " },
                new Proveedor { IdProveedor = -2, Nombre = "Proveedor Ejemplo 2 " }
            };
            var productosEnOferta = new List<Producto>()
            {
                new Producto { IdProducto = 101, Nombre = "Producto Alfa ", Precio = 19.99m , Stock = 20},
                new Producto { IdProducto = 102, Nombre = "Producto Beta ", Precio = 29.99m , Stock = 20}
            };
            ViewBag.Proveedores = new SelectList(proveedoresDestacados, "IdProveedor", "Nombre");
            ViewBag.Productos = productosEnOferta;
            return View();
        }

        // POST: CompraController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: CompraController/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: CompraController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: CompraController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: CompraController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}

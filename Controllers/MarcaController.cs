using BD.AppWeb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace BD.AppWeb.Controllers
{
    public class MarcaController : Controller
    {
         private static List<Marca> marcaList = new List<Marca>
        {
            new Marca { IdMarca = 1, Nombre = "hp", IdEstado = 1 },
            new Marca { IdMarca = 2, Nombre = "Dell", IdEstado = 1 }
        };
        // GET: MarcaController
        public ActionResult Index()
        {
            return View( marcaList);
        }

        // GET: MarcaController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: MarcaController/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: MarcaController/Create
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

        // GET: MarcaController/Edit/5
        public ActionResult Edit(int id)
        {
            Marca marcaEncontrada = marcaList.FirstOrDefault(m => m.IdMarca == id);

            if (marcaEncontrada == null)
            {
                return NotFound(); 
            }

            return View(marcaEncontrada);
        }

        // POST: MarcaController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Marca pMarca)
        {
            try
            {
                Marca marcaOriginal = marcaList.FirstOrDefault(m => m.IdMarca == pMarca.IdMarca);

                if (marcaOriginal != null)
                {
                    marcaOriginal.Nombre = pMarca.Nombre;
                    marcaOriginal.IdEstado = pMarca.IdEstado;
                }

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: MarcaController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: MarcaController/Delete/5
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

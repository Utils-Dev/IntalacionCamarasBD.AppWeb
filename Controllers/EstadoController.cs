using BD.AppWeb.Models;
using BD.AppWeb.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace BD.AppWeb.Controllers
{
    public class EstadoController : Controller
    {
        private readonly EstadoService _estadoService;

        public EstadoController(EstadoService estadoService)
        {
            _estadoService = estadoService;
        }
        // GET: EstadoController
        public async Task<ActionResult> Index()
        {
            var lista = await _estadoService.ObtenerEstadosAsync();
            return View(lista);
        }

        // GET: EstadoController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: EstadoController/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: EstadoController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create(Estado pEstado)
        {
            try
            {
                
                await _estadoService.InsertarEstadoAsync(pEstado);
                TempData["Mensaje"] = "Estado registrado correctamente!";
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: EstadoController/Edit/5
        public async Task<ActionResult> Edit(int pId)
        {
            var estado = await _estadoService.ObtenerEstadoPorIdAsync(new Estado { IdEstado = pId});
            return View(estado);
        }

        // POST: EstadoController/Edit/5
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

        // GET: EstadoController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: EstadoController/Delete/5
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

using BD.AppWeb.Models;
using BD.AppWeb.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BD.AppWeb.Controllers
{
    public class RolController : Controller
    {
        private readonly RolService _rolService;

        public RolController(RolService rolService)
        {
            _rolService = rolService;
        }
        // GET: RolController
        public async Task<ActionResult> Index()
        {
            var lista = await _rolService.ObtenerRolesAsync();
            return View(lista);
        }

        // GET: RolController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: RolController/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: RolController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create(Rol pRol)
        {
            try
            {
                await _rolService.InsertarRolAsync(pRol);
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View(pRol);
            }
        }

        // GET: RolController/Edit/5
        public async Task<ActionResult> Edit(int pId)
        {
            var estado = await _rolService.ObtenerRolPorIdAsync(new Rol { IdRol = pId });
            return View(estado);
        }

        // POST: RolController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit(Rol pRol)
        {
            try
            {
                await _rolService.ActualizarRolAsync(pRol);
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: RolController/Delete/5
        public async Task<ActionResult> Delete(int id)
        {
            var estado = await _rolService.ObtenerRolPorIdAsync(new Rol { IdRol = id });

            return View(estado);
        }

        // POST: RolController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Delete(Rol pRol)
        {
            try
            {
                await _rolService.EliminarRolAsync(pRol);

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View(pRol);
            }
        }
    }
}

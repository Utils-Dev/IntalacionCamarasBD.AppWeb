using BD.AppWeb.Models;
using BD.AppWeb.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Data;

namespace BD.AppWeb.Controllers
{
    public class UsuarioController : Controller
    {
        private readonly UsuarioService _usuarioService;
        private readonly EstadoService _estadoService;
        private readonly RolService _roleService;

        public UsuarioController(UsuarioService usuarioService, EstadoService  estadoService , RolService roleService)
        {
            _usuarioService = usuarioService;
            _roleService = roleService;
            _estadoService = estadoService;

        }
        // GET: UsuarioController
        public async Task<ActionResult> Index(byte estado)
        {
            var lista = await _usuarioService.ObtenerUsuariosPorEstadoAsync(estado);
            ViewBag.Estados = await _estadoService.ObtenerEstadosAsync();

            return View(lista);
        }

        // GET: UsuarioController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: UsuarioController/Create
        public async Task<ActionResult> Create()
        {
            ViewBag.Roles = await _roleService.ObtenerRolesAsync();
            ViewBag.Estados = await _estadoService.ObtenerEstadosAsync();

            return View();
        }

        // POST: UsuarioController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async  Task<ActionResult> Create(Usuario pUsuario)
        {
            try
            {
                await _usuarioService.InsertarUsuarioAsync(pUsuario);
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: UsuarioController/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: UsuarioController/Edit/5
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

        // GET: UsuarioController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: UsuarioController/Delete/5
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

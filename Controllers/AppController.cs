using System;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Veterinary_clinic.DB;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;
using System.Collections.Generic;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
namespace Veterinary_clinic.Controllers
{
    public class AppController : Controller
    {
        private readonly ClinicContext _context;

        public AppController(ClinicContext context)
        {
            _context = context;
        }
        public async Task<IActionResult> IndexAsync()
        {
            int id = (int)HttpContext.Session.GetInt32("id");
            var data = await _context.Apps.FromSqlRaw("[AppointmentsForClient] @client", new SqlParameter("@client", id)).ToListAsync();
            return View(data);
        }
     /*   public IActionResult Edit(int? id)
        {
            return RedirectToAction("edit", "Appointments" , new { id = id });
        }*/
        public async Task<IActionResult> Details(int? id)
        {
           
           int idClient = (int)HttpContext.Session.GetInt32("id");
            var data = await _context.Apps.FromSqlRaw("[AppointmentsForClient] @client", new SqlParameter("@client", idClient)).ToListAsync();
           foreach(var a in data)
           {
                if (a.appointment_id == id)
                {
                    return View(a);
                }
           }
            return View();
        }
     /*   public IActionResult Create()
        {
            return RedirectToAction("create", "Appointments");
        }*/

        public IActionResult Delete(int? id)
        {


            return RedirectToAction("delete", "Appointments", new { id = id });
        }
        public IActionResult Back()
        {
            return RedirectToAction("index", "User");
        }

    }
}

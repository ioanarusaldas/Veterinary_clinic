using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;

namespace Veterinary_clinic.Controllers
{
    public class UserController : Controller
    {

  
        public IActionResult Index(string username)
        {
            if(username != null)
                HttpContext.Session.SetString("name", username);
            return View();
        }
        public IActionResult Appointments(string username)
        {
            return RedirectToAction("index", "App" );
        }
        public IActionResult Animals(string username)
        {
            return RedirectToAction("index", "Animals");
        }
        public IActionResult MakeAppointment(string username)
        {

            return RedirectToAction("index", "ServiceView");
        }
        public IActionResult History()
        {
            return RedirectToAction("index", "AppointmentsHistories");
        }
        public IActionResult Frequence()
        {
            return RedirectToAction("index", "DoctorFreq");
        }

    }
}

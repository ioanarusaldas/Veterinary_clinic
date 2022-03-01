using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Veterinary_clinic.DB;
using Veterinary_clinic.Models;


namespace Veterinary_clinic.Controllers
{
    public class ServiceViewController : Controller
    {
        private readonly ClinicContext _context;

        public ServiceViewController(ClinicContext context)
        {
            _context = context;
        }
        public IActionResult Index() {
            var result = from a in _context.Services
                         join b in _context.Doctors on a.DoctorId equals b.DoctorId
                         select new
                         {
                             id = a.ServiceId,
                             c = a.Name,
                             d = b.FirstName + ' ' + b.LastName
                         };
            List<ViewServiceModel> data = new List<ViewServiceModel>();
            foreach (var r in result) {
                ViewServiceModel model = new ViewServiceModel();
                model.ServiceId = r.id;
                model.DoctorName = r.d;
                model.ServiceName = r.c;
                data.Add(model);
             }

            return View(data);
        }
        public IActionResult Select(int? id)
        {
            return RedirectToAction("create", "Appointments", new { id = id });
        }
        public IActionResult Back()
        {


            return RedirectToAction("index", "User");
        }
    }
}


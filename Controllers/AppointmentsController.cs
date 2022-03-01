using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Veterinary_clinic.DB;
using Microsoft.AspNetCore.Http;

namespace Veterinary_clinic.Controllers
{
    public class AppointmentsController : Controller
    {
        private readonly ClinicContext _context;

        public AppointmentsController(ClinicContext context)
        {
            _context = context;
        }

        // GET: Appointments
        public IActionResult Index(int? id)
        {
            return RedirectToAction("index", "App");
        }
        public IActionResult Back()
        {

            return RedirectToAction("index", "ServiceView");
        }

        // GET: Appointments/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var appointment = await _context.Appointments
                .Include(a => a.Animal)
                .FirstOrDefaultAsync(m => m.AppointmentId == id);
            if (appointment == null)
            {
                return NotFound();
            }

            return View(appointment);
        }

        // GET: Appointments/Create
        public IActionResult Create(int? id)
        {
            Console.WriteLine(id);
            int clientId = (int)HttpContext.Session.GetInt32("id");
            var data = (from a in _context.Animals
                        where a.ClientId == clientId
                        select new
                        {
                            a.Name,
                            a.AnimalId
                        }).ToList();
            ViewData["AnimalId"] = new SelectList(data.Select(t => t.Name));
            return View();
        }
 
        public int appForDoctor(int doctorId, DateTime date)
        {

            SqlParameter doctor = new SqlParameter();
            doctor.ParameterName = "@doctor_id";
            doctor.SqlDbType = SqlDbType.Int;
            doctor.Value = doctorId;

            SqlParameter date2 = new SqlParameter();
            date2.ParameterName = "@date";
            date2.Value = date;
            date2.SqlDbType = SqlDbType.DateTime;

            SqlParameter count = new SqlParameter();
            count.Value = 0;
            count.ParameterName = "@count";
            count.SqlDbType = SqlDbType.Int;
            count.Direction = ParameterDirection.Output;

            _context.Database.ExecuteSqlRaw("EXEC [dbo].[Appointments_Doctor] @doctor_id, @date, @count OUTPUT ", doctor, date2, count);
            return Convert.ToInt32(count.Value);
        }

        // POST: Appointments/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(int id, DateTime Data, String AnimalId)
        {
            int clientId = (int)HttpContext.Session.GetInt32("id");
            var data = (from a in _context.Animals
                        where a.ClientId == clientId
                        select new
                        {
                            a.Name,
                            a.AnimalId
                        }).ToList();
            ViewData["AnimalId"] = new SelectList(data.Select(t => t.Name));
            var animal = (from a in _context.Animals
                        where a.Name == AnimalId
                        select new
                        {
                            a.AnimalId
                        }).ToList().FirstOrDefault();
            var appointment = new Appointment();
            int doctor = (int)_context.Services.Where(m => m.ServiceId == id).Select(m => m.DoctorId).FirstOrDefault();
            if (ModelState.IsValid)
            {
                appointment.ServiceId = id;
                appointment.AnimalId = Convert.ToInt32(animal.AnimalId);
                appointment.Data = Data;
                if (appForDoctor(doctor, Data) >= 5)
                {
                   ViewData["msg"] = "Acest doctor are prea multe programari. Alegeti alt doctor sau alta zi";
                    return View("Create");
                }
                _context.Add(appointment);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View();
        }

        // GET: Appointments/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var appointment = await _context.Appointments.FindAsync(id);
            if (appointment == null)
            {
                return NotFound();
            }
            ViewData["AnimalId"] = new SelectList(_context.Set<Animal>(), "AnimalId", "AnimalId", appointment.AnimalId);
            return View(appointment);
        }

        // POST: Appointments/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("AppointmentId,Data,ServiceId,AnimalId")] Appointment appointment)
        {
            if (id != appointment.AppointmentId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(appointment);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!AppointmentExists(appointment.AppointmentId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["AnimalId"] = new SelectList(_context.Set<Animal>(), "AnimalId", "AnimalId", appointment.AnimalId);
            return View(appointment);
        }

        // GET: Appointments/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var appointment = await _context.Appointments
                .Include(a => a.Animal)
                .FirstOrDefaultAsync(m => m.AppointmentId == id);
            if (appointment == null)
            {
                return NotFound();
            }

            return View(appointment);
        }

        // POST: Appointments/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var appointment = await _context.Appointments.FindAsync(id);
            _context.Appointments.Remove(appointment);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool AppointmentExists(int id)
        {
            return _context.Appointments.Any(e => e.AppointmentId == id);
        }
    }
}

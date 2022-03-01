using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Veterinary_clinic.DB;

namespace Veterinary_clinic.Controllers
{
    public class AppointmentsHistoriesController : Controller
    {
        private readonly ClinicContext _context;

        public AppointmentsHistoriesController(ClinicContext context)
        {
            _context = context;
        }

        // GET: AppointmentsHistories
        public async Task<IActionResult> Index()
        {
            int idClient = (int)HttpContext.Session.GetInt32("id");
            return View(await _context.AppointmentsHistories.Where(h => h.ClientId == idClient).ToListAsync());
        }
        public IActionResult Back()
        {
            return RedirectToAction("index", "User");
        }
        // GET: AppointmentsHistories/Details/5
      /*  public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var appointmentsHistory = await _context.AppointmentsHistories
                .FirstOrDefaultAsync(m => m.Id == id);
            if (appointmentsHistory == null)
            {
                return NotFound();
            }

            return View(appointmentsHistory);
        }

        // GET: AppointmentsHistories/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: AppointmentsHistories/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,ClientId,Date,AnimalName,Service,DoctorName")] AppointmentsHistory appointmentsHistory)
        {
            if (ModelState.IsValid)
            {
                _context.Add(appointmentsHistory);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(appointmentsHistory);
        }

        // GET: AppointmentsHistories/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var appointmentsHistory = await _context.AppointmentsHistories.FindAsync(id);
            if (appointmentsHistory == null)
            {
                return NotFound();
            }
            return View(appointmentsHistory);
        }

        // POST: AppointmentsHistories/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,ClientId,Date,AnimalName,Service,DoctorName")] AppointmentsHistory appointmentsHistory)
        {
            if (id != appointmentsHistory.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(appointmentsHistory);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!AppointmentsHistoryExists(appointmentsHistory.Id))
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
            return View(appointmentsHistory);
        }

        // GET: AppointmentsHistories/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var appointmentsHistory = await _context.AppointmentsHistories
                .FirstOrDefaultAsync(m => m.Id == id);
            if (appointmentsHistory == null)
            {
                return NotFound();
            }

            return View(appointmentsHistory);
        }

        // POST: AppointmentsHistories/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var appointmentsHistory = await _context.AppointmentsHistories.FindAsync(id);
            _context.AppointmentsHistories.Remove(appointmentsHistory);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
*/
        private bool AppointmentsHistoryExists(int id)
        {
            return _context.AppointmentsHistories.Any(e => e.Id == id);
        }
    }
}

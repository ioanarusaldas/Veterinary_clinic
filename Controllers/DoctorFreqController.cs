 using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Veterinary_clinic.DB;
using Veterinary_clinic.Models;

namespace Veterinary_clinic.Controllers
{
    public class DoctorFreqController : Controller
    {
        private readonly ClinicContext _context;

        public DoctorFreqController(ClinicContext context)
        {
            _context = context;
        }

        // GET: DoctorFreq
        public async Task<IActionResult> Index()
        {
            int id = (int)HttpContext.Session.GetInt32("id");
            var data =  _context.DoctorFreq.FromSqlInterpolated($"SELECT * FROM [dbo].[DoctorsFrequence] ({id})");
            return View(await data.ToListAsync());
        }
        public IActionResult Back()
        {

            return RedirectToAction("index", "User");
        }

        // GET: DoctorFreq/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var doctorFreq = await _context.DoctorFreq
                .FirstOrDefaultAsync(m => m.Doctor_name == id);
            if (doctorFreq == null)
            {
                return NotFound();
            }

            return View(doctorFreq);
        }

        // GET: DoctorFreq/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: DoctorFreq/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Doctor_name,Freq")] DoctorFreq doctorFreq)
        {
            if (ModelState.IsValid)
            {
                _context.Add(doctorFreq);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(doctorFreq);
        }

        // GET: DoctorFreq/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var doctorFreq = await _context.DoctorFreq.FindAsync(id);
            if (doctorFreq == null)
            {
                return NotFound();
            }
            return View(doctorFreq);
        }

        // POST: DoctorFreq/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("Doctor_name,Freq")] DoctorFreq doctorFreq)
        {
            if (id != doctorFreq.Doctor_name)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(doctorFreq);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!DoctorFreqExists(doctorFreq.Doctor_name))
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
            return View(doctorFreq);
        }

        // GET: DoctorFreq/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var doctorFreq = await _context.DoctorFreq
                .FirstOrDefaultAsync(m => m.Doctor_name == id);
            if (doctorFreq == null)
            {
                return NotFound();
            }

            return View(doctorFreq);
        }

        // POST: DoctorFreq/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var doctorFreq = await _context.DoctorFreq.FindAsync(id);
            _context.DoctorFreq.Remove(doctorFreq);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool DoctorFreqExists(string id)
        {
            return _context.DoctorFreq.Any(e => e.Doctor_name == id);
        }
    }
}

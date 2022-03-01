using System;
using System.Collections.Generic;
using System.Data;
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
    public class LoginController : Controller
    {
       
        private readonly ClinicContext _context;

        public LoginController(ClinicContext context)
        {
            _context = context;
        }

        // GET: Login
        public IActionResult Index()
        {

            return View();
        }
        [HttpPost]
        public IActionResult Index([Bind] LoginCred ad)
        {
            int res = LoginCheck(ad); 
            if (res==1)
            {
                HttpContext.Session.SetString("name", ad.Admin_id);
                HttpContext.Session.SetInt32("id", getId(ad.Admin_id));
                return RedirectToAction("index", "User", new { username = ad.Admin_id});
            }
            else
            {
                TempData["msg"] = "Admin id or Password is wrong.!";
            }
            return View();
        }
        public int LoginCheck(LoginCred ad)
        {

            SqlParameter  d = new SqlParameter();
            d.ParameterName = "@Isvalid";
            d.Direction = ParameterDirection.Output;
            d.SqlDbType = SqlDbType.Bit;
            d.Value = 0;

            SqlParameter username = new SqlParameter();
            username.ParameterName = "@Admin_id";
            username.Value = ad.Admin_id;
            username.SqlDbType = SqlDbType.VarChar;

            SqlParameter password = new SqlParameter();
            password.Value = ad.Ad_Password;
            password.ParameterName = "@Password";
            password.SqlDbType = SqlDbType.VarChar;

            _context.Database.ExecuteSqlRaw("EXEC [dbo].[Sp_Login] @Admin_id, @Password, @Isvalid OUTPUT ", username,password,d);
            return Convert.ToInt32(d.Value);
        }
        public int getId(String username)
        {

            SqlParameter user = new SqlParameter();
            user.ParameterName = "@username";
            user.Value = username;
            var data = _context.BasicIntDto.FromSqlRaw("SELECT [dbo].[getClientId](@username) AS id", user).FirstOrDefault();
          
            int res = Convert.ToInt32(data.id);
            return res;
        }
   
    
        // GET: Login/Details/5
      /*  public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var login = await _context.Logins
                .FirstOrDefaultAsync(m => m.LoginId == id);
            if (login == null)
            {
                return NotFound();
            }

            return View(login);
        }*/

        // GET: Login/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Login/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("LoginId,Username,Password")] Login login)
        {
            if (ModelState.IsValid)
            {
                _context.Add(login);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(login);
        }

     /*   // GET: Login/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var login = await _context.Logins.FindAsync(id);
            if (login == null)
            {
                return NotFound();
            }
            return View(login);
        }

        // POST: Login/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("LoginId,Username,Password")] Login login)
        {
            if (id != login.LoginId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(login);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!LoginExists(login.LoginId))
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
            return View(login);
        }

        // GET: Login/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var login = await _context.Logins
                .FirstOrDefaultAsync(m => m.LoginId == id);
            if (login == null)
            {
                return NotFound();
            }

            return View(login);
        }

        // POST: Login/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var login = await _context.Logins.FindAsync(id);
            _context.Logins.Remove(login);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool LoginExists(int id)
        {
            return _context.Logins.Any(e => e.LoginId == id);
        }*/
    }
}

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Veterinary_clinic.DB;
using Veterinary_clinic.Models;

namespace Veterinary_clinic.Controllers
{
    public class SignUPController : Controller
    {
   
        private readonly ClinicContext _context;

        public SignUPController(ClinicContext context)
        {
            _context = context;
        }

        // GET:
        public IActionResult Index()
        {
            return View();
        }
        public String UsernameCheck(Login login)
        {

            SqlParameter error = new SqlParameter("@error",SqlDbType.VarChar,50);
            error.Direction = ParameterDirection.Output;
            error.Value = "";

            SqlParameter username = new SqlParameter();
            username.ParameterName = "@username";
            username.Value = login.Username;
            username.SqlDbType = SqlDbType.VarChar;

            SqlParameter password = new SqlParameter();
            password.Value = login.Password;
            password.ParameterName = "@password";
            password.SqlDbType = SqlDbType.VarChar;

            _context.Database.ExecuteSqlRaw("EXEC [dbo].[SignUP] @username, @password, @error OUTPUT ", username, password, error);
            return Convert.ToString(error.Value);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create([Bind("LoginId,Username,Password")] Login login)
        {
            if (ModelState.IsValid)
            {
                String error = UsernameCheck(login);
                if (error.Equals(""))
                    return RedirectToAction("create", "clients");
                TempData["username"] = error;

            }
            return View("index");
        }
    }
}

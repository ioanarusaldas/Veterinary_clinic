using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace Veterinary_clinic.DB
{
    public class App
    {
        [Key]
        public int appointment_id { get; set; }
        public String animal_name { get; set; }
        public DateTime data { get; set; }
        public String service { get; set; }
        public String doctor_name { get; set; }
    }
}
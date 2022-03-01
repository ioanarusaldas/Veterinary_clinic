using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Veterinary_clinic.Models
{
    public class DoctorFreq
    {
        [Key]
        public string Doctor_name { get; set; }
        public int Freq { get; set; }
    }
}

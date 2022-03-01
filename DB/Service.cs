using System;
using System.Collections.Generic;

#nullable disable

namespace Veterinary_clinic.DB
{
    public partial class Service
    {
        public int ServiceId { get; set; }
        public string Name { get; set; }
        public int? DoctorId { get; set; }

        public virtual Doctor Doctor { get; set; }
    }
}

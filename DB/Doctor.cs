using System;
using System.Collections.Generic;

#nullable disable

namespace Veterinary_clinic.DB
{
    public partial class Doctor
    {
        public Doctor()
        {
            Services = new HashSet<Service>();
        }

        public int DoctorId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Specialization { get; set; }

        public virtual ICollection<Service> Services { get; set; }
    }
}

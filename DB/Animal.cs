using System;
using System.Collections.Generic;

#nullable disable

namespace Veterinary_clinic.DB
{
    public partial class Animal
    {
        public Animal()
        {
            Appointments = new HashSet<Appointment>();
        }

        public int AnimalId { get; set; }
        public string Name { get; set; }
        public int? Age { get; set; }
        public double? Height { get; set; }
        public double? Weight { get; set; }
        public int ClientId { get; set; }

        public virtual Client Client { get; set; }
        public virtual ICollection<Appointment> Appointments { get; set; }
    }
}

using System;
using System.Collections.Generic;

#nullable disable

namespace Veterinary_clinic.DB
{
    public partial class Appointment
    {
        public int AppointmentId { get; set; }
        public DateTime Data { get; set; }
        public int ServiceId { get; set; }
        public int AnimalId { get; set; }

        public virtual Animal Animal { get; set; }
    }
}

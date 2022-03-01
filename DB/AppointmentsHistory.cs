using System;
using System.Collections.Generic;

#nullable disable

namespace Veterinary_clinic.DB
{
    public partial class AppointmentsHistory
    {
        public int Id { get; set; }
        public int ClientId { get; set; }
        public DateTime Date { get; set; }
        public string AnimalName { get; set; }
        public string Service { get; set; }
        public string DoctorName { get; set; }
    }
}

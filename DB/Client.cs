using System;
using System.Collections.Generic;

#nullable disable

namespace Veterinary_clinic.DB
{
    public partial class Client
    {
        public Client()
        {
            Animals = new HashSet<Animal>();
        }

        public int ClientId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Cnp { get; set; }
        public int LoginId { get; set; }

        public virtual Login Login { get; set; }
        public virtual ICollection<Animal> Animals { get; set; }
    }
}

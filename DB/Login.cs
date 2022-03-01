using System;
using System.Collections.Generic;

#nullable disable

namespace Veterinary_clinic.DB
{
    public partial class Login
    {
        public Login()
        {
            Clients = new HashSet<Client>();
        }

        public int LoginId { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }

        public virtual ICollection<Client> Clients { get; set; }
    }
}

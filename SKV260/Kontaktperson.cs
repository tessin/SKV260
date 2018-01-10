using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SKV260
{
    public class Kontaktperson
    {
        /// <summary>
        /// Namn på kontaktperson (kan finnas flera) för specifik uppgiftslämnare
        /// </summary>
        [MaxLength(50)]
        public string Namn { get; set; }

        /// <summary>
        /// Telefon till kontaktperson för specifik uppgiftslämnare
        /// </summary>
        [MaxLength(20)]
        public string Telefon { get; set; }

        /// <summary>
        /// e-postadress till kontaktperson för specifik uppgiftslämnare
        /// </summary>
        [MaxLength(256), EmailAddress]
        public string Epostadress { get; set; }

        /// <summary>
        /// Sakområde för viss kontaktperson  för specifik uppgiftslämnare
        /// </summary>
        [MaxLength(50)]
        public string Sakomrade { get; set; }
    }
}

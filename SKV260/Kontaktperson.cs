using System.ComponentModel.DataAnnotations;

namespace SKV260
{
    public class Kontaktperson
    {
        public Text _namn;
        public Text _telefon;
        public Text _epostadress;
        public Text _sakomrade;

        /// <summary>
        /// Namn på kontaktperson (kan finnas flera) för specifik uppgiftslämnare
        /// </summary>
        [MaxLength(50)]
        public string Namn { get { return _namn; } set { _namn = value; } }

        /// <summary>
        /// Telefon till kontaktperson för specifik uppgiftslämnare
        /// </summary>
        [MaxLength(20)]
        public string Telefon { get { return _telefon; } set { _telefon = value; } }

        /// <summary>
        /// e-postadress till kontaktperson för specifik uppgiftslämnare
        /// </summary>
        [MaxLength(256), EmailAddress]
        public string Epostadress { get { return _epostadress; } set { _epostadress = value; } }

        /// <summary>
        /// Sakområde för viss kontaktperson  för specifik uppgiftslämnare
        /// </summary>
        [MaxLength(50)]
        public string Sakomrade { get { return _sakomrade; } set { _sakomrade = value; } }
    }
}

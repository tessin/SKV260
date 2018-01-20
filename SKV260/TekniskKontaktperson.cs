using System.ComponentModel.DataAnnotations;

namespace SKV260
{
    public class TekniskKontaktperson
    {
        public Text _namn;
        public Text _telefon;
        public Text _epostadress;
        public Text _utdelningsadress1;
        public Text _utdelningsadress2;
        public Text _postnummer;
        public Text _postort;

        /// <summary>
        /// Namn på kontaktperson hos filleverantören
        /// </summary>
        [Required, MaxLength(50)]
        public string Namn { get { return _namn; } set { _namn = value; } }

        /// <summary>
        /// Telefon till kontaktperson hos filleverantören
        /// </summary>
        [Required, MaxLength(20)]
        public string Telefon { get { return _telefon; } set { _telefon = value; } }

        /// <summary>
        /// E-postadress till kontaktperson hos filleverantören
        /// </summary>
        [Required, MaxLength(256), EmailAddress]
        public string Epostadress { get { return _epostadress; } set { _epostadress = value; } }

        // nedanstående fält är inte obligatoriska

        /// <summary>
        /// Gatuadress 1 till företaget som levererar filen
        /// </summary>
        [MaxLength(50)]
        public string Utdelningsadress1 { get { return _utdelningsadress1; } set { _utdelningsadress1 = value; } }

        /// <summary>
        /// Gatuadress 2 till företaget som levererar filen
        /// </summary>
        [MaxLength(50)]
        public string Utdelningsadress2 { get { return _utdelningsadress2; } set { _utdelningsadress2 = value; } }

        /// <summary>
        /// Postnummer till företaget som levererar filen
        /// </summary>
        [MinLength(1), MaxLength(9)]
        public string Postnummer { get { return _postnummer; } set { _postnummer = value; } }

        /// <summary>
        /// Postort till företaget som levererar filen
        /// </summary>
        [MinLength(1), MaxLength(30)]
        public string Postort { get { return _postort; } set { _postort = value; } }
    }
}

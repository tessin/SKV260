using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SKV260
{
    public class TekniskKontaktperson
    {
        /// <summary>
        /// Namn på kontaktperson hos filleverantören
        /// </summary>
        [Required, MaxLength(50)]
        public string Namn { get; set; }

        /// <summary>
        /// Telefon till kontaktperson hos filleverantören
        /// </summary>
        [Required, MaxLength(20)]
        public string Telefon { get; set; }

        /// <summary>
        /// E-postadress till kontaktperson hos filleverantören
        /// </summary>
        [Required, MaxLength(256), EmailAddress]
        public string Epostadress { get; set; }

        // nedanstående fält är inte obligatoriska

        /// <summary>
        /// Gatuadress 1 till företaget som levererar filen
        /// </summary>
        [MaxLength(50)]
        public string Utdelningsadress1 { get; set; }

        /// <summary>
        /// Gatuadress 2 till företaget som levererar filen
        /// </summary>
        [MaxLength(50)]
        public string Utdelningsadress2 { get; set; }

        /// <summary>
        /// Postnummer till företaget som levererar filen
        /// </summary>
        [MinLength(1), MaxLength(9)]
        public string Postnummer { get; set; }

        /// <summary>
        /// Postort till företaget som levererar filen
        /// </summary>
        [MinLength(1), MaxLength(30)]
        public string Postort { get; set; }
    }
}

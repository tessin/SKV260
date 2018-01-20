using System;
using System.ComponentModel.DataAnnotations;
using SKV260.Kontrolluppgifter;
using System.Xml.Linq;

namespace SKV260
{
    public class Avsandare
    {
        public Text _programnamn;
        public Text _organisationsnummer;

        /// <summary>
        /// Det program som använts för att framställa filen
        /// </summary>
        [Required, MaxLength(50)]
        public string Programnamn { get { return _programnamn; } set { _programnamn = value; } }

        [Required, Identitet]
        public string Organisationsnummer { get { return _organisationsnummer; } set { _organisationsnummer = value; } }

        public TekniskKontaktperson TekniskKontaktperson { get; set; } = new TekniskKontaktperson();

        public Avsandare()
        {
            Programnamn = "Tessin SKV260 Version 1.0";
        }

        /// <summary>
        /// Tidpunkt när filen skapades
        /// </summary>
        public DateTime Skapad { get; set; } = DateTime.Now;

        public XElement Accept(XVisitor visitor)
        {
            return visitor.Visit(this);
        }
    }
}

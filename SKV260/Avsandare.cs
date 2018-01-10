using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SKV260.Kontrolluppgifter;
using System.Xml.Linq;

namespace SKV260
{
    public class Avsandare
    {
        /// <summary>
        /// Det program som använts för att framställa filen
        /// </summary>
        [Required, MaxLength(50)]
        public string Programnamn { get; set; } = "Tessin SKV260 Version 1.0";

        [Required, Identitet]
        public string Organisationsnummer { get; set; }

        public TekniskKontaktperson TekniskKontaktperson { get; set; } = new TekniskKontaktperson();

        /// <summary>
        /// Tidpunkt när filen skapades
        /// </summary>
        public DateTime Skapad { get; set; } = DateTime.Now;

        public XElement Accept(KUGenerateVisitor visitor)
        {
            return visitor.Visit(this);
        }
    }
}

using SKV260.Kontrolluppgifter;
using System;
using System.ComponentModel.DataAnnotations;
using System.Reflection;
using System.Xml.Linq;

namespace SKV260
{
    public class Blankett
    {
        public static implicit operator Blankett(KU ku)
        {
            return CreateFrom(ku);
        }

        public static Blankett CreateFrom(KU ku)
        {
            if (ku == null)
            {
                throw new ArgumentNullException(nameof(ku));
            }

            var blankettnummer = ku.GetType().GetCustomAttribute<BlankettnummerAttribute>(false);
            if (blankettnummer == null)
            {
                throw new InvalidOperationException("Metadata BlankettnummerAttribute is missing");
            }

            var id = ku.GetId();

            return new Blankett
            {
                Nummer = blankettnummer.Nummer,
                Arendeinformation =
                {
                    Arendeagare = id.UppgiftslamnarId,
                    Period = id.Inkomstar,
                },
                Blankettinnehall = ku
            };
        }

        /// <summary>
        /// Blankettnummer, följer normalt av KU typ. 
        /// </summary>
        [Required]
        public int? Nummer { get; set; }

        public Arendeinformation Arendeinformation { get; set; } = new Arendeinformation();

        public KU Blankettinnehall { get; set; }

        public XElement Accept(XVisitor visitor)
        {
            return visitor.Visit(this);
        }
    }
}

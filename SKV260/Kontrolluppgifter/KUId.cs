using System;
using System.Text.RegularExpressions;

namespace SKV260.Kontrolluppgifter
{
    public class KUId
    {
        // Dessa fem uppgifter är obligatoriska, 
        // dvs. måste alltid anges på samtliga KU. 
        // De är också viktiga vid rättelse eller borttag, 
        // se avsnitt om rättelse och borttag.

        /// <summary>
        /// Den blankett som ska användas för de aktuella kontrolluppgifterna. t.ex. KU20.
        /// </summary>
        public string Typ { get; }

        /// <summary>
        /// FK201, uppgiftslämnarens person-/organisationsnummer.
        /// </summary>
        public Fält UppgiftslamnarId { get; } = new Fält(201);

        /// <summary>
        /// FK203, inkomstår.
        /// </summary>
        public Fält Inkomstar { get; } = new Fält(203);

        /// <summary>
        /// FK215, den som KU avser. Svenskt person-/samordnings- eller, organisationsnummer. alt FK222 eller FK224.
        /// </summary>
        public Fält Inkomsttagare { get; }

        /// <summary>
        /// FK570, obligatoriskt, ett heltal mellan 1-9999999999.
        /// </summary>
        public Fält Specifikationsnummer { get; } = new Fält(570);

        public KUId(string typ, string uppgiftslamnarId, int inkomstar, Fält inkomsttagare, long specifikationsnummer)
        {
            if (!Regex.IsMatch(typ, @"KU\d+"))
            {
                throw new ArgumentException("Felaktig KU-typ", nameof(typ));
            }
            if (uppgiftslamnarId == null)
            {
                throw new ArgumentException("Felaktigt uppgiftslamnarId", nameof(uppgiftslamnarId));
            }
            if (inkomsttagare.Key != 215 && inkomsttagare.Key != 222 && inkomsttagare.Key != 224)
            {
                throw new ArgumentException("Felaktig inkomsttagare", nameof(inkomsttagare));
            }
            if (!(1 <= specifikationsnummer && specifikationsnummer <= 9999999999))
            {
                throw new ArgumentException("Felaktigt specifikationsnummer", nameof(inkomsttagare));
            }
            this.Typ = typ;
            this.UppgiftslamnarId.Value = uppgiftslamnarId;
            this.Inkomstar.Value = inkomstar;
            this.Inkomsttagare = inkomsttagare;
            this.Specifikationsnummer.Value = specifikationsnummer;
        }

        public override string ToString()
        {
            return string.Join("-", Typ, UppgiftslamnarId, Inkomstar, Inkomsttagare, Specifikationsnummer);
        }
    }
}

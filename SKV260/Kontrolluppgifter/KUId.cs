using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace SKV260.Kontrolluppgifter
{
    /// <summary>
    /// En kontrolluppgift identifieras som unik genom en kombination av fem fält. 
    /// Dessa fem fält kallas identifikatorerna.
    /// Så snart en av identifikatorerna skiljer sig åt jämfört med en annan kontrolluppgift är kontrollupgifterna unika mot varandra.
    /// </summary>
    public struct KUId
    {
        public static readonly Fältkod[] Identifikatorer = new Fältkod[] {
            Fältkod.UppgiftslamnarId,
            Fältkod.Inkomstar,
            Fältkod.Inkomsttagare,
            Fältkod.Fodelsetid,
            Fältkod.AnnatIDNr,
            Fältkod.Specifikationsnummer,
        };

        // Dessa fem uppgifter är obligatoriska (FK215, FK222 eller FK224 ska anges), 
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
        public string UppgiftslamnarId
        {
            get;
        }

        /// <summary>
        /// FK203, inkomstår.
        /// </summary>
        public int Inkomstar
        {
            get;
        }

        /// <summary>
        /// FK215, den som KU avser. Svenskt person-/samordnings- eller, organisationsnummer. alt FK222 eller FK224.
        /// </summary>
        public string Inkomsttagare
        {
            get;
        }

        /// <summary>
        /// FK222, ÅÅÅÅMMDDnnn där: ÅÅÅÅMMDD ska vara ett giltigt datum med 18, 19 eller 20 som sekelsiffror. nnn kan vara vilket heltal som helst mellan 000 - 999.
        /// </summary>
        public string Fodelsetid
        {
            get;
        }

        /// <summary>
        /// FK224
        /// </summary>
        public string AnnatIDNr
        {
            get;
        }

        /// <summary>
        /// FK570, obligatoriskt, ett heltal mellan 1-9999999999.
        /// </summary>
        public long Specifikationsnummer
        {
            get;
        }

        public bool IsComplete { get; }

        public KUId(KU ku)
        {
            if (ku == null)
            {
                throw new ArgumentNullException(nameof(ku));
            }

            var typ = ku.GetType().Name;
            if (!(typ.StartsWith("KU") && typ.Substring(2).All(char.IsDigit)))
            {
                throw new ArgumentException("Felaktig KU-typ", nameof(ku));
            }

            var data = ku.Data;

            var uppgiftslamnarId = data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId);
            var inkomstar = data.GetValueOrDefault<int>(Fältkod.Inkomstar);
            var inkomsttagare = data.GetValueOrDefault<string>(Fältkod.Inkomsttagare);
            var fodelsetid = data.GetValueOrDefault<string>(Fältkod.Fodelsetid);
            var annatIDNr = data.GetValueOrDefault<string>(Fältkod.AnnatIDNr);
            var specifikationsnummer = data.GetValueOrDefault<long>(Fältkod.Specifikationsnummer);

            this.Typ = typ;
            this.UppgiftslamnarId = uppgiftslamnarId;
            this.Inkomstar = inkomstar;
            this.Inkomsttagare = inkomsttagare;
            this.Fodelsetid = fodelsetid;
            this.AnnatIDNr = annatIDNr;
            this.Specifikationsnummer = specifikationsnummer;

            this.IsComplete = HasId(data);
        }

        public static bool HasId(FältData d)
        {
            if (!d.Contains(Fältkod.UppgiftslamnarId))
            {
                return false;
            }

            if (!d.Contains(Fältkod.Inkomstar))
            {
                return false;
            }

            if (!d.Contains(Fältkod.Inkomsttagare) && !d.Contains(Fältkod.Fodelsetid) && !d.Contains(Fältkod.AnnatIDNr))
            {
                return false;
            }

            if (d.Contains(Fältkod.Inkomsttagare) && d.Contains(Fältkod.Fodelsetid))
            {
                return false;
            }

            if (!(d.Contains(Fältkod.Inkomsttagare) || d.Contains(Fältkod.Fodelsetid) || d.Contains(Fältkod.AnnatIDNr)))
            {
                return false;
            }

            if (!d.Contains(Fältkod.Specifikationsnummer))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Den identifikator komponent som KU avser.
        /// </summary>
        private string GetComponentAvser()
        {
            if (!string.IsNullOrEmpty(Inkomsttagare))
            {
                return Inkomsttagare;
            }

            if (!string.IsNullOrEmpty(Fodelsetid))
            {
                return Fodelsetid;
            }

            return AnnatIDNr;
        }

        public string[] GetComponents()
        {
            return new[] {
                Typ.ToLowerInvariant(), // 0
                UppgiftslamnarId?.ToLowerInvariant(), // 1
                Convert.ToString(Inkomstar, CultureInfo.InvariantCulture), // 2
                GetComponentAvser()?.ToLowerInvariant(), // 3
                Specifikationsnummer.ToString("0000000000", CultureInfo.InvariantCulture), // 4
            };
        }

        public override string ToString()
        {
            return string.Join("-", GetComponents());
        }
    }
}

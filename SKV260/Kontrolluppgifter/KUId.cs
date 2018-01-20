using System;
using System.Globalization;
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
        public static readonly Fältkod[] Fält = new Fältkod[] {
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

        public KUId(KU ku)
        {
            var typ = ku.GetType().Name;
            var uppgiftslamnarId = ku.Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId);
            var inkomstar = ku.Data.GetValueOrDefault<int>(Fältkod.Inkomstar);
            var inkomsttagare = ku.Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare);
            var fodelsetid = ku.Data.GetValueOrDefault<string>(Fältkod.Fodelsetid);
            var annatIDNr = ku.Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr);
            var specifikationsnummer = ku.Data.GetValueOrDefault<long>(Fältkod.Specifikationsnummer);

            if (!Regex.IsMatch(typ, @"KU\d+"))
            {
                throw new ArgumentException("Felaktig KU-typ", nameof(typ));
            }

            if (string.IsNullOrEmpty(uppgiftslamnarId))
            {
                throw new ArgumentException("Felaktigt uppgiftslamnarId", nameof(uppgiftslamnarId));
            }

            if (inkomstar == 0)
            {
                throw new ArgumentException("Felaktigt inkomstar", nameof(inkomstar));
            }

            if (!ku.Data.Contains(Fältkod.Inkomsttagare) && !ku.Data.Contains(Fältkod.Fodelsetid) && !ku.Data.Contains(Fältkod.AnnatIDNr))
            {
                throw new InvalidOperationException("FK215 ska finnas om FK222 och FK224 saknas.");
            }

            if (ku.Data.Contains(Fältkod.Inkomsttagare) && ku.Data.Contains(Fältkod.Fodelsetid))
            {
                throw new InvalidOperationException("Om FK215 finns får inte FK222 finnas.");
            }

            if (!(ku.Data.Contains(Fältkod.Inkomsttagare) || ku.Data.Contains(Fältkod.Fodelsetid) || ku.Data.Contains(Fältkod.AnnatIDNr)))
            {
                throw new InvalidOperationException("FK215, FK222 eller FK224 saknas.");
            }

            if (!(1 <= specifikationsnummer && specifikationsnummer <= 9999999999))
            {
                throw new ArgumentException("Felaktigt specifikationsnummer", nameof(specifikationsnummer));
            }

            this.Typ = typ;
            this.UppgiftslamnarId = uppgiftslamnarId;
            this.Inkomstar = inkomstar;
            this.Inkomsttagare = inkomsttagare;
            this.Fodelsetid = fodelsetid;
            this.AnnatIDNr = annatIDNr;
            this.Specifikationsnummer = specifikationsnummer;
        }

        /// <summary>
        /// Den identifikator komponent som KU avser.
        /// </summary>
        public string GetComponentAvser()
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
                Typ.ToLowerInvariant(),
                UppgiftslamnarId.ToLowerInvariant(),
                Convert.ToString(Inkomstar, CultureInfo.InvariantCulture),
                GetComponentAvser().ToLowerInvariant(),
                Specifikationsnummer.ToString("0000000000", CultureInfo.InvariantCulture),
            };
        }

        public override string ToString()
        {
            return string.Join("-", GetComponents());
        }
    }
}

using System;

namespace SKV260.Kontrolluppgifter
{
    public static class Sambandskontroller
    {
        public static void Sambandskontroll(KU ku)
        {
            if (ku is KU20)
            {
                Sambandskontroll070(ku);
                return;
            }
            if (ku is KU31)
            {
                Sambandskontroll085(ku);
                return;
            }
            if (ku is KU32)
            {
                Sambandskontroll085(ku);
                return;
            }
        }

        public static void Sambandskontroll070(KU ku)
        {
            var d = ku.Data;
            if (!d.Contains(Fältkod.Ranteinkomst) && !d.Contains(Fältkod.Borttag) && !d.Contains(Fältkod.AvdragenSkatt) && !d.Contains(Fältkod.RanteinkomstEjKonto) && !d.Contains(Fältkod.AnnanInkomst))
            {
                throw new InvalidOperationException("FK500 måste finnas om FK205, FK001, FK503 och FK504 saknas.");
            }
        }

        public static void Sambandskontroll085(KU ku)
        {
            var d = ku.Data;
            if (!d.Contains(Fältkod.VPNamn) && !d.Contains(Fältkod.ISIN) && !d.Contains(Fältkod.Borttag))
            {
                throw new InvalidOperationException("Du har inte angett något ISIN, fält 572. Då ska du fylla i Namn på aktien/andelen, fält 571");
            }
        }
    }
}

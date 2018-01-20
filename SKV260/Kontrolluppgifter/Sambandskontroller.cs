using System;

namespace SKV260.Kontrolluppgifter
{
    public class Sambandskontroller
    {
        public void Sambandskontroll(KU ku)
        {
            if (ku is KU20)
            {
                Sambandskontroll((KU20)ku);
                return;
            }
        }

        public void Sambandskontroll(KU20 ku20)
        {
            var data = ku20.Data;
            if (!data.Contains(Fältkod.Ranteinkomst) && !data.Contains(Fältkod.Borttag) && !data.Contains(Fältkod.AvdragenSkatt) && !data.Contains(Fältkod.RanteinkomstEjKonto) && !data.Contains(Fältkod.AnnanInkomst))
            {
                throw new InvalidOperationException("FK500 måste finnas om FK205, FK001, FK503 och FK504 saknas.");
            }
        }
    }
}

using System.Xml.Linq;

namespace SKV260.Kontrolluppgifter
{
    [Blankettnummer(2322)]
    public class KU31 : KU
    {
        public Fält AvdragenSkatt { get; } = new Fält(1);

        public Fält ISIN { get; } = new Fält(572);

        public Fält UtbetaldUtdelning { get; } = new Fält(574);

        public KU31(Uppgiftslamnare uppgiftslamnare, int inkomstar, Fält inkomsttagare, long specifikationsnummer)
            : base("KU31", uppgiftslamnare, inkomstar, inkomsttagare, specifikationsnummer)
        {
        }

        public override XElement Accept(KUGenerateVisitor visitor)
        {
            return visitor.Visit(this);
        }
    }
}

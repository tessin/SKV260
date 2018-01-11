using System.Xml.Linq;

namespace SKV260.Kontrolluppgifter
{
    [Blankettnummer(2318)]
    public class KU32 : KU
    {
        public Fält VPNamn { get; } = new Fält(571);

        public Fält ISIN { get; } = new Fält(572);

        public Fält AntalAvyttrade { get; } = new Fält(576);

        public Fält ErhallenErsattning { get; } = new Fält(810);

        public KU32(Uppgiftslamnare uppgiftslamnare, int inkomstar, Fält inkomsttagare, long specifikationsnummer)
            : base("KU32", uppgiftslamnare, inkomstar, inkomsttagare, specifikationsnummer)
        {
        }

        public override XElement Accept(KUGenerateVisitor visitor)
        {
            return visitor.Visit(this);
        }
    }
}

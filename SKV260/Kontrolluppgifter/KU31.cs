using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace SKV260.Kontrolluppgifter
{
    [Blankettnummer(2322)]
    public class KU31 : KU
    {
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

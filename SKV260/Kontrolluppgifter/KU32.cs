using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace SKV260.Kontrolluppgifter
{
    [Blankettnummer(2318)]
    public class KU32 : KU
    {
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

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace SKV260.Kontrolluppgifter
{
    [Blankettnummer(2323)]
    public class KU20 : KU
    {
        /// <summary>
        /// Avdragen preliminär skatt eller avdragen skatt för SINK. 
        /// </summary>
        public Fält AvdragenSkatt { get; } = new Fält(001);

        /// <summary>
        /// Här lämnas uppgift om tillgodoräknad eller utbetald ränta på konto i bank m.m.
        /// </summary>
        public Fält Ranteinkomst { get; } = new Fält(500);

        /// <summary>
        /// RanteinkmostEjKonto avser tillgodoräknad eller utbetald ränta på annat än konto i bank m.m., t.ex. ränta på lån som tagits från en delägare i ett fåmansföretag. 
        /// </summary>
        public Fält RanteinkomstEjKonto { get; } = new Fält(503);

        /// <summary>
        /// Annan inkomst som inte anses som ränta eller utdelning.
        /// </summary>
        public Fält AnnanInkomst { get; } = new Fält(504);

        public KU20(Uppgiftslamnare uppgiftslamnare, int inkomstar, Fält inkomsttagare, long specifikationsnummer)
            : base("KU20", uppgiftslamnare, inkomstar, inkomsttagare, specifikationsnummer)
        {
        }

        public override XElement Accept(KUGenerateVisitor visitor)
        {
            return visitor.Visit(this);
        }
    }
}

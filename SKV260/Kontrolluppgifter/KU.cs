using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace SKV260.Kontrolluppgifter
{
    public abstract class KU
    {
        /// <summary>
        /// Identitet.
        /// </summary>
        public KUId Id { get; }

        protected KU(string typ, Uppgiftslamnare uppgiftslamnare, int inkomstar, Fält inkomsttagare, long specifikationsnummer)
        {
            Id = new KUId(typ, uppgiftslamnare.UppgiftslamnarePersOrgnr, inkomstar, inkomsttagare, specifikationsnummer);
        }

        public abstract XElement Accept(KUGenerateVisitor visitor);
    }
}

using System.Xml.Linq;

namespace SKV260.Kontrolluppgifter
{
    public abstract class KU
    {
        /// <summary>
        /// Identitet.
        /// </summary>
        public KUId Id { get; }

        public Fält Borttag { get; } = new Fält(55);

        protected KU(string typ, Uppgiftslamnare uppgiftslamnare, int inkomstar, Fält inkomsttagare, long specifikationsnummer)
        {
            Id = new KUId(typ, uppgiftslamnare.UppgiftslamnarePersOrgnr, inkomstar, inkomsttagare, specifikationsnummer);
        }

        public abstract XElement Accept(KUGenerateVisitor visitor);
    }
}

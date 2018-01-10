using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace SKV260.Kontrolluppgifter
{
    public class KUGenerateVisitor
    {
        protected readonly XNamespace _ku;

        public List<ValidationResultWithContext> ValidationResults { get; set; } = new List<ValidationResultWithContext>();

        public KUGenerateVisitor(XNamespace ku)
        {
            _ku = ku;
        }

        protected void Validate(object instance)
        {
            var v = new ValidationResultWithContext(instance);
            if (!v.Validate())
            {
                ValidationResults.Add(v);
            }
        }

        public virtual XElement Visit(Avsandare avsandare)
        {
            Validate(avsandare);
            Validate(avsandare.TekniskKontaktperson);

            var el = new XElement(_ku + "Avsandare",
                    new XElement(_ku + "Programnamn", avsandare.Programnamn),
                    new XElement(_ku + "Organisationsnummer", avsandare.Organisationsnummer),
                    new XElement(_ku + "TekniskKontaktperson",
                        new XElement(_ku + "Namn", avsandare.TekniskKontaktperson.Namn),
                        new XElement(_ku + "Telefon", avsandare.TekniskKontaktperson.Telefon),
                        new XElement(_ku + "Epostadress", avsandare.TekniskKontaktperson.Epostadress),
                        new XElement(_ku + "Utdelningsadress1", avsandare.TekniskKontaktperson.Utdelningsadress1),
                        new XElement(_ku + "Utdelningsadress2", avsandare.TekniskKontaktperson.Utdelningsadress2),
                        new XElement(_ku + "Postnummer", avsandare.TekniskKontaktperson.Postnummer),
                        new XElement(_ku + "Postort", avsandare.TekniskKontaktperson.Postort)
                    ),
                    new XElement(_ku + "Skapad", avsandare.Skapad)
                );
            return el;
        }

        public virtual XElement Visit(Uppgiftslamnare uppgiftslamnare)
        {
            Validate(uppgiftslamnare);
            foreach (var kontaktperson in uppgiftslamnare.Kontaktperson)
            {
                Validate(kontaktperson);
            }

            var el = new XElement(_ku + "Uppgiftslamnare",
                    new XElement(_ku + "UppgiftslamnarePersOrgnr", uppgiftslamnare.UppgiftslamnarePersOrgnr)
                );
            foreach (var kontaktperson in uppgiftslamnare.Kontaktperson)
            {
                el.Add(
                    new XElement(_ku + "Kontaktperson",
                        new XElement(_ku + "Namn", kontaktperson.Namn),
                            new XElement(_ku + "Telefon", kontaktperson.Telefon),
                            new XElement(_ku + "Epostadress", kontaktperson.Epostadress),
                            new XElement(_ku + "Sakomrade", kontaktperson.Sakomrade)
                        )
                );
            }
            return el;
        }

        public virtual XElement Visit(Blankett blankett)
        {
            Validate(blankett);
            Validate(blankett.Arendeinformation);

            var el = new XElement(_ku + "Blankett", new XAttribute("nummer", blankett.Nummer),
                new XElement(_ku + "Arendeinformation",
                    new XElement(_ku + "Arendeagare", blankett.Arendeinformation.Arendeagare),
                    new XElement(_ku + "Period", blankett.Arendeinformation.Period)
                ),
                new XElement(_ku + "Blankettinnehall",
                    blankett.Blankettinnehall.Accept(this)
                )
            );
            return el;
        }

        protected XElement CreateValue(string name, Fält fält)
        {
            return new XElement(_ku + name, new XAttribute("faltkod", fält.Key.ToString("000", CultureInfo.InvariantCulture)), fält.Value);
        }

        public virtual XElement Visit(KU20 ku20)
        {
            var el = new XElement(_ku + "KU20",
                CreateValue("AvdragenSkatt", ku20.AvdragenSkatt),
                CreateValue("Inkomstar", ku20.Id.Inkomstar),
                CreateValue("Ranteinkomst", ku20.Ranteinkomst),
                CreateValue("RanteinkomstEjKonto", ku20.RanteinkomstEjKonto),
                CreateValue("AnnanInkomst", ku20.AnnanInkomst),
                CreateValue("Specifikationsnummer", ku20.Id.Specifikationsnummer),
                    new XElement(_ku + "InkomsttagareKU20",
                        CreateValue("Inkomsttagare", ku20.Id.Inkomsttagare)
                    ),
                    new XElement(_ku + "UppgiftslamnareKU20",
                        CreateValue("UppgiftslamnarId", ku20.Id.UppgiftslamnarId)
                    )
                );
            return el;
        }

        public virtual XElement Visit(KU31 kU31)
        {
            throw new NotImplementedException();
        }

        public virtual XElement Visit(KU32 kU32)
        {
            throw new NotImplementedException();
        }
    }
}

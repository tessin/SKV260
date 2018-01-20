using System;
using System.Collections.Generic;
using System.Globalization;
using System.Xml.Linq;
using SKV260.Kontrolluppgifter;

namespace SKV260
{
    public class XVisitor
    {
        protected readonly XNamespace _ku;

        public List<ValidationResultWithContext> ValidationResults { get; set; } = new List<ValidationResultWithContext>();

        public XVisitor(XNamespace ku)
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
                    CreateBlankettinnehall(blankett.Blankettinnehall)
                )
            );
            return el;
        }

        protected XElement CreateValue(Fält fält)
        {
            return new XElement(_ku + fält.Key.ToString(), new XAttribute("faltkod", ((int)fält.Key).ToString("000", CultureInfo.InvariantCulture)), fält.Value);
        }

        private XElement CreateBlankettinnehall(KU blankettinnehall)
        {
            var id = blankettinnehall.GetId();

            var layout = blankettinnehall.GetLayout();

            var data = blankettinnehall.Data;

            var el = new XElement(_ku + id.Typ);

            foreach (var f in data.Subset(layout.Kontrolluppgifter))
            {
                if (f.HasValue)
                {
                    el.Add(CreateValue(f));
                }
            }

            var inkomsttagare = new XElement(_ku + "Inkomsttagare" + id.Typ);
            foreach (var f in data.Subset(layout.Inkomsttagare))
            {
                if (f.HasValue)
                {
                    inkomsttagare.Add(CreateValue(f));
                }
            }
            el.Add(inkomsttagare);

            var uppgiftslamnare = new XElement(_ku + "Uppgiftslamnare" + id.Typ);
            foreach (var f in data.Subset(layout.Uppgiftslamnare))
            {
                if (f.HasValue)
                {
                    uppgiftslamnare.Add(CreateValue(f));
                }
            }
            el.Add(uppgiftslamnare);

            return el;
        }
    }
}

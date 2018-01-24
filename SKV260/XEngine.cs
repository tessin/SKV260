using SKV260.Kontrolluppgifter;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Schema;

namespace SKV260
{
    public class XEngine
    {
        private readonly int _inkomstar;
        private readonly string _version;
        private readonly XmlReaderSettings _xmlSettings;

        public XEngine(int inkomstar, string version = "kontrolluppgifter_3.1")
        {
            _inkomstar = inkomstar;
            _version = version;
            _xmlSettings = new XmlReaderSettings
            {
                ValidationType = ValidationType.Schema,
            };
        }

        public void Init()
        {
            if (_xmlSettings.Schemas.Count > 0)
            {
                return;
            }

            var assembly = this.GetType().Assembly;
            foreach (var resourceName in assembly.GetManifestResourceNames())
            {
                if (resourceName.EndsWith(".xsd"))
                {
                    if (resourceName.Contains(_version))
                    {
                        using (var inputFileStream = assembly.GetManifestResourceStream(resourceName))
                        {
                            _xmlSettings.Schemas.Add(XmlSchema.Read(inputFileStream, null));
                        }
                    }
                }
            }
        }

        public Avsandare Avsandare { get; set; } = new Avsandare();

        public List<Uppgiftslamnare> Uppgiftslamnare { get; set; } = new List<Uppgiftslamnare>();

        public BlankettCollection Blanketter { get; set; } = new BlankettCollection();

        public XDocument Generate()
        {
            XNamespace xmlns = "http://xmls.skatteverket.se/se/skatteverket/ai/instans/infoForBeskattning/3.1";
            XNamespace xsi = XNamespace.Get("http://www.w3.org/2001/XMLSchema-instance");
            XNamespace schemaLocation = "http://xmls.skatteverket.se/se/skatteverket/ai/instans/infoForBeskattning/3.1 http://xmls.skatteverket.se/se/skatteverket/ai/kontrolluppgift/instans/Kontrolluppgifter_3.1.xsd";
            XNamespace ku = "http://xmls.skatteverket.se/se/skatteverket/ai/komponent/infoForBeskattning/3.1";
            var doc = new XDocument(new XDeclaration("1.0", "UTF-8", "no"));
            var root = new XElement(xmlns + "Skatteverket",
                    new XAttribute(XNamespace.Xmlns + "ku", ku),
                    new XAttribute("omrade", "Kontrolluppgifter"),
                    new XAttribute(XNamespace.Xmlns + "xsi", xsi),
                    new XAttribute(xsi + "schemaLocation", schemaLocation)
                );
            var visitor = new XVisitor(ku);
            root.Add(Avsandare.Accept(visitor));
            var blankettgemensamt = new XElement(ku + "Blankettgemensamt");
            foreach (var uppgiftslamnare in Uppgiftslamnare)
            {
                blankettgemensamt.Add(uppgiftslamnare.Accept(visitor));
            }
            root.Add(blankettgemensamt);
            var blankettIdSet = new HashSet<string>();
            var uppgiftslamnareSet = new HashSet<string>(Uppgiftslamnare.Select(x => x.UppgiftslamnarePersOrgnr));
            var i = 0;
            foreach (var blankett in Blanketter)
            {
                KUId id;
                try
                {
                    id = blankett.Blankettinnehall.GetId();
                }
                catch (Exception ex)
                {
                    throw new InvalidOperationException($"Blankett med index {i} har inget giltigt ID", ex);
                }

                if (!uppgiftslamnareSet.Contains(id.UppgiftslamnarId))
                {
                    throw new InvalidOperationException($"Uppgiftslämnare för blankett med ID '{id}' är inte med i registret över uppgiftslämnare ({string.Join(", ", uppgiftslamnareSet)}) för dokumentet");
                }

                if (blankett.Arendeinformation.Arendeagare != blankett.Blankettinnehall.Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId))
                {
                    throw new InvalidOperationException($"Arendeagare för blankett med ID '{id}' ska vara lika med UppgiftslamnarId");
                }

                if (_inkomstar != id.Inkomstar)
                {
                    throw new InvalidOperationException($"Blankett med ID '{id}' avser ett annat inkomstår än {_inkomstar}");
                }

                try
                {
                    KUHelper.Validate(blankett.Blankettinnehall);
                }
                catch (Exception ex)
                {
                    throw new InvalidOperationException($"Blankett med ID '{id}' innehåller felaktiga uppgifter", ex);
                }

                Sambandskontroller.Sambandskontroll(blankett.Blankettinnehall);

                root.Add(blankett.Accept(visitor));
                i++;
            }
            doc.Add(root);

            // these are soft warnings, they need to be checked but they aren't formal errors
            foreach (var result in visitor.ValidationResults)
            {
                foreach (var result2 in result.ValidationResults)
                {
                    Console.Error.WriteLine(result2.ErrorMessage);
                }
            }

            // XSD validation

            var sw = new StringWriter();
            doc.Save(sw, SaveOptions.None);
            using (var reader = XmlReader.Create(new StringReader(sw.ToString()), _xmlSettings))
            {
                while (reader.Read())
                {
                    // nom nom nom...
                }
            }

            return doc;
        }
    }
}

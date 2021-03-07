using Newtonsoft.Json.Linq;
using SKV260.Kontrolluppgifter;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Linq;

namespace SKV260
{
    public static class ExportUtils
    {
        public static int ExportXslx(string sourceFn, string destFn)
        {
            var ext = Path.GetExtension(sourceFn).ToLowerInvariant();
            switch (ext)
            {
                case ".xml":
                    return ExportXslx(XDocument.Load(sourceFn), destFn);
                case ".json":
                    return ExportXslx(JArray.Parse(File.ReadAllText(sourceFn)), destFn);
                default:
                    throw new InvalidOperationException($"unsupported file extension {ext}");
            }
        }

        public static int ExportXslx(XDocument source, string destFn)
        {
            XNamespace xmlns = "http://xmls.skatteverket.se/se/skatteverket/ai/instans/infoForBeskattning/6.0";
            XNamespace ku = "http://xmls.skatteverket.se/se/skatteverket/ai/komponent/infoForBeskattning/6.0";

            var root = source.Root;

            if (root.GetDefaultNamespace() != xmlns)
            {
                Console.Error.WriteLine($"root namespace does not match '{xmlns}'");
                return 1;
            }

            var blankettgemensamt = root.Element(ku + "Blankettgemensamt");

            var uppgiftslamnareSheet = new ExportTable { WorksheetName = "Uppgiftslamnare" };

            uppgiftslamnareSheet.Cols.Add(new ExportColumn(0, "UppgiftslamnarePersOrgnr"));
            uppgiftslamnareSheet.Cols.Add(new ExportColumn(1, "KontaktpersonNamn"));
            uppgiftslamnareSheet.Cols.Add(new ExportColumn(2, "KontaktpersonTelefon"));
            uppgiftslamnareSheet.Cols.Add(new ExportColumn(3, "KontaktpersonEpostadress"));
            uppgiftslamnareSheet.Cols.Add(new ExportColumn(4, "KontaktpersonSakomrade"));

            foreach (var uppgiftslamnare in blankettgemensamt.Elements(ku + "Uppgiftslamnare"))
            {
                var id = (string)uppgiftslamnare.Element(ku + "UppgiftslamnarePersOrgnr");

                foreach (var kontaktperson in uppgiftslamnare.Elements(ku + "Kontaktperson"))
                {
                    var row = new ExportRow(uppgiftslamnareSheet.Cols.Count());

                    row.SetCell(0, id);

                    var namn = (string)kontaktperson.Element(ku + "Namn");
                    var telefon = (string)kontaktperson.Element(ku + "Telefon");
                    var epostadress = (string)kontaktperson.Element(ku + "Epostadress");
                    var sakomrade = (string)kontaktperson.Element(ku + "Sakomrade");

                    row.SetCell(1, namn);
                    row.SetCell(2, telefon);
                    row.SetCell(3, epostadress);
                    row.SetCell(4, sakomrade);

                    uppgiftslamnareSheet.Rows.Add(row);
                }
            }

            // first pass metadata

            var metadata = new Dictionary<string, Dictionary<string, int>>();

            foreach (var blankett in root.Elements(ku + "Blankett"))
            {
                var blankettinnehall = blankett.Element(ku + "Blankettinnehall");
                var firstEl = blankettinnehall.Elements().First();
                var name = firstEl.Name.LocalName;
                if (!metadata.TryGetValue(name, out var columnMappings))
                {
                    metadata.Add(name, columnMappings = new Dictionary<string, int>());
                }
                foreach (var f in firstEl.Descendants().Where(el => el.Attributes("faltkod").Any()))
                {
                    if (!columnMappings.ContainsKey(f.Name.LocalName))
                    {
                        columnMappings.Add(f.Name.LocalName, columnMappings.Count);
                    }
                }
            }

            // second pass export

            var tables = new Dictionary<string, ExportTable>();

            foreach (var m in metadata)
            {
                var tbl = new ExportTable { WorksheetName = m.Key };
                foreach (var item in m.Value.OrderBy(x => x.Value))
                {
                    tbl.Cols.Add(new ExportColumn(item.Value, item.Key));
                }
                tables.Add(m.Key, tbl);
            }

            foreach (var blankett in root.Elements(ku + "Blankett"))
            {
                var blankettinnehall = blankett.Element(ku + "Blankettinnehall");
                var firstEl = blankettinnehall.Elements().First();
                var name = firstEl.Name.LocalName;
                var columnMappings = metadata[name];
                var row = new ExportRow(columnMappings.Count);
                foreach (var f in firstEl.Descendants().Where(el => el.Attributes("faltkod").Any()))
                {
                    row.SetCell(columnMappings[f.Name.LocalName], (string)f);
                }
                tables[name].Rows.Add(row);
            }

            var xlsx = new XlsxExportFormatter();

            using (var f = File.Create(destFn))
            {
                xlsx.Serialize(new[] { uppgiftslamnareSheet }.Concat(tables.Values), f);
            }

            return 0;
        }

        public static int ExportXslx(JArray source, string destFn)
        {
            var split = destFn.Split('.');

            var ku = new ExportTable { WorksheetName = split[split.Length - 2].ToUpperInvariant() };

            var fks = new HashSet<Fältkod>();
            var rows = new List<Tuple<Dictionary<Fältkod, string>, JObject>>();

            foreach (JObject obj in source)
            {
                var row = new Dictionary<Fältkod, string>();
                foreach (var prop in obj.Properties())
                {
                    if (Enum.TryParse(prop.Name, out Fältkod fk))
                    {
                        row.Add(fk, (string)prop.Value);
                        fks.Add(fk);
                    }
                }
                rows.Add(Tuple.Create(row, obj));
            }

            //
            var columnMap = new Dictionary<Fältkod, int>();
            foreach (var fk in fks.OrderBy(x => x))
            {
                var ordinal = columnMap.Count;
                columnMap.Add(fk, ordinal);
                ku.Cols.Add(new ExportColumn(ordinal, $"{fk} ({(int)fk:000})"));
            }
            var tessinNamn = ku.Cols.Count;
            ku.Cols.Add(new ExportColumn(tessinNamn, $"Namn (ej SKV)"));
            foreach (var item in rows)
            {
                var row = ku.CreateRow();

                foreach (var x in item.Item1)
                {
                    row.SetCell(columnMap[x.Key], x.Value);
                }

                row.SetCell(tessinNamn, $"{(string)item.Item2["TessinUserFirstName"]} {(string)item.Item2["TessinUserLastName"]}");

                ku.Rows.Add(row);
            }
            //

            var xlsx = new XlsxExportFormatter();

            using (var f = File.Create(destFn))
            {
                xlsx.Serialize(new[] { ku }, f);
            }

            return 0;
        }
    }
}

﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Linq;

namespace xml2xlsx
{
    class Program
    {
        static int Main(string[] args)
        {
            var sourceFn = Path.GetFullPath(args[0]);
            if (!File.Exists(sourceFn))
            {
                Console.Error.WriteLine($"cannot find file '{sourceFn}'");
                return 1;
            }

            var destFn = Path.ChangeExtension(sourceFn, "xlsx");
            if (File.Exists(destFn))
            {
                var overwrite = args.Length > 1 && args[1] == "--force";
                if (!overwrite)
                {
                    Console.Error.WriteLine($"file '{sourceFn}' would be overwritten. Move or delete file first");
                    return 1;
                }
            }

            XNamespace xmlns = "http://xmls.skatteverket.se/se/skatteverket/ai/instans/infoForBeskattning/3.1";
            XNamespace ku = "http://xmls.skatteverket.se/se/skatteverket/ai/komponent/infoForBeskattning/3.1";

            var doc = XDocument.Load(sourceFn);

            var root = doc.Root;

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
    }
}

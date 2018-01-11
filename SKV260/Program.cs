using SKV260.Kontrolluppgifter;
using System.Xml.Linq;

namespace SKV260
{
    class Program
    {
        static void Main(string[] args)
        {
            var x = new XEngine(2017);

            x.Init();

            x.Avsandare.Organisationsnummer = "165569659187";
            x.Avsandare.TekniskKontaktperson.Namn = "Emelie Öhlund";
            x.Avsandare.TekniskKontaktperson.Telefon = "+46192100872";
            x.Avsandare.TekniskKontaktperson.Epostadress = "emelie.ohlund@mailinator.com";
            x.Avsandare.TekniskKontaktperson.Postnummer = "702 25";
            x.Avsandare.TekniskKontaktperson.Postort = "ÖREBRO";

            var uppgiftslamnare = new Uppgiftslamnare
            {
                UppgiftslamnarePersOrgnr = "165569659187",
                Kontaktperson =
                {
                    new Kontaktperson
                    {
                        Namn = "George Vesterlund",
                        Telefon = "+46424685115",
                        Epostadress = "george.vesterlund@dodgit.com",
                        Sakomrade = "Skatteverket",
                    }
                }
            };

            x.Uppgiftslamnare.Add(uppgiftslamnare);

            var ku20 = x.Create<KU20>(uppgiftslamnare, new Fält(215, "198711292675"), 1);

            ku20.AvdragenSkatt.Value = 10000;
            ku20.Ranteinkomst.Value = 20000;
            ku20.RanteinkomstEjKonto.Value = 40000;
            ku20.AnnanInkomst.Value = 15000;

            x.Blanketter.Add(ku20);

            var ku31 = x.Create<KU31>(uppgiftslamnare, new Fält(215, "198911092487"), 1);

            ku31.AvdragenSkatt.Value = 9000;
            ku31.ISIN.Value = "SE0000101032";
            ku31.UtbetaldUtdelning.Value = 30000;

            x.Blanketter.Add(ku31);

            var ku32 = x.Create<KU32>(uppgiftslamnare, new Fält(215, "195803024768"), 1);

            ku32.VPNamn.Value = "Telenor";
            ku32.ISIN.Value = "SE0000101032";
            ku32.AntalAvyttrade.Value = 100;
            ku32.ErhallenErsattning.Value = 198000;

            x.Blanketter.Add(ku32);

            var doc = x.Generate();

            doc.Save("skv260.xml", SaveOptions.None);
        }
    }
}

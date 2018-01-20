using SKV260.Kontrolluppgifter;
using System;
using System.Xml.Linq;

namespace SKV260
{
    class Program
    {
        static void Main(string[] args)
        {
            var inkomstar = 2017;

            var x = new XEngine(inkomstar);

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

            var ku20 = new KU20();

            // id
            ku20.UppgiftslamnarId = uppgiftslamnare.UppgiftslamnarePersOrgnr;
            ku20.Inkomstar = inkomstar;
            ku20.Inkomsttagare = "198711292675";
            ku20.Specifikationsnummer = 1;

            // kontrolluppgifter
            ku20.AvdragenSkatt = 10000;
            ku20.Ranteinkomst = 20000;
            ku20.RanteinkomstEjKonto = 40000;
            ku20.AnnanInkomst = 15000;

            x.Blanketter.Add(ku20);

            var ku31 = new KU31();

            // id
            ku31.UppgiftslamnarId = uppgiftslamnare.UppgiftslamnarePersOrgnr;
            ku31.Inkomstar = inkomstar;
            ku31.Inkomsttagare = "198911092487";
            ku31.Specifikationsnummer = 1;

            // kontrolluppgifter
            ku31.AvdragenSkatt = 9000;
            ku31.ISIN = "SE0000101032";
            ku31.UtbetaldUtdelning = 30000;

            x.Blanketter.Add(ku31);

            var ku32 = new KU32();

            // id
            ku32.UppgiftslamnarId = uppgiftslamnare.UppgiftslamnarePersOrgnr;
            ku32.Inkomstar = inkomstar;
            ku32.Inkomsttagare = "195803024768";
            ku32.Specifikationsnummer = 1;

            // kontrolluppgifter
            ku32.VPNamn = "Telenor";
            ku32.ISIN = "SE0000101032";
            ku32.AntalAvyttrade = 100;
            ku32.ErhallenErsattning = 198000;

            x.Blanketter.Add(ku32);

            var doc = x.Generate();

            doc.Save("skv260.xml", SaveOptions.None);
        }
    }
}

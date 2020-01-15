using System;

namespace SKV260.Kontrolluppgifter
{
// 001 -> AvdragenSkatt,Belopp,10,HELTAL
// 061 -> Delagare,Kryss,-1,KRYSSRUTA
// 076 -> LandskodTIN,Landskod,-1,LANDSKOD
// 077 -> Fodelseort,Text,35,TEXT
// 078 -> LandskodFodelseort,Landskod,-1,LANDSKOD
// 201 -> UppgiftslamnarId,Identitet,-1,PERSORGNR
// 202 -> NamnUppgiftslamnare,Text,50,TEXT
// 203 -> Inkomstar,Inkomstar,-1,DATUM
// 205 -> Borttag,Kryss,-1,KRYSSRUTA
// 210 -> Rattelse,Kryss,-1,KRYSSRUTA
// 215 -> Inkomsttagare,Identitet,-1,PERSORGNR
// 216 -> Fornamn,Text,50,TEXT
// 217 -> Efternamn,Text,50,TEXT
// 218 -> Gatuadress,Text,50,TEXT
// 219 -> Postnummer,PostNummer,-1,TEXT
// 220 -> Postort,Text,50,TEXT
// 221 -> LandskodPostort,Landskod,-1,LANDSKOD
// 222 -> Fodelsetid,Fodelsetid,-1,HELTAL
// 224 -> AnnatIDNr,Text,20,TEXT
// 226 -> OrgNamn,Text,50,TEXT
// 228 -> Gatuadress2,Text,50,TEXT
// 230 -> FriAdress,Text,350,TEXT
// 252 -> TIN,Text,20,TEXT
// 500 -> Ranteinkomst,Belopp,10,HELTAL
// 502 -> Forfogarkonto,Kryss,-1,KRYSSRUTA
// 503 -> RanteinkomstEjKonto,Belopp,10,HELTAL
// 504 -> AnnanInkomst,Belopp,7,HELTAL
// 570 -> Specifikationsnummer,SpecifikationsNummer,-1,HELTAL
// 528 -> UnderlagForInvesteraravdrag,Belopp,10,HELTAL
// 529 -> TotUnderlagInvesteraravdrag,Belopp,10,HELTAL
// 530 -> Betalningsar,Kryss,-1,KRYSSRUTA
// 531 -> AterforingAvyttring,Kryss,-1,KRYSSRUTA
// 532 -> AterforingUtflyttning,Kryss,-1,KRYSSRUTA
// 533 -> AterforingHogVardeoverforing,Kryss,-1,KRYSSRUTA
// 534 -> AterforingInternaForvarv,Kryss,-1,KRYSSRUTA
// 002 -> AvdragenUtlandskSkatt,Belopp,10,HELTAL
// 003 -> AvdragenKupongskatt,Belopp,10,HELTAL
// 079 -> LandskodHemvist,Landskod,-1,LANDSKOD
// 256 -> Hemviststat,Text,30,TEXT
// 523 -> Depanummer,Belopp,12,HELTAL
// 524 -> AndelAvDepan,Decimal,2,DECIMALTAL
// 571 -> VPNamn,Text,50,TEXT
// 572 -> ISIN,Isin,-1,TEXT
// 574 -> UtbetaldUtdelning,Belopp,10,HELTAL
// 581 -> AnnanKupongErsattning,Belopp,10,HELTAL
// 599 -> OkandVarde,Kryss,-1,KRYSSRUTA
// 853 -> Avstamningsdag,Datum,-1,DATUM
// 573 -> AvyttradTillISK,Kryss,-1,KRYSSRUTA
// 576 -> AntalAvyttrade,Belopp,12,HELTAL
// 810 -> ErhallenErsattning,Belopp,10,HELTAL
[Blankettnummer(2323)]
public partial class KU20 : KU {
private static readonly Fältkod[] _KontrolluppgifterLayout = new [] {
Fältkod.AvdragenSkatt,
Fältkod.Delagare,
Fältkod.Inkomstar,
Fältkod.Borttag,
Fältkod.Ranteinkomst,
Fältkod.Forfogarkonto,
Fältkod.RanteinkomstEjKonto,
Fältkod.AnnanInkomst,
Fältkod.Specifikationsnummer,
};
private static readonly Fältkod[] _InkomsttagareLayout = new [] {
Fältkod.LandskodTIN,
Fältkod.Fodelseort,
Fältkod.LandskodFodelseort,
Fältkod.Inkomsttagare,
Fältkod.Fornamn,
Fältkod.Efternamn,
Fältkod.Gatuadress,
Fältkod.Postnummer,
Fältkod.Postort,
Fältkod.LandskodPostort,
Fältkod.Fodelsetid,
Fältkod.AnnatIDNr,
Fältkod.OrgNamn,
Fältkod.Gatuadress2,
Fältkod.FriAdress,
Fältkod.TIN,
};
private static readonly Fältkod[] _UppgiftslamnareLayout = new [] {
Fältkod.UppgiftslamnarId,
Fältkod.NamnUppgiftslamnare,
};
public override KULayout GetLayout() { return new KULayout(_KontrolluppgifterLayout, _InkomsttagareLayout, _UppgiftslamnareLayout); }
public long AvdragenSkatt {
get { return Data.GetValueOrDefault<long>(Fältkod.AvdragenSkatt); }
set { Data.AddOrUpdateValue(Fältkod.AvdragenSkatt, value); }
}
public bool Delagare {
get { return Data.GetValueOrDefault<bool>(Fältkod.Delagare); }
set { Data.AddOrUpdateValue(Fältkod.Delagare, value); }
}
public string LandskodTIN {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodTIN); }
set { Data.AddOrUpdateValue(Fältkod.LandskodTIN, value); }
}
public string Fodelseort {
get { return Data.GetValueOrDefault<string>(Fältkod.Fodelseort); }
set { Data.AddOrUpdateValue(Fältkod.Fodelseort, value); }
}
public string LandskodFodelseort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodFodelseort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodFodelseort, value); }
}
public string UppgiftslamnarId {
get { return Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId); }
set { Data.AddOrUpdateValue(Fältkod.UppgiftslamnarId, value); }
}
public string NamnUppgiftslamnare {
get { return Data.GetValueOrDefault<string>(Fältkod.NamnUppgiftslamnare); }
set { Data.AddOrUpdateValue(Fältkod.NamnUppgiftslamnare, value); }
}
public int Inkomstar {
get { return Data.GetValueOrDefault<int>(Fältkod.Inkomstar); }
set { Data.AddOrUpdateValue(Fältkod.Inkomstar, value); }
}
public bool Borttag {
get { return Data.GetValueOrDefault<bool>(Fältkod.Borttag); }
set { Data.AddOrUpdateValue(Fältkod.Borttag, value); }
}
public bool Rattelse {
get { return Data.GetValueOrDefault<bool>(Fältkod.Rattelse); }
set { Data.AddOrUpdateValue(Fältkod.Rattelse, value); }
}
public string Inkomsttagare {
get { return Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare); }
set { Data.AddOrUpdateValue(Fältkod.Inkomsttagare, value); }
}
public string Fornamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Fornamn); }
set { Data.AddOrUpdateValue(Fältkod.Fornamn, value); }
}
public string Efternamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Efternamn); }
set { Data.AddOrUpdateValue(Fältkod.Efternamn, value); }
}
public string Gatuadress {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress, value); }
}
public string Postnummer {
get { return Data.GetValueOrDefault<string>(Fältkod.Postnummer); }
set { Data.AddOrUpdateValue(Fältkod.Postnummer, value); }
}
public string Postort {
get { return Data.GetValueOrDefault<string>(Fältkod.Postort); }
set { Data.AddOrUpdateValue(Fältkod.Postort, value); }
}
public string LandskodPostort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodPostort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodPostort, value); }
}
public long Fodelsetid {
get { return Data.GetValueOrDefault<long>(Fältkod.Fodelsetid); }
set { Data.AddOrUpdateValue(Fältkod.Fodelsetid, value); }
}
public string AnnatIDNr {
get { return Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr); }
set { Data.AddOrUpdateValue(Fältkod.AnnatIDNr, value); }
}
public string OrgNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.OrgNamn); }
set { Data.AddOrUpdateValue(Fältkod.OrgNamn, value); }
}
public string Gatuadress2 {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress2); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress2, value); }
}
public string FriAdress {
get { return Data.GetValueOrDefault<string>(Fältkod.FriAdress); }
set { Data.AddOrUpdateValue(Fältkod.FriAdress, value); }
}
public string TIN {
get { return Data.GetValueOrDefault<string>(Fältkod.TIN); }
set { Data.AddOrUpdateValue(Fältkod.TIN, value); }
}
public long Ranteinkomst {
get { return Data.GetValueOrDefault<long>(Fältkod.Ranteinkomst); }
set { Data.AddOrUpdateValue(Fältkod.Ranteinkomst, value); }
}
public bool Forfogarkonto {
get { return Data.GetValueOrDefault<bool>(Fältkod.Forfogarkonto); }
set { Data.AddOrUpdateValue(Fältkod.Forfogarkonto, value); }
}
public long RanteinkomstEjKonto {
get { return Data.GetValueOrDefault<long>(Fältkod.RanteinkomstEjKonto); }
set { Data.AddOrUpdateValue(Fältkod.RanteinkomstEjKonto, value); }
}
public long AnnanInkomst {
get { return Data.GetValueOrDefault<long>(Fältkod.AnnanInkomst); }
set { Data.AddOrUpdateValue(Fältkod.AnnanInkomst, value); }
}
public long Specifikationsnummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Specifikationsnummer); }
set { Data.AddOrUpdateValue(Fältkod.Specifikationsnummer, value); }
}
}
[Blankettnummer(2335)]
public partial class KU28 : KU {
private static readonly Fältkod[] _KontrolluppgifterLayout = new [] {
Fältkod.Delagare,
Fältkod.Inkomstar,
Fältkod.Borttag,
Fältkod.UnderlagForInvesteraravdrag,
Fältkod.TotUnderlagInvesteraravdrag,
Fältkod.Betalningsar,
Fältkod.AterforingAvyttring,
Fältkod.AterforingUtflyttning,
Fältkod.AterforingHogVardeoverforing,
Fältkod.AterforingInternaForvarv,
Fältkod.Specifikationsnummer,
};
private static readonly Fältkod[] _InkomsttagareLayout = new [] {
Fältkod.LandskodTIN,
Fältkod.Inkomsttagare,
Fältkod.Fornamn,
Fältkod.Efternamn,
Fältkod.Gatuadress,
Fältkod.Postnummer,
Fältkod.Postort,
Fältkod.LandskodPostort,
Fältkod.Fodelsetid,
Fältkod.AnnatIDNr,
Fältkod.OrgNamn,
Fältkod.Gatuadress2,
Fältkod.FriAdress,
Fältkod.TIN,
};
private static readonly Fältkod[] _UppgiftslamnareLayout = new [] {
Fältkod.UppgiftslamnarId,
Fältkod.NamnUppgiftslamnare,
};
public override KULayout GetLayout() { return new KULayout(_KontrolluppgifterLayout, _InkomsttagareLayout, _UppgiftslamnareLayout); }
public bool Delagare {
get { return Data.GetValueOrDefault<bool>(Fältkod.Delagare); }
set { Data.AddOrUpdateValue(Fältkod.Delagare, value); }
}
public string LandskodTIN {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodTIN); }
set { Data.AddOrUpdateValue(Fältkod.LandskodTIN, value); }
}
public string UppgiftslamnarId {
get { return Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId); }
set { Data.AddOrUpdateValue(Fältkod.UppgiftslamnarId, value); }
}
public string NamnUppgiftslamnare {
get { return Data.GetValueOrDefault<string>(Fältkod.NamnUppgiftslamnare); }
set { Data.AddOrUpdateValue(Fältkod.NamnUppgiftslamnare, value); }
}
public int Inkomstar {
get { return Data.GetValueOrDefault<int>(Fältkod.Inkomstar); }
set { Data.AddOrUpdateValue(Fältkod.Inkomstar, value); }
}
public bool Borttag {
get { return Data.GetValueOrDefault<bool>(Fältkod.Borttag); }
set { Data.AddOrUpdateValue(Fältkod.Borttag, value); }
}
public bool Rattelse {
get { return Data.GetValueOrDefault<bool>(Fältkod.Rattelse); }
set { Data.AddOrUpdateValue(Fältkod.Rattelse, value); }
}
public string Inkomsttagare {
get { return Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare); }
set { Data.AddOrUpdateValue(Fältkod.Inkomsttagare, value); }
}
public string Fornamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Fornamn); }
set { Data.AddOrUpdateValue(Fältkod.Fornamn, value); }
}
public string Efternamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Efternamn); }
set { Data.AddOrUpdateValue(Fältkod.Efternamn, value); }
}
public string Gatuadress {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress, value); }
}
public string Postnummer {
get { return Data.GetValueOrDefault<string>(Fältkod.Postnummer); }
set { Data.AddOrUpdateValue(Fältkod.Postnummer, value); }
}
public string Postort {
get { return Data.GetValueOrDefault<string>(Fältkod.Postort); }
set { Data.AddOrUpdateValue(Fältkod.Postort, value); }
}
public string LandskodPostort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodPostort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodPostort, value); }
}
public long Fodelsetid {
get { return Data.GetValueOrDefault<long>(Fältkod.Fodelsetid); }
set { Data.AddOrUpdateValue(Fältkod.Fodelsetid, value); }
}
public string AnnatIDNr {
get { return Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr); }
set { Data.AddOrUpdateValue(Fältkod.AnnatIDNr, value); }
}
public string OrgNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.OrgNamn); }
set { Data.AddOrUpdateValue(Fältkod.OrgNamn, value); }
}
public string Gatuadress2 {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress2); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress2, value); }
}
public string FriAdress {
get { return Data.GetValueOrDefault<string>(Fältkod.FriAdress); }
set { Data.AddOrUpdateValue(Fältkod.FriAdress, value); }
}
public string TIN {
get { return Data.GetValueOrDefault<string>(Fältkod.TIN); }
set { Data.AddOrUpdateValue(Fältkod.TIN, value); }
}
public long UnderlagForInvesteraravdrag {
get { return Data.GetValueOrDefault<long>(Fältkod.UnderlagForInvesteraravdrag); }
set { Data.AddOrUpdateValue(Fältkod.UnderlagForInvesteraravdrag, value); }
}
public long TotUnderlagInvesteraravdrag {
get { return Data.GetValueOrDefault<long>(Fältkod.TotUnderlagInvesteraravdrag); }
set { Data.AddOrUpdateValue(Fältkod.TotUnderlagInvesteraravdrag, value); }
}
public bool Betalningsar {
get { return Data.GetValueOrDefault<bool>(Fältkod.Betalningsar); }
set { Data.AddOrUpdateValue(Fältkod.Betalningsar, value); }
}
public bool AterforingAvyttring {
get { return Data.GetValueOrDefault<bool>(Fältkod.AterforingAvyttring); }
set { Data.AddOrUpdateValue(Fältkod.AterforingAvyttring, value); }
}
public bool AterforingUtflyttning {
get { return Data.GetValueOrDefault<bool>(Fältkod.AterforingUtflyttning); }
set { Data.AddOrUpdateValue(Fältkod.AterforingUtflyttning, value); }
}
public bool AterforingHogVardeoverforing {
get { return Data.GetValueOrDefault<bool>(Fältkod.AterforingHogVardeoverforing); }
set { Data.AddOrUpdateValue(Fältkod.AterforingHogVardeoverforing, value); }
}
public bool AterforingInternaForvarv {
get { return Data.GetValueOrDefault<bool>(Fältkod.AterforingInternaForvarv); }
set { Data.AddOrUpdateValue(Fältkod.AterforingInternaForvarv, value); }
}
public long Specifikationsnummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Specifikationsnummer); }
set { Data.AddOrUpdateValue(Fältkod.Specifikationsnummer, value); }
}
}
[Blankettnummer(2322)]
public partial class KU31 : KU {
private static readonly Fältkod[] _KontrolluppgifterLayout = new [] {
Fältkod.AvdragenSkatt,
Fältkod.AvdragenUtlandskSkatt,
Fältkod.AvdragenKupongskatt,
Fältkod.Delagare,
Fältkod.Inkomstar,
Fältkod.Borttag,
Fältkod.AnnanInkomst,
Fältkod.Depanummer,
Fältkod.AndelAvDepan,
Fältkod.Specifikationsnummer,
Fältkod.VPNamn,
Fältkod.ISIN,
Fältkod.UtbetaldUtdelning,
Fältkod.AnnanKupongErsattning,
Fältkod.OkandVarde,
Fältkod.Avstamningsdag,
};
private static readonly Fältkod[] _InkomsttagareLayout = new [] {
Fältkod.LandskodTIN,
Fältkod.Fodelseort,
Fältkod.LandskodFodelseort,
Fältkod.LandskodHemvist,
Fältkod.Inkomsttagare,
Fältkod.Fornamn,
Fältkod.Efternamn,
Fältkod.Gatuadress,
Fältkod.Postnummer,
Fältkod.Postort,
Fältkod.LandskodPostort,
Fältkod.Fodelsetid,
Fältkod.AnnatIDNr,
Fältkod.OrgNamn,
Fältkod.Gatuadress2,
Fältkod.FriAdress,
Fältkod.TIN,
};
private static readonly Fältkod[] _UppgiftslamnareLayout = new [] {
Fältkod.UppgiftslamnarId,
Fältkod.NamnUppgiftslamnare,
};
public override KULayout GetLayout() { return new KULayout(_KontrolluppgifterLayout, _InkomsttagareLayout, _UppgiftslamnareLayout); }
public long AvdragenSkatt {
get { return Data.GetValueOrDefault<long>(Fältkod.AvdragenSkatt); }
set { Data.AddOrUpdateValue(Fältkod.AvdragenSkatt, value); }
}
public long AvdragenUtlandskSkatt {
get { return Data.GetValueOrDefault<long>(Fältkod.AvdragenUtlandskSkatt); }
set { Data.AddOrUpdateValue(Fältkod.AvdragenUtlandskSkatt, value); }
}
public long AvdragenKupongskatt {
get { return Data.GetValueOrDefault<long>(Fältkod.AvdragenKupongskatt); }
set { Data.AddOrUpdateValue(Fältkod.AvdragenKupongskatt, value); }
}
public bool Delagare {
get { return Data.GetValueOrDefault<bool>(Fältkod.Delagare); }
set { Data.AddOrUpdateValue(Fältkod.Delagare, value); }
}
public string LandskodTIN {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodTIN); }
set { Data.AddOrUpdateValue(Fältkod.LandskodTIN, value); }
}
public string Fodelseort {
get { return Data.GetValueOrDefault<string>(Fältkod.Fodelseort); }
set { Data.AddOrUpdateValue(Fältkod.Fodelseort, value); }
}
public string LandskodFodelseort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodFodelseort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodFodelseort, value); }
}
public string LandskodHemvist {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodHemvist); }
set { Data.AddOrUpdateValue(Fältkod.LandskodHemvist, value); }
}
public string UppgiftslamnarId {
get { return Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId); }
set { Data.AddOrUpdateValue(Fältkod.UppgiftslamnarId, value); }
}
public string NamnUppgiftslamnare {
get { return Data.GetValueOrDefault<string>(Fältkod.NamnUppgiftslamnare); }
set { Data.AddOrUpdateValue(Fältkod.NamnUppgiftslamnare, value); }
}
public int Inkomstar {
get { return Data.GetValueOrDefault<int>(Fältkod.Inkomstar); }
set { Data.AddOrUpdateValue(Fältkod.Inkomstar, value); }
}
public bool Borttag {
get { return Data.GetValueOrDefault<bool>(Fältkod.Borttag); }
set { Data.AddOrUpdateValue(Fältkod.Borttag, value); }
}
public bool Rattelse {
get { return Data.GetValueOrDefault<bool>(Fältkod.Rattelse); }
set { Data.AddOrUpdateValue(Fältkod.Rattelse, value); }
}
public string Inkomsttagare {
get { return Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare); }
set { Data.AddOrUpdateValue(Fältkod.Inkomsttagare, value); }
}
public string Fornamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Fornamn); }
set { Data.AddOrUpdateValue(Fältkod.Fornamn, value); }
}
public string Efternamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Efternamn); }
set { Data.AddOrUpdateValue(Fältkod.Efternamn, value); }
}
public string Gatuadress {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress, value); }
}
public string Postnummer {
get { return Data.GetValueOrDefault<string>(Fältkod.Postnummer); }
set { Data.AddOrUpdateValue(Fältkod.Postnummer, value); }
}
public string Postort {
get { return Data.GetValueOrDefault<string>(Fältkod.Postort); }
set { Data.AddOrUpdateValue(Fältkod.Postort, value); }
}
public string LandskodPostort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodPostort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodPostort, value); }
}
public long Fodelsetid {
get { return Data.GetValueOrDefault<long>(Fältkod.Fodelsetid); }
set { Data.AddOrUpdateValue(Fältkod.Fodelsetid, value); }
}
public string AnnatIDNr {
get { return Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr); }
set { Data.AddOrUpdateValue(Fältkod.AnnatIDNr, value); }
}
public string OrgNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.OrgNamn); }
set { Data.AddOrUpdateValue(Fältkod.OrgNamn, value); }
}
public string Gatuadress2 {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress2); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress2, value); }
}
public string FriAdress {
get { return Data.GetValueOrDefault<string>(Fältkod.FriAdress); }
set { Data.AddOrUpdateValue(Fältkod.FriAdress, value); }
}
public string TIN {
get { return Data.GetValueOrDefault<string>(Fältkod.TIN); }
set { Data.AddOrUpdateValue(Fältkod.TIN, value); }
}
public string Hemviststat {
get { return Data.GetValueOrDefault<string>(Fältkod.Hemviststat); }
set { Data.AddOrUpdateValue(Fältkod.Hemviststat, value); }
}
public long AnnanInkomst {
get { return Data.GetValueOrDefault<long>(Fältkod.AnnanInkomst); }
set { Data.AddOrUpdateValue(Fältkod.AnnanInkomst, value); }
}
public long Depanummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Depanummer); }
set { Data.AddOrUpdateValue(Fältkod.Depanummer, value); }
}
public decimal AndelAvDepan {
get { return Data.GetValueOrDefault<decimal>(Fältkod.AndelAvDepan); }
set { Data.AddOrUpdateValue(Fältkod.AndelAvDepan, value); }
}
public long Specifikationsnummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Specifikationsnummer); }
set { Data.AddOrUpdateValue(Fältkod.Specifikationsnummer, value); }
}
public string VPNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.VPNamn); }
set { Data.AddOrUpdateValue(Fältkod.VPNamn, value); }
}
public string ISIN {
get { return Data.GetValueOrDefault<string>(Fältkod.ISIN); }
set { Data.AddOrUpdateValue(Fältkod.ISIN, value); }
}
public long UtbetaldUtdelning {
get { return Data.GetValueOrDefault<long>(Fältkod.UtbetaldUtdelning); }
set { Data.AddOrUpdateValue(Fältkod.UtbetaldUtdelning, value); }
}
public long AnnanKupongErsattning {
get { return Data.GetValueOrDefault<long>(Fältkod.AnnanKupongErsattning); }
set { Data.AddOrUpdateValue(Fältkod.AnnanKupongErsattning, value); }
}
public bool OkandVarde {
get { return Data.GetValueOrDefault<bool>(Fältkod.OkandVarde); }
set { Data.AddOrUpdateValue(Fältkod.OkandVarde, value); }
}
public DateTime Avstamningsdag {
get { return Data.GetValueOrDefault<DateTime>(Fältkod.Avstamningsdag); }
set { Data.AddOrUpdateValue(Fältkod.Avstamningsdag, value); }
}
}
[Blankettnummer(2318)]
public partial class KU32 : KU {
private static readonly Fältkod[] _KontrolluppgifterLayout = new [] {
Fältkod.Delagare,
Fältkod.Inkomstar,
Fältkod.Borttag,
Fältkod.Depanummer,
Fältkod.AndelAvDepan,
Fältkod.Specifikationsnummer,
Fältkod.VPNamn,
Fältkod.ISIN,
Fältkod.AvyttradTillISK,
Fältkod.AntalAvyttrade,
Fältkod.OkandVarde,
Fältkod.ErhallenErsattning,
};
private static readonly Fältkod[] _InkomsttagareLayout = new [] {
Fältkod.LandskodTIN,
Fältkod.Inkomsttagare,
Fältkod.Fornamn,
Fältkod.Efternamn,
Fältkod.Gatuadress,
Fältkod.Postnummer,
Fältkod.Postort,
Fältkod.LandskodPostort,
Fältkod.Fodelsetid,
Fältkod.AnnatIDNr,
Fältkod.OrgNamn,
Fältkod.Gatuadress2,
Fältkod.FriAdress,
Fältkod.TIN,
};
private static readonly Fältkod[] _UppgiftslamnareLayout = new [] {
Fältkod.UppgiftslamnarId,
Fältkod.NamnUppgiftslamnare,
};
public override KULayout GetLayout() { return new KULayout(_KontrolluppgifterLayout, _InkomsttagareLayout, _UppgiftslamnareLayout); }
public bool Delagare {
get { return Data.GetValueOrDefault<bool>(Fältkod.Delagare); }
set { Data.AddOrUpdateValue(Fältkod.Delagare, value); }
}
public string LandskodTIN {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodTIN); }
set { Data.AddOrUpdateValue(Fältkod.LandskodTIN, value); }
}
public string UppgiftslamnarId {
get { return Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId); }
set { Data.AddOrUpdateValue(Fältkod.UppgiftslamnarId, value); }
}
public string NamnUppgiftslamnare {
get { return Data.GetValueOrDefault<string>(Fältkod.NamnUppgiftslamnare); }
set { Data.AddOrUpdateValue(Fältkod.NamnUppgiftslamnare, value); }
}
public int Inkomstar {
get { return Data.GetValueOrDefault<int>(Fältkod.Inkomstar); }
set { Data.AddOrUpdateValue(Fältkod.Inkomstar, value); }
}
public bool Borttag {
get { return Data.GetValueOrDefault<bool>(Fältkod.Borttag); }
set { Data.AddOrUpdateValue(Fältkod.Borttag, value); }
}
public bool Rattelse {
get { return Data.GetValueOrDefault<bool>(Fältkod.Rattelse); }
set { Data.AddOrUpdateValue(Fältkod.Rattelse, value); }
}
public string Inkomsttagare {
get { return Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare); }
set { Data.AddOrUpdateValue(Fältkod.Inkomsttagare, value); }
}
public string Fornamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Fornamn); }
set { Data.AddOrUpdateValue(Fältkod.Fornamn, value); }
}
public string Efternamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Efternamn); }
set { Data.AddOrUpdateValue(Fältkod.Efternamn, value); }
}
public string Gatuadress {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress, value); }
}
public string Postnummer {
get { return Data.GetValueOrDefault<string>(Fältkod.Postnummer); }
set { Data.AddOrUpdateValue(Fältkod.Postnummer, value); }
}
public string Postort {
get { return Data.GetValueOrDefault<string>(Fältkod.Postort); }
set { Data.AddOrUpdateValue(Fältkod.Postort, value); }
}
public string LandskodPostort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodPostort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodPostort, value); }
}
public long Fodelsetid {
get { return Data.GetValueOrDefault<long>(Fältkod.Fodelsetid); }
set { Data.AddOrUpdateValue(Fältkod.Fodelsetid, value); }
}
public string AnnatIDNr {
get { return Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr); }
set { Data.AddOrUpdateValue(Fältkod.AnnatIDNr, value); }
}
public string OrgNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.OrgNamn); }
set { Data.AddOrUpdateValue(Fältkod.OrgNamn, value); }
}
public string Gatuadress2 {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress2); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress2, value); }
}
public string FriAdress {
get { return Data.GetValueOrDefault<string>(Fältkod.FriAdress); }
set { Data.AddOrUpdateValue(Fältkod.FriAdress, value); }
}
public string TIN {
get { return Data.GetValueOrDefault<string>(Fältkod.TIN); }
set { Data.AddOrUpdateValue(Fältkod.TIN, value); }
}
public long Depanummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Depanummer); }
set { Data.AddOrUpdateValue(Fältkod.Depanummer, value); }
}
public decimal AndelAvDepan {
get { return Data.GetValueOrDefault<decimal>(Fältkod.AndelAvDepan); }
set { Data.AddOrUpdateValue(Fältkod.AndelAvDepan, value); }
}
public long Specifikationsnummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Specifikationsnummer); }
set { Data.AddOrUpdateValue(Fältkod.Specifikationsnummer, value); }
}
public string VPNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.VPNamn); }
set { Data.AddOrUpdateValue(Fältkod.VPNamn, value); }
}
public string ISIN {
get { return Data.GetValueOrDefault<string>(Fältkod.ISIN); }
set { Data.AddOrUpdateValue(Fältkod.ISIN, value); }
}
public bool AvyttradTillISK {
get { return Data.GetValueOrDefault<bool>(Fältkod.AvyttradTillISK); }
set { Data.AddOrUpdateValue(Fältkod.AvyttradTillISK, value); }
}
public long AntalAvyttrade {
get { return Data.GetValueOrDefault<long>(Fältkod.AntalAvyttrade); }
set { Data.AddOrUpdateValue(Fältkod.AntalAvyttrade, value); }
}
public bool OkandVarde {
get { return Data.GetValueOrDefault<bool>(Fältkod.OkandVarde); }
set { Data.AddOrUpdateValue(Fältkod.OkandVarde, value); }
}
public long ErhallenErsattning {
get { return Data.GetValueOrDefault<long>(Fältkod.ErhallenErsattning); }
set { Data.AddOrUpdateValue(Fältkod.ErhallenErsattning, value); }
}
}
public enum Fältkod {
[Fälttyp(Fälttyp.Belopp,10)]
AvdragenSkatt = 1,
[Fälttyp(Fälttyp.Kryss,-1)]
Delagare = 61,
[Fälttyp(Fälttyp.Landskod,-1)]
LandskodTIN = 76,
[Fälttyp(Fälttyp.Text,35)]
Fodelseort = 77,
[Fälttyp(Fälttyp.Landskod,-1)]
LandskodFodelseort = 78,
[Fälttyp(Fälttyp.Identitet,-1)]
UppgiftslamnarId = 201,
[Fälttyp(Fälttyp.Text,50)]
NamnUppgiftslamnare = 202,
[Fälttyp(Fälttyp.Inkomstar,-1)]
Inkomstar = 203,
[Fälttyp(Fälttyp.Kryss,-1)]
Borttag = 205,
[Fälttyp(Fälttyp.Kryss,-1)]
Rattelse = 210,
[Fälttyp(Fälttyp.Identitet,-1)]
Inkomsttagare = 215,
[Fälttyp(Fälttyp.Text,50)]
Fornamn = 216,
[Fälttyp(Fälttyp.Text,50)]
Efternamn = 217,
[Fälttyp(Fälttyp.Text,50)]
Gatuadress = 218,
[Fälttyp(Fälttyp.PostNummer,-1)]
Postnummer = 219,
[Fälttyp(Fälttyp.Text,50)]
Postort = 220,
[Fälttyp(Fälttyp.Landskod,-1)]
LandskodPostort = 221,
[Fälttyp(Fälttyp.Fodelsetid,-1)]
Fodelsetid = 222,
[Fälttyp(Fälttyp.Text,20)]
AnnatIDNr = 224,
[Fälttyp(Fälttyp.Text,50)]
OrgNamn = 226,
[Fälttyp(Fälttyp.Text,50)]
Gatuadress2 = 228,
[Fälttyp(Fälttyp.Text,350)]
FriAdress = 230,
[Fälttyp(Fälttyp.Text,20)]
TIN = 252,
[Fälttyp(Fälttyp.Belopp,10)]
Ranteinkomst = 500,
[Fälttyp(Fälttyp.Kryss,-1)]
Forfogarkonto = 502,
[Fälttyp(Fälttyp.Belopp,10)]
RanteinkomstEjKonto = 503,
[Fälttyp(Fälttyp.Belopp,7)]
AnnanInkomst = 504,
[Fälttyp(Fälttyp.SpecifikationsNummer,-1)]
Specifikationsnummer = 570,
[Fälttyp(Fälttyp.Belopp,10)]
UnderlagForInvesteraravdrag = 528,
[Fälttyp(Fälttyp.Belopp,10)]
TotUnderlagInvesteraravdrag = 529,
[Fälttyp(Fälttyp.Kryss,-1)]
Betalningsar = 530,
[Fälttyp(Fälttyp.Kryss,-1)]
AterforingAvyttring = 531,
[Fälttyp(Fälttyp.Kryss,-1)]
AterforingUtflyttning = 532,
[Fälttyp(Fälttyp.Kryss,-1)]
AterforingHogVardeoverforing = 533,
[Fälttyp(Fälttyp.Kryss,-1)]
AterforingInternaForvarv = 534,
[Fälttyp(Fälttyp.Belopp,10)]
AvdragenUtlandskSkatt = 2,
[Fälttyp(Fälttyp.Belopp,10)]
AvdragenKupongskatt = 3,
[Fälttyp(Fälttyp.Landskod,-1)]
LandskodHemvist = 79,
[Fälttyp(Fälttyp.Text,30)]
Hemviststat = 256,
[Fälttyp(Fälttyp.Belopp,12)]
Depanummer = 523,
[Fälttyp(Fälttyp.Decimal,2)]
AndelAvDepan = 524,
[Fälttyp(Fälttyp.Text,50)]
VPNamn = 571,
[Fälttyp(Fälttyp.Isin,-1)]
ISIN = 572,
[Fälttyp(Fälttyp.Belopp,10)]
UtbetaldUtdelning = 574,
[Fälttyp(Fälttyp.Belopp,10)]
AnnanKupongErsattning = 581,
[Fälttyp(Fälttyp.Kryss,-1)]
OkandVarde = 599,
[Fälttyp(Fälttyp.Datum,-1)]
Avstamningsdag = 853,
[Fälttyp(Fälttyp.Kryss,-1)]
AvyttradTillISK = 573,
[Fälttyp(Fälttyp.Belopp,12)]
AntalAvyttrade = 576,
[Fälttyp(Fälttyp.Belopp,10)]
ErhallenErsattning = 810,
}
public enum Fälttyp {
Okänd = 0, // felaktig typ
Belopp,
Kryss,
Landskod,
Text,
Identitet,
Inkomstar,
PostNummer,
Fodelsetid,
SpecifikationsNummer,
Decimal,
Isin,
Datum,
}
}


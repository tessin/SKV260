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
// 540 -> AvdragsgillRanta,Belopp,10,HELTAL
// 541 -> TotaltInbetaldRanta,Belopp,10,HELTAL
// 543 -> BetaldRantekompensation,Belopp,10,HELTAL
// 544 -> GemensamtLan,Kryss,-1,KRYSSRUTA
// 528 -> UnderlagForInvesteraravdrag,Belopp,10,HELTAL
// 529 -> TotUnderlagInvesteraravdrag,Belopp,10,HELTAL
// 530 -> Betalningsar,Kryss,-1,KRYSSRUTA
// 531 -> AterforingAvyttring,Kryss,-1,KRYSSRUTA
// 532 -> AterforingUtflyttning,Kryss,-1,KRYSSRUTA
// 533 -> AterforingHogVardeoverforing,Kryss,-1,KRYSSRUTA
// 534 -> AterforingInternaForvarv,Kryss,-1,KRYSSRUTA
// 535 -> DatumForvarv,Datum,-1,DATUM
// 536 -> Region,Region,-1,REGION
// 537 -> Verksamhetsomrade,Verksamhetsomrade,-1,VERKSAMHETSOMRADE
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
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 001</para>
///<para>Elementnamn XML-fil: AvdragenSkatt</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>Beskrivning: Avdragen preliminär skatt</para>
///</summary>
public long AvdragenSkatt {
get { return Data.GetValueOrDefault<long>(Fältkod.AvdragenSkatt); }
set { Data.AddOrUpdateValue(Fältkod.AvdragenSkatt, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 061</para>
///<para>Elementnamn XML-fil: Delagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>Beskrivning: Delägare m.fl. i fåmansföretag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här markerar du om ditt företag är ett: • fåmansföretag och om den person som kontrolluppgiften gäller är företagsledare, närstående till sådan person eller delägare i företaget • fåmanshandelsbolag och om den person kontrolluppgiften gäller är företagsledare eller närstående till en sådan person utan att vara delägare i handelsbolaget.</para>
///</summary>
public bool Delagare {
get { return Data.GetValueOrDefault<bool>(Fältkod.Delagare); }
set { Data.AddOrUpdateValue(Fältkod.Delagare, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 076</para>
///<para>Elementnamn XML-fil: LandskodTIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 045</para>
///<para>SambandskontrollText: Om Fk252 finns ska Fk076 finnas.</para>
///<para>Beskrivning: TIN-land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: I de fall utländskt skatteregistreringsnummer (TIN) lämnas ska uppgift även lämnas om vilket land som utfärdat numret.</para>
///</summary>
public string LandskodTIN {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodTIN); }
set { Data.AddOrUpdateValue(Fältkod.LandskodTIN, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 077</para>
///<para>Elementnamn XML-fil: Fodelseort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text35</para>
///<para>Beskrivning: Födelseort</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i födelseort om den uppgiften gäller är bosatt utomlands och uppgift om utländskt skatteregistreringsnummer saknas.</para>
///</summary>
public string Fodelseort {
get { return Data.GetValueOrDefault<string>(Fältkod.Fodelseort); }
set { Data.AddOrUpdateValue(Fältkod.Fodelseort, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 078</para>
///<para>Elementnamn XML-fil: LandskodFodelseort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 046</para>
///<para>SambandskontrollText: Fk078 ska finnas om Fk077 finns.</para>
///<para>Beskrivning: Landskod</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Land där födelseorten ligger.</para>
///</summary>
public string LandskodFodelseort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodFodelseort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodFodelseort, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 201</para>
///<para>Elementnamn XML-fil: UppgiftslamnarId</para>
///<para>Obl: J</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 053</para>
///<para>SambandskontrollText: Fk201 får ej vara identisk med Fk215.</para>
///<para>Beskrivning: Organisationsnummer</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string UppgiftslamnarId {
get { return Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId); }
set { Data.AddOrUpdateValue(Fältkod.UppgiftslamnarId, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 202</para>
///<para>Elementnamn XML-fil: NamnUppgiftslamnare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Uppgiftslämnarens namn</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string NamnUppgiftslamnare {
get { return Data.GetValueOrDefault<string>(Fältkod.NamnUppgiftslamnare); }
set { Data.AddOrUpdateValue(Fältkod.NamnUppgiftslamnare, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 203</para>
///<para>Elementnamn XML-fil: Inkomstar</para>
///<para>Obl: J</para>
///<para>Fälttyp: Inkomstar</para>
///<para>Beskrivning: Inkomstår</para>
///</summary>
public int Inkomstar {
get { return Data.GetValueOrDefault<int>(Fältkod.Inkomstar); }
set { Data.AddOrUpdateValue(Fältkod.Inkomstar, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 205</para>
///<para>Elementnamn XML-fil: Borttag</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 055</para>
///<para>SambandskontrollText: Fk205 får bara finnas om alla fältkoder förutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 är tomma.</para>
///<para>Beskrivning: Borttags-KU</para>
///</summary>
public bool Borttag {
get { return Data.GetValueOrDefault<bool>(Fältkod.Borttag); }
set { Data.AddOrUpdateValue(Fältkod.Borttag, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 210</para>
///<para>Elementnamn XML-fil: Rattelse</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///</summary>
public bool Rattelse {
get { return Data.GetValueOrDefault<bool>(Fältkod.Rattelse); }
set { Data.AddOrUpdateValue(Fältkod.Rattelse, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 215</para>
///<para>Elementnamn XML-fil: Inkomsttagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 056</para>
///<para>SambandskontrollText: Fk215 ska finnas om Fk222 och Fk224 saknas.</para>
///<para>Beskrivning: Personnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer för fysisk person eller organisationsnummer för juridisk person. För personer med samordningsnummer ska namn- och adressuppgifter skrivas i fält 216-221.</para>
///</summary>
public string Inkomsttagare {
get { return Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare); }
set { Data.AddOrUpdateValue(Fältkod.Inkomsttagare, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 216</para>
///<para>Elementnamn XML-fil: Fornamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 057,142</para>
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Förnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Fornamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Fornamn); }
set { Data.AddOrUpdateValue(Fältkod.Fornamn, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 217</para>
///<para>Elementnamn XML-fil: Efternamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 058,143</para>
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Efternamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Efternamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Efternamn); }
set { Data.AddOrUpdateValue(Fältkod.Efternamn, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 218</para>
///<para>Elementnamn XML-fil: Gatuadress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 059,144,152</para>
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Gatuadress</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Gatuadress {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 219</para>
///<para>Elementnamn XML-fil: Postnummer</para>
///<para>Obl: N</para>
///<para>Fälttyp: PostNummer</para>
///<para>SambandskontrollID: 060,145,153</para>
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges istället i fält 221 nedan.</para>
///</summary>
public string Postnummer {
get { return Data.GetValueOrDefault<string>(Fältkod.Postnummer); }
set { Data.AddOrUpdateValue(Fältkod.Postnummer, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 220</para>
///<para>Elementnamn XML-fil: Postort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 061,146,154</para>
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postort</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Postort {
get { return Data.GetValueOrDefault<string>(Fältkod.Postort); }
set { Data.AddOrUpdateValue(Fältkod.Postort, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 221</para>
///<para>Elementnamn XML-fil: LandskodPostort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 166</para>
///<para>SambandskontrollText: Fk221 ska finnas om Fk230 finns</para>
///<para>Beskrivning: Land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string LandskodPostort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodPostort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodPostort, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 222</para>
///<para>Elementnamn XML-fil: Fodelsetid</para>
///<para>Obl: N</para>
///<para>Fälttyp: Fodelsetid</para>
///<para>SambandskontrollID: 063</para>
///<para>SambandskontrollText: Om Fk215 finns får inte Fk222 finnas.</para>
///<para>Beskrivning: Födelsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns möjligheten att ange födelsetid istället. Födelsetiden anges med personens födelsedatum på samma sätt som i ett personnummer följt av tre valfria siffror (ÅÅÅÅMMDDnnn).</para>
///</summary>
public long Fodelsetid {
get { return Data.GetValueOrDefault<long>(Fältkod.Fodelsetid); }
set { Data.AddOrUpdateValue(Fältkod.Fodelsetid, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 224</para>
///<para>Elementnamn XML-fil: AnnatIDNr</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text20</para>
///<para>Beskrivning: Annat ID-nummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav för Annat ID-nummer.</para>
///</summary>
public string AnnatIDNr {
get { return Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr); }
set { Data.AddOrUpdateValue(Fältkod.AnnatIDNr, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 226</para>
///<para>Elementnamn XML-fil: OrgNamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 065,151</para>
///<para>SambandskontrollText: Fk226 får inte finnas om Fk222 finns, om Fk215 har SS>17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges för juridisk person istället för för- och efternamn.</para>
///</summary>
public string OrgNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.OrgNamn); }
set { Data.AddOrUpdateValue(Fältkod.OrgNamn, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 228</para>
///<para>Elementnamn XML-fil: Gatuadress2</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Gatuadress forts.</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du behöver mer utrymme för gatuadress, t.ex. för en c/o-adress.</para>
///</summary>
public string Gatuadress2 {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress2); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress2, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 230</para>
///<para>Elementnamn XML-fil: FriAdress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text350</para>
///<para>Beskrivning: Adress i fritt format</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utländsk adress inte går att dela in i gatuadress, postnummer och postort kan detta fält istället användas.</para>
///</summary>
public string FriAdress {
get { return Data.GetValueOrDefault<string>(Fältkod.FriAdress); }
set { Data.AddOrUpdateValue(Fältkod.FriAdress, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 252</para>
///<para>Elementnamn XML-fil: TIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text20</para>
///<para>SambandskontrollID: 066</para>
///<para>SambandskontrollText: Om Fk076 finns ska Fk252 finnas.</para>
///<para>Beskrivning: Utländskt skatteregistreringsnummer (TIN)</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Utländskt skatteregistreringsnummer, TIN (Tax Identification Number), ska alltid lämnas för person som är obegränsat skattskyldig i Sverige och har hemvist i annan stat. Personen, som uppgiften avser, får skatteregistreringsnumret av det land där han eller hon har sin skatterättsliga hemvist.</para>
///</summary>
public string TIN {
get { return Data.GetValueOrDefault<string>(Fältkod.TIN); }
set { Data.AddOrUpdateValue(Fältkod.TIN, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 500</para>
///<para>Elementnamn XML-fil: Ranteinkomst</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 070</para>
///<para>SambandskontrollText: Fk500 måste finnas om Fk205, Fk001, Fk503 och Fk504 saknas.</para>
///<para>Beskrivning: Ränteinkomst</para>
///</summary>
public long Ranteinkomst {
get { return Data.GetValueOrDefault<long>(Fältkod.Ranteinkomst); }
set { Data.AddOrUpdateValue(Fältkod.Ranteinkomst, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 502</para>
///<para>Elementnamn XML-fil: Forfogarkonto</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 071</para>
///<para>SambandskontrollText: Fk502 får inte finnas om Fk503 eller Fk504 finns.</para>
///<para>Beskrivning: Förfogarkonto (fler än fem)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera här om kontot innehas gemensamt av fler än fem personer (förfogarkonto). Då får hela räntan för kontot redovisas på en enda kontrolluppgift. Kontrolluppgiften lämnas med personnummer på den som svarar för kontot.</para>
///</summary>
public bool Forfogarkonto {
get { return Data.GetValueOrDefault<bool>(Fältkod.Forfogarkonto); }
set { Data.AddOrUpdateValue(Fältkod.Forfogarkonto, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 503</para>
///<para>Elementnamn XML-fil: RanteinkomstEjKonto</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>Beskrivning: Ränteinkomst, ej konto</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här redovisas summan av tillgodoräknad eller utbetald ränta från annat än inlåningskonton i bank.</para>
///</summary>
public long RanteinkomstEjKonto {
get { return Data.GetValueOrDefault<long>(Fältkod.RanteinkomstEjKonto); }
set { Data.AddOrUpdateValue(Fältkod.RanteinkomstEjKonto, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 504</para>
///<para>Elementnamn XML-fil: AnnanInkomst</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp7</para>
///<para>Beskrivning: Annan inkomst</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här redovisas annan inkomst än ränteinkomst.</para>
///</summary>
public long AnnanInkomst {
get { return Data.GetValueOrDefault<long>(Fältkod.AnnanInkomst); }
set { Data.AddOrUpdateValue(Fältkod.AnnanInkomst, value); }
}
///<summary>
///<para>KU-typ: KU20</para>
///<para>FK: 570</para>
///<para>Elementnamn XML-fil: Specifikationsnummer</para>
///<para>Obl: J</para>
///<para>Fälttyp: SpecifikationsNummer</para>
///<para>Beskrivning: Specifikationsnummer</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men lämnar du fler kontrolluppgifter av samma KU-typ för samma person måste de ha olika specifikationsnummer. Vill du senare kunna ändra eller ta bort en kontrolluppgift måste du då ange samma specifikationsnummer som nu.</para>
///</summary>
public long Specifikationsnummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Specifikationsnummer); }
set { Data.AddOrUpdateValue(Fältkod.Specifikationsnummer, value); }
}
}
[Blankettnummer(2336)]
public partial class KU25 : KU {
private static readonly Fältkod[] _KontrolluppgifterLayout = new [] {
Fältkod.Delagare,
Fältkod.Inkomstar,
Fältkod.Borttag,
Fältkod.AvdragsgillRanta,
Fältkod.TotaltInbetaldRanta,
Fältkod.BetaldRantekompensation,
Fältkod.GemensamtLan,
Fältkod.Specifikationsnummer,
};
private static readonly Fältkod[] _InkomsttagareLayout = new [] {
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
};
private static readonly Fältkod[] _UppgiftslamnareLayout = new [] {
Fältkod.UppgiftslamnarId,
Fältkod.NamnUppgiftslamnare,
};
public override KULayout GetLayout() { return new KULayout(_KontrolluppgifterLayout, _InkomsttagareLayout, _UppgiftslamnareLayout); }
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 061</para>
///<para>Elementnamn XML-fil: Delagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>Beskrivning: Delägare m.fl. i fåmansföretag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här markerar du om ditt företag är ett: • fåmansföretag och om den person som kontrolluppgiften gäller är företagsledare, närstående till sådan person eller delägare i företaget • fåmanshandelsbolag och om den person kontrolluppgiften gäller är företagsledare eller närstående till en sådan person utan att vara delägare i handelsbolaget.</para>
///</summary>
public bool Delagare {
get { return Data.GetValueOrDefault<bool>(Fältkod.Delagare); }
set { Data.AddOrUpdateValue(Fältkod.Delagare, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 201</para>
///<para>Elementnamn XML-fil: UppgiftslamnarId</para>
///<para>Obl: J</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 053</para>
///<para>SambandskontrollText: Fk201 får ej vara identisk med Fk215.</para>
///<para>Beskrivning: Organisationsnummer</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string UppgiftslamnarId {
get { return Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId); }
set { Data.AddOrUpdateValue(Fältkod.UppgiftslamnarId, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 202</para>
///<para>Elementnamn XML-fil: NamnUppgiftslamnare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Uppgiftslämnarens namn</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string NamnUppgiftslamnare {
get { return Data.GetValueOrDefault<string>(Fältkod.NamnUppgiftslamnare); }
set { Data.AddOrUpdateValue(Fältkod.NamnUppgiftslamnare, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 203</para>
///<para>Elementnamn XML-fil: Inkomstar</para>
///<para>Obl: J</para>
///<para>Fälttyp: Inkomstar</para>
///<para>Beskrivning: Inkomstår</para>
///</summary>
public int Inkomstar {
get { return Data.GetValueOrDefault<int>(Fältkod.Inkomstar); }
set { Data.AddOrUpdateValue(Fältkod.Inkomstar, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 205</para>
///<para>Elementnamn XML-fil: Borttag</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 055</para>
///<para>SambandskontrollText: Fk205 får bara finnas om alla fältkoder förutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 är tomma.</para>
///<para>Beskrivning: Borttags-KU</para>
///</summary>
public bool Borttag {
get { return Data.GetValueOrDefault<bool>(Fältkod.Borttag); }
set { Data.AddOrUpdateValue(Fältkod.Borttag, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 210</para>
///<para>Elementnamn XML-fil: Rattelse</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///</summary>
public bool Rattelse {
get { return Data.GetValueOrDefault<bool>(Fältkod.Rattelse); }
set { Data.AddOrUpdateValue(Fältkod.Rattelse, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 215</para>
///<para>Elementnamn XML-fil: Inkomsttagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 056</para>
///<para>SambandskontrollText: Fk215 ska finnas om Fk222 och Fk224 saknas.</para>
///<para>Beskrivning: Personnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer för fysisk person eller organisationsnummer för juridisk person. För personer med samordningsnummer ska namn- och adressuppgifter skrivas i fält 216-221.</para>
///</summary>
public string Inkomsttagare {
get { return Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare); }
set { Data.AddOrUpdateValue(Fältkod.Inkomsttagare, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 216</para>
///<para>Elementnamn XML-fil: Fornamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 057,142</para>
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Förnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Fornamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Fornamn); }
set { Data.AddOrUpdateValue(Fältkod.Fornamn, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 217</para>
///<para>Elementnamn XML-fil: Efternamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 058,143</para>
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Efternamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Efternamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Efternamn); }
set { Data.AddOrUpdateValue(Fältkod.Efternamn, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 218</para>
///<para>Elementnamn XML-fil: Gatuadress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 059,144,152</para>
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Gatuadress</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Gatuadress {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 219</para>
///<para>Elementnamn XML-fil: Postnummer</para>
///<para>Obl: N</para>
///<para>Fälttyp: PostNummer</para>
///<para>SambandskontrollID: 060,145,153</para>
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges istället i fält 221 nedan.</para>
///</summary>
public string Postnummer {
get { return Data.GetValueOrDefault<string>(Fältkod.Postnummer); }
set { Data.AddOrUpdateValue(Fältkod.Postnummer, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 220</para>
///<para>Elementnamn XML-fil: Postort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 061,146,154</para>
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postort</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Postort {
get { return Data.GetValueOrDefault<string>(Fältkod.Postort); }
set { Data.AddOrUpdateValue(Fältkod.Postort, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 221</para>
///<para>Elementnamn XML-fil: LandskodPostort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 166</para>
///<para>SambandskontrollText: Fk221 ska finnas om Fk230 finns</para>
///<para>Beskrivning: Land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string LandskodPostort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodPostort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodPostort, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 222</para>
///<para>Elementnamn XML-fil: Fodelsetid</para>
///<para>Obl: N</para>
///<para>Fälttyp: Fodelsetid</para>
///<para>SambandskontrollID: 063</para>
///<para>SambandskontrollText: Om Fk215 finns får inte Fk222 finnas.</para>
///<para>Beskrivning: Födelsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns möjligheten att ange födelsetid istället. Födelsetiden anges med personens födelsedatum på samma sätt som i ett personnummer följt av tre valfria siffror (ÅÅÅÅMMDDnnn).</para>
///</summary>
public long Fodelsetid {
get { return Data.GetValueOrDefault<long>(Fältkod.Fodelsetid); }
set { Data.AddOrUpdateValue(Fältkod.Fodelsetid, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 224</para>
///<para>Elementnamn XML-fil: AnnatIDNr</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text20</para>
///<para>Beskrivning: Annat ID-nummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav för Annat ID-nummer.</para>
///</summary>
public string AnnatIDNr {
get { return Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr); }
set { Data.AddOrUpdateValue(Fältkod.AnnatIDNr, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 226</para>
///<para>Elementnamn XML-fil: OrgNamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 065,151</para>
///<para>SambandskontrollText: Fk226 får inte finnas om Fk222 finns, om Fk215 har SS>17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges för juridisk person istället för för- och efternamn.</para>
///</summary>
public string OrgNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.OrgNamn); }
set { Data.AddOrUpdateValue(Fältkod.OrgNamn, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 228</para>
///<para>Elementnamn XML-fil: Gatuadress2</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Gatuadress forts.</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du behöver mer utrymme för gatuadress, t.ex. för en c/o-adress.</para>
///</summary>
public string Gatuadress2 {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress2); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress2, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 230</para>
///<para>Elementnamn XML-fil: FriAdress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text350</para>
///<para>Beskrivning: Adress i fritt format</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utländsk adress inte går att dela in i gatuadress, postnummer och postort kan detta fält istället användas.</para>
///</summary>
public string FriAdress {
get { return Data.GetValueOrDefault<string>(Fältkod.FriAdress); }
set { Data.AddOrUpdateValue(Fältkod.FriAdress, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 540</para>
///<para>Elementnamn XML-fil: AvdragsgillRanta</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 081</para>
///<para>SambandskontrollText: Fk540 ska finnas om Fk205, Fk541 och Fk543 saknas.</para>
///<para>Beskrivning: Betald och för året avdragsgill ränta</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här redovisas under inkomståret betald ränta som avser tiden fram till 31 januari året efter inkomståret.</para>
///</summary>
public long AvdragsgillRanta {
get { return Data.GetValueOrDefault<long>(Fältkod.AvdragsgillRanta); }
set { Data.AddOrUpdateValue(Fältkod.AvdragsgillRanta, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 541</para>
///<para>Elementnamn XML-fil: TotaltInbetaldRanta</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 082</para>
///<para>SambandskontrollText: Om Fk541 finns och är större än noll och Fk540 finns så ska Fk541 vara >= Fk540</para>
///<para>Beskrivning: Totalt inbetald ränta (anges endast om förskotts-ränta erlagts som inte är avdragsgill för året)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här redovisas all ränta som betalats under inkomståret.</para>
///</summary>
public long TotaltInbetaldRanta {
get { return Data.GetValueOrDefault<long>(Fältkod.TotaltInbetaldRanta); }
set { Data.AddOrUpdateValue(Fältkod.TotaltInbetaldRanta, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 543</para>
///<para>Elementnamn XML-fil: BetaldRantekompensation</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>Beskrivning: Betald räntekompensation</para>
///</summary>
public long BetaldRantekompensation {
get { return Data.GetValueOrDefault<long>(Fältkod.BetaldRantekompensation); }
set { Data.AddOrUpdateValue(Fältkod.BetaldRantekompensation, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 544</para>
///<para>Elementnamn XML-fil: GemensamtLan</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>Beskrivning: Gemensamt lån för fler än fem personer där långivaren inte kan ange vilka samtliga personer är</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera här om kontrolluppgiften avser utgiftsränta på gemensamt lån som fler än fem personer har. Kontrolluppgiften lämnas med personnummer på den som svarar för lånet.</para>
///</summary>
public bool GemensamtLan {
get { return Data.GetValueOrDefault<bool>(Fältkod.GemensamtLan); }
set { Data.AddOrUpdateValue(Fältkod.GemensamtLan, value); }
}
///<summary>
///<para>KU-typ: KU25</para>
///<para>FK: 570</para>
///<para>Elementnamn XML-fil: Specifikationsnummer</para>
///<para>Obl: J</para>
///<para>Fälttyp: SpecifikationsNummer</para>
///<para>Beskrivning: Specifikationsnummer</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men lämnar du fler kontrolluppgifter av samma KU-typ för samma person måste de ha olika specifikationsnummer. Vill du senare kunna ändra eller ta bort en kontrolluppgift måste du då ange samma specifikationsnummer som nu.</para>
///</summary>
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
Fältkod.DatumForvarv,
Fältkod.Region,
Fältkod.Verksamhetsomrade,
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
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 061</para>
///<para>Elementnamn XML-fil: Delagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>Beskrivning: Delägare m.fl. i fåmansföretag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här markerar du om ditt företag är ett: • fåmansföretag och om den person som kontrolluppgiften gäller är företagsledare, närstående till sådan person eller delägare i företaget • fåmanshandelsbolag och om den person kontrolluppgiften gäller är företagsledare eller närstående till en sådan person utan att vara delägare i handelsbolaget.</para>
///</summary>
public bool Delagare {
get { return Data.GetValueOrDefault<bool>(Fältkod.Delagare); }
set { Data.AddOrUpdateValue(Fältkod.Delagare, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 076</para>
///<para>Elementnamn XML-fil: LandskodTIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 045</para>
///<para>SambandskontrollText: Om Fk252 finns ska Fk076 finnas.</para>
///<para>Beskrivning: TIN-land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: I de fall utländskt skatteregistreringsnummer (TIN) lämnas ska uppgift även lämnas om vilket land som utfärdat numret.</para>
///</summary>
public string LandskodTIN {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodTIN); }
set { Data.AddOrUpdateValue(Fältkod.LandskodTIN, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 201</para>
///<para>Elementnamn XML-fil: UppgiftslamnarId</para>
///<para>Obl: J</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 053</para>
///<para>SambandskontrollText: Fk201 får ej vara identisk med Fk215.</para>
///<para>Beskrivning: Organisationsnummer</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string UppgiftslamnarId {
get { return Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId); }
set { Data.AddOrUpdateValue(Fältkod.UppgiftslamnarId, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 202</para>
///<para>Elementnamn XML-fil: NamnUppgiftslamnare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Uppgiftslämnarens namn</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string NamnUppgiftslamnare {
get { return Data.GetValueOrDefault<string>(Fältkod.NamnUppgiftslamnare); }
set { Data.AddOrUpdateValue(Fältkod.NamnUppgiftslamnare, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 203</para>
///<para>Elementnamn XML-fil: Inkomstar</para>
///<para>Obl: J</para>
///<para>Fälttyp: Inkomstar</para>
///<para>Beskrivning: Inkomstår</para>
///</summary>
public int Inkomstar {
get { return Data.GetValueOrDefault<int>(Fältkod.Inkomstar); }
set { Data.AddOrUpdateValue(Fältkod.Inkomstar, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 205</para>
///<para>Elementnamn XML-fil: Borttag</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 055</para>
///<para>SambandskontrollText: Fk205 får bara finnas om alla fältkoder förutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 är tomma.</para>
///<para>Beskrivning: Borttags-KU</para>
///</summary>
public bool Borttag {
get { return Data.GetValueOrDefault<bool>(Fältkod.Borttag); }
set { Data.AddOrUpdateValue(Fältkod.Borttag, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 210</para>
///<para>Elementnamn XML-fil: Rattelse</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///</summary>
public bool Rattelse {
get { return Data.GetValueOrDefault<bool>(Fältkod.Rattelse); }
set { Data.AddOrUpdateValue(Fältkod.Rattelse, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 215</para>
///<para>Elementnamn XML-fil: Inkomsttagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 056</para>
///<para>SambandskontrollText: Fk215 ska finnas om Fk222 och Fk224 saknas.</para>
///<para>Beskrivning: Personnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer för fysisk person eller organisationsnummer för juridisk person. För personer med samordningsnummer ska namn- och adressuppgifter skrivas i fält 216-221.</para>
///</summary>
public string Inkomsttagare {
get { return Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare); }
set { Data.AddOrUpdateValue(Fältkod.Inkomsttagare, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 216</para>
///<para>Elementnamn XML-fil: Fornamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 057,142</para>
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Förnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Fornamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Fornamn); }
set { Data.AddOrUpdateValue(Fältkod.Fornamn, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 217</para>
///<para>Elementnamn XML-fil: Efternamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 058,143</para>
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Efternamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Efternamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Efternamn); }
set { Data.AddOrUpdateValue(Fältkod.Efternamn, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 218</para>
///<para>Elementnamn XML-fil: Gatuadress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 059,144,152</para>
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Gatuadress</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Gatuadress {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 219</para>
///<para>Elementnamn XML-fil: Postnummer</para>
///<para>Obl: N</para>
///<para>Fälttyp: PostNummer</para>
///<para>SambandskontrollID: 060,145,153</para>
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges istället i fält 221 nedan.</para>
///</summary>
public string Postnummer {
get { return Data.GetValueOrDefault<string>(Fältkod.Postnummer); }
set { Data.AddOrUpdateValue(Fältkod.Postnummer, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 220</para>
///<para>Elementnamn XML-fil: Postort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 061,146,154</para>
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postort</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Postort {
get { return Data.GetValueOrDefault<string>(Fältkod.Postort); }
set { Data.AddOrUpdateValue(Fältkod.Postort, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 221</para>
///<para>Elementnamn XML-fil: LandskodPostort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 166</para>
///<para>SambandskontrollText: Fk221 ska finnas om Fk230 finns</para>
///<para>Beskrivning: Land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string LandskodPostort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodPostort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodPostort, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 222</para>
///<para>Elementnamn XML-fil: Fodelsetid</para>
///<para>Obl: N</para>
///<para>Fälttyp: Fodelsetid</para>
///<para>SambandskontrollID: 063</para>
///<para>SambandskontrollText: Om Fk215 finns får inte Fk222 finnas.</para>
///<para>Beskrivning: Födelsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns möjligheten att ange födelsetid istället. Födelsetiden anges med personens födelsedatum på samma sätt som i ett personnummer följt av tre valfria siffror (ÅÅÅÅMMDDnnn).</para>
///</summary>
public long Fodelsetid {
get { return Data.GetValueOrDefault<long>(Fältkod.Fodelsetid); }
set { Data.AddOrUpdateValue(Fältkod.Fodelsetid, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 224</para>
///<para>Elementnamn XML-fil: AnnatIDNr</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text20</para>
///<para>Beskrivning: Annat ID-nummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav för Annat ID-nummer.</para>
///</summary>
public string AnnatIDNr {
get { return Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr); }
set { Data.AddOrUpdateValue(Fältkod.AnnatIDNr, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 226</para>
///<para>Elementnamn XML-fil: OrgNamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 065,151</para>
///<para>SambandskontrollText: Fk226 får inte finnas om Fk222 finns, om Fk215 har SS>17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges för juridisk person istället för för- och efternamn.</para>
///</summary>
public string OrgNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.OrgNamn); }
set { Data.AddOrUpdateValue(Fältkod.OrgNamn, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 228</para>
///<para>Elementnamn XML-fil: Gatuadress2</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Gatuadress forts.</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du behöver mer utrymme för gatuadress, t.ex. för en c/o-adress.</para>
///</summary>
public string Gatuadress2 {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress2); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress2, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 230</para>
///<para>Elementnamn XML-fil: FriAdress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text350</para>
///<para>Beskrivning: Adress i fritt format</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utländsk adress inte går att dela in i gatuadress, postnummer och postort kan detta fält istället användas.</para>
///</summary>
public string FriAdress {
get { return Data.GetValueOrDefault<string>(Fältkod.FriAdress); }
set { Data.AddOrUpdateValue(Fältkod.FriAdress, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 252</para>
///<para>Elementnamn XML-fil: TIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text20</para>
///<para>SambandskontrollID: 066</para>
///<para>SambandskontrollText: Om Fk076 finns ska Fk252 finnas.</para>
///<para>Beskrivning: Utländskt skatteregistreringsnummer (TIN)</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Utländskt skatteregistreringsnummer, TIN (Tax Identification Number), ska alltid lämnas för person som är obegränsat skattskyldig i Sverige och har hemvist i annan stat. Personen, som uppgiften avser, får skatteregistreringsnumret av det land där han eller hon har sin skatterättsliga hemvist.</para>
///</summary>
public string TIN {
get { return Data.GetValueOrDefault<string>(Fältkod.TIN); }
set { Data.AddOrUpdateValue(Fältkod.TIN, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 528</para>
///<para>Elementnamn XML-fil: UnderlagForInvesteraravdrag</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 077,135</para>
///<para>SambandskontrollText: Fk528 ska finnas om Fk529 finns. Fk528 ska vara <= Fk529.</para>
///<para>Beskrivning: Underlag för investeraravdrag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Ange underlag för investeraravdrag för den uppgiften avser. Högsta underlag är 1 300 000 kr.</para>
///</summary>
public long UnderlagForInvesteraravdrag {
get { return Data.GetValueOrDefault<long>(Fältkod.UnderlagForInvesteraravdrag); }
set { Data.AddOrUpdateValue(Fältkod.UnderlagForInvesteraravdrag, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 529</para>
///<para>Elementnamn XML-fil: TotUnderlagInvesteraravdrag</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 136</para>
///<para>SambandskontrollText: Fk529 ska finnas om Fk528 finns.</para>
///<para>Beskrivning: Totalt underlag för investeraravdrag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Ange totalt underlag för investeraravdrag, dvs det fysiska personer betalat för andelar i företaget. Maximala beloppet är 20 000 000 kr.</para>
///</summary>
public long TotUnderlagInvesteraravdrag {
get { return Data.GetValueOrDefault<long>(Fältkod.TotUnderlagInvesteraravdrag); }
set { Data.AddOrUpdateValue(Fältkod.TotUnderlagInvesteraravdrag, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 530</para>
///<para>Elementnamn XML-fil: Betalningsar</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 164</para>
///<para>SambandskontrollText: Fk530 får inte finnas om Fk528 saknas.</para>
///<para>Beskrivning: Inbetalning gjord året före inkomståret</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera här om betalning av andelarna gjordes året före inkomståret, men villkoren för investeraravdrag uppfylldes först under inkomståret.</para>
///</summary>
public bool Betalningsar {
get { return Data.GetValueOrDefault<bool>(Fältkod.Betalningsar); }
set { Data.AddOrUpdateValue(Fältkod.Betalningsar, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 531</para>
///<para>Elementnamn XML-fil: AterforingAvyttring</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 080,078,079</para>
///<para>SambandskontrollText: Fk531 får inte finnas om Fk528 finns. Fk531 får inte finnas om Fk529 finns. Fk531 får inte finnas om Fk530 finns.</para>
///<para>Beskrivning: Återföring på grund av avyttring</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera här om andelarna avyttrats.</para>
///</summary>
public bool AterforingAvyttring {
get { return Data.GetValueOrDefault<bool>(Fältkod.AterforingAvyttring); }
set { Data.AddOrUpdateValue(Fältkod.AterforingAvyttring, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 532</para>
///<para>Elementnamn XML-fil: AterforingUtflyttning</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 147,155,158</para>
///<para>SambandskontrollText: Fk532 får inte finnas om Fk528 finns. Fk532 får inte finnas om Fk529 finns. Fk532 får inte finnas om Fk530 finns.</para>
///<para>Beskrivning: Återföring på grund av utflyttning</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera här om den uppgiften avser  upphört att vara skattskyldig i Sverige för kapitalvinst på andelarna.</para>
///</summary>
public bool AterforingUtflyttning {
get { return Data.GetValueOrDefault<bool>(Fältkod.AterforingUtflyttning); }
set { Data.AddOrUpdateValue(Fältkod.AterforingUtflyttning, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 533</para>
///<para>Elementnamn XML-fil: AterforingHogVardeoverforing</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 148,156,159</para>
///<para>SambandskontrollText: Fk533 får inte finnas om Fk528 finns. Fk533 får inte finnas om Fk529 finns. Fk533 får inte finnas om Fk530 finns.</para>
///<para>Beskrivning: Återföring på grund av för hög värdeöverföring</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera här om den uppgiften avser (eller någon närstående) under något av de fem närmaste åren efter betalningsåret tar emot en värdeöverföring från företaget överstigande jämförelsebeloppet.</para>
///</summary>
public bool AterforingHogVardeoverforing {
get { return Data.GetValueOrDefault<bool>(Fältkod.AterforingHogVardeoverforing); }
set { Data.AddOrUpdateValue(Fältkod.AterforingHogVardeoverforing, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 534</para>
///<para>Elementnamn XML-fil: AterforingInternaForvarv</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 149,157,160</para>
///<para>SambandskontrollText: Fk534 får inte finnas om Fk528 finns. Fk534 får inte finnas om Fk529 finns. Fk534 får inte finnas om Fk530 finns.</para>
///<para>Beskrivning: Återföring på grund av vissa interna förvärv</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera här om företaget under de två åren närmast efter betalningsåret genomför vissa interna förvärv.</para>
///</summary>
public bool AterforingInternaForvarv {
get { return Data.GetValueOrDefault<bool>(Fältkod.AterforingInternaForvarv); }
set { Data.AddOrUpdateValue(Fältkod.AterforingInternaForvarv, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 535</para>
///<para>Elementnamn XML-fil: DatumForvarv</para>
///<para>Obl: N</para>
///<para>Fälttyp: Datum</para>
///<para>SambandskontrollID: 187</para>
///<para>SambandskontrollText: Fk535 ska finnas om Fk528 finns.</para>
///<para>Beskrivning: Datum när andelarna förvärvades</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här anges datumet för när andelarna förvärvades.</para>
///</summary>
public DateTime DatumForvarv {
get { return Data.GetValueOrDefault<DateTime>(Fältkod.DatumForvarv); }
set { Data.AddOrUpdateValue(Fältkod.DatumForvarv, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 536</para>
///<para>Elementnamn XML-fil: Region</para>
///<para>Obl: N</para>
///<para>Fälttyp: Region</para>
///<para>SambandskontrollID: 188</para>
///<para>SambandskontrollText: Fk536 ska finnas om Fk528 finns.</para>
///<para>Beskrivning: Region där företaget finns (NUTS 2-nivå)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här väljs regionen där företaget finns. Var företaget är geografiskt beläget bestäms utifrån den indelning i territoriella enheter som gäller enligt den s.k. NUTS 2-nivån.</para>
///</summary>
public string Region {
get { return Data.GetValueOrDefault<string>(Fältkod.Region); }
set { Data.AddOrUpdateValue(Fältkod.Region, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 537</para>
///<para>Elementnamn XML-fil: Verksamhetsomrade</para>
///<para>Obl: N</para>
///<para>Fälttyp: Verksamhetsomrade</para>
///<para>SambandskontrollID: 189</para>
///<para>SambandskontrollText: Fk537 ska finnas om Fk528 finns.</para>
///<para>Beskrivning: Företagets verksamhetsområde (Nace-gruppnivå)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här anges företagets verksamhetsområde genom att uppge Nace-kod. Nace-koden är en statistisk kod som beskriver företagets verksamhet och motsvaras av de tre första siffrorna i SNI-koden. SNI-koden framgår av det registerutdrag företaget fått vid registrering.</para>
///</summary>
public string Verksamhetsomrade {
get { return Data.GetValueOrDefault<string>(Fältkod.Verksamhetsomrade); }
set { Data.AddOrUpdateValue(Fältkod.Verksamhetsomrade, value); }
}
///<summary>
///<para>KU-typ: KU28</para>
///<para>FK: 570</para>
///<para>Elementnamn XML-fil: Specifikationsnummer</para>
///<para>Obl: J</para>
///<para>Fälttyp: SpecifikationsNummer</para>
///<para>Beskrivning: Specifikationsnummer</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men lämnar du fler kontrolluppgifter av samma KU-typ för samma person måste de ha olika specifikationsnummer. Vill du senare kunna ändra eller ta bort en kontrolluppgift måste du då ange samma specifikationsnummer som nu.</para>
///</summary>
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
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 001</para>
///<para>Elementnamn XML-fil: AvdragenSkatt</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>Beskrivning: Avdragen preliminär skatt</para>
///</summary>
public long AvdragenSkatt {
get { return Data.GetValueOrDefault<long>(Fältkod.AvdragenSkatt); }
set { Data.AddOrUpdateValue(Fältkod.AvdragenSkatt, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 002</para>
///<para>Elementnamn XML-fil: AvdragenUtlandskSkatt</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 005</para>
///<para>SambandskontrollText: Fk002 får ej vara större än Fk574+Fk504.</para>
///<para>Beskrivning: Avdragen utländsk skatt</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här anges eventuell innehållen utländsk källskatt som dragits på utdelningen. Beloppet anges i svenska kronor. Observera att hela den innehållna utländska källskatten ska redovisas oavsett vad som framgår av ett skatteavtal.</para>
///</summary>
public long AvdragenUtlandskSkatt {
get { return Data.GetValueOrDefault<long>(Fältkod.AvdragenUtlandskSkatt); }
set { Data.AddOrUpdateValue(Fältkod.AvdragenUtlandskSkatt, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 003</para>
///<para>Elementnamn XML-fil: AvdragenKupongskatt</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 006,134,150</para>
///<para>SambandskontrollText: Om Fk574 finns får Fk003 inte vara större än Fk574. Fk003 får inte finnas om Fk001 och/eller Fk002 finns. Om Fk581 finns får Fk003 inte vara större än Fk581.</para>
///<para>Beskrivning: Innehållen svensk kupongskatt</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Innehållen kupongskatt anges i hela kronor avrundat nedåt.</para>
///</summary>
public long AvdragenKupongskatt {
get { return Data.GetValueOrDefault<long>(Fältkod.AvdragenKupongskatt); }
set { Data.AddOrUpdateValue(Fältkod.AvdragenKupongskatt, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 061</para>
///<para>Elementnamn XML-fil: Delagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>Beskrivning: Delägare m.fl. i fåmansföretag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här markerar du om ditt företag är ett: • fåmansföretag och om den person som kontrolluppgiften gäller är företagsledare, närstående till sådan person eller delägare i företaget • fåmanshandelsbolag och om den person kontrolluppgiften gäller är företagsledare eller närstående till en sådan person utan att vara delägare i handelsbolaget.</para>
///</summary>
public bool Delagare {
get { return Data.GetValueOrDefault<bool>(Fältkod.Delagare); }
set { Data.AddOrUpdateValue(Fältkod.Delagare, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 076</para>
///<para>Elementnamn XML-fil: LandskodTIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 045</para>
///<para>SambandskontrollText: Om Fk252 finns ska Fk076 finnas.</para>
///<para>Beskrivning: TIN-land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: I de fall utländskt skatteregistreringsnummer (TIN) lämnas ska uppgift även lämnas om vilket land som utfärdat numret.</para>
///</summary>
public string LandskodTIN {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodTIN); }
set { Data.AddOrUpdateValue(Fältkod.LandskodTIN, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 077</para>
///<para>Elementnamn XML-fil: Fodelseort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text35</para>
///<para>Beskrivning: Födelseort</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i födelseort om den uppgiften gäller är bosatt utomlands och uppgift om utländskt skatteregistreringsnummer saknas.</para>
///</summary>
public string Fodelseort {
get { return Data.GetValueOrDefault<string>(Fältkod.Fodelseort); }
set { Data.AddOrUpdateValue(Fältkod.Fodelseort, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 078</para>
///<para>Elementnamn XML-fil: LandskodFodelseort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 046</para>
///<para>SambandskontrollText: Fk078 ska finnas om Fk077 finns.</para>
///<para>Beskrivning: Land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Land där födelseorten ligger.</para>
///</summary>
public string LandskodFodelseort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodFodelseort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodFodelseort, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 079</para>
///<para>Elementnamn XML-fil: LandskodHemvist</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 047</para>
///<para>SambandskontrollText: Fk079 ska finnas om Fk256 finns.</para>
///<para>Beskrivning: Hemviststat</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string LandskodHemvist {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodHemvist); }
set { Data.AddOrUpdateValue(Fältkod.LandskodHemvist, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 201</para>
///<para>Elementnamn XML-fil: UppgiftslamnarId</para>
///<para>Obl: J</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 053</para>
///<para>SambandskontrollText: Fk201 får ej vara identisk med Fk215.</para>
///<para>Beskrivning: Organisationsnummer</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string UppgiftslamnarId {
get { return Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId); }
set { Data.AddOrUpdateValue(Fältkod.UppgiftslamnarId, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 202</para>
///<para>Elementnamn XML-fil: NamnUppgiftslamnare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Uppgiftslämnarens namn</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string NamnUppgiftslamnare {
get { return Data.GetValueOrDefault<string>(Fältkod.NamnUppgiftslamnare); }
set { Data.AddOrUpdateValue(Fältkod.NamnUppgiftslamnare, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 203</para>
///<para>Elementnamn XML-fil: Inkomstar</para>
///<para>Obl: J</para>
///<para>Fälttyp: Inkomstar</para>
///<para>Beskrivning: Inkomstår</para>
///</summary>
public int Inkomstar {
get { return Data.GetValueOrDefault<int>(Fältkod.Inkomstar); }
set { Data.AddOrUpdateValue(Fältkod.Inkomstar, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 205</para>
///<para>Elementnamn XML-fil: Borttag</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 055</para>
///<para>SambandskontrollText: Fk205 får bara finnas om alla fältkoder förutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 är tomma.</para>
///<para>Beskrivning: Borttags-KU</para>
///</summary>
public bool Borttag {
get { return Data.GetValueOrDefault<bool>(Fältkod.Borttag); }
set { Data.AddOrUpdateValue(Fältkod.Borttag, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 210</para>
///<para>Elementnamn XML-fil: Rattelse</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///</summary>
public bool Rattelse {
get { return Data.GetValueOrDefault<bool>(Fältkod.Rattelse); }
set { Data.AddOrUpdateValue(Fältkod.Rattelse, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 215</para>
///<para>Elementnamn XML-fil: Inkomsttagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 056</para>
///<para>SambandskontrollText: Fk215 ska finnas om Fk222 och Fk224 saknas.</para>
///<para>Beskrivning: Person-/organisationsnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer för fysisk person eller organisationsnummer för juridisk person. För personer med samordningsnummer ska namn- och adressuppgifter skrivas i fält 216-221.</para>
///</summary>
public string Inkomsttagare {
get { return Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare); }
set { Data.AddOrUpdateValue(Fältkod.Inkomsttagare, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 216</para>
///<para>Elementnamn XML-fil: Fornamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 057,142</para>
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Förnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Fornamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Fornamn); }
set { Data.AddOrUpdateValue(Fältkod.Fornamn, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 217</para>
///<para>Elementnamn XML-fil: Efternamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 058,143</para>
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Efternamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Efternamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Efternamn); }
set { Data.AddOrUpdateValue(Fältkod.Efternamn, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 218</para>
///<para>Elementnamn XML-fil: Gatuadress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 059,144,152</para>
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Gatuadress</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Gatuadress {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 219</para>
///<para>Elementnamn XML-fil: Postnummer</para>
///<para>Obl: N</para>
///<para>Fälttyp: PostNummer</para>
///<para>SambandskontrollID: 060,145,153</para>
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges istället i fält 221 nedan.</para>
///</summary>
public string Postnummer {
get { return Data.GetValueOrDefault<string>(Fältkod.Postnummer); }
set { Data.AddOrUpdateValue(Fältkod.Postnummer, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 220</para>
///<para>Elementnamn XML-fil: Postort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 061,146,154</para>
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postort</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Postort {
get { return Data.GetValueOrDefault<string>(Fältkod.Postort); }
set { Data.AddOrUpdateValue(Fältkod.Postort, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 221</para>
///<para>Elementnamn XML-fil: LandskodPostort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 166</para>
///<para>SambandskontrollText: Fk221 ska finnas om Fk230 finns</para>
///<para>Beskrivning: Land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string LandskodPostort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodPostort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodPostort, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 222</para>
///<para>Elementnamn XML-fil: Fodelsetid</para>
///<para>Obl: N</para>
///<para>Fälttyp: Fodelsetid</para>
///<para>SambandskontrollID: 063</para>
///<para>SambandskontrollText: Om Fk215 finns får inte Fk222 finnas.</para>
///<para>Beskrivning: Födelsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns möjligheten att ange födelsetid istället. Födelsetiden anges med personens födelsedatum på samma sätt som i ett personnummer följt av tre valfria siffror (ÅÅÅÅMMDDnnn).</para>
///</summary>
public long Fodelsetid {
get { return Data.GetValueOrDefault<long>(Fältkod.Fodelsetid); }
set { Data.AddOrUpdateValue(Fältkod.Fodelsetid, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 224</para>
///<para>Elementnamn XML-fil: AnnatIDNr</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text20</para>
///<para>Beskrivning: Annat ID-nummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav för Annat ID-nummer.</para>
///</summary>
public string AnnatIDNr {
get { return Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr); }
set { Data.AddOrUpdateValue(Fältkod.AnnatIDNr, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 226</para>
///<para>Elementnamn XML-fil: OrgNamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 065,151</para>
///<para>SambandskontrollText: Fk226 får inte finnas om Fk222 finns, om Fk215 har SS>17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges för juridisk person istället för för- och efternamn.</para>
///</summary>
public string OrgNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.OrgNamn); }
set { Data.AddOrUpdateValue(Fältkod.OrgNamn, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 228</para>
///<para>Elementnamn XML-fil: Gatuadress2</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Gatuadress forts.</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du behöver mer utrymme för gatuadress, t.ex. för en c/o-adress.</para>
///</summary>
public string Gatuadress2 {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress2); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress2, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 230</para>
///<para>Elementnamn XML-fil: FriAdress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text350</para>
///<para>Beskrivning: Adress i fritt format</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utländsk adress inte går att dela in i gatuadress, postnummer och postort kan detta fält istället användas.</para>
///</summary>
public string FriAdress {
get { return Data.GetValueOrDefault<string>(Fältkod.FriAdress); }
set { Data.AddOrUpdateValue(Fältkod.FriAdress, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 252</para>
///<para>Elementnamn XML-fil: TIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text20</para>
///<para>SambandskontrollID: 066</para>
///<para>SambandskontrollText: Om Fk076 finns ska Fk252 finnas.</para>
///<para>Beskrivning: Utländskt skatteregistreringsnummer (TIN)</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Utländskt skatteregistreringsnummer, TIN (Tax Identification Number), ska alltid lämnas för person som är obegränsat skattskyldig i Sverige och har hemvist i annan stat. Personen, som uppgiften avser, får skatteregistreringsnumret av det land där han eller hon har sin skatterättsliga hemvist.</para>
///</summary>
public string TIN {
get { return Data.GetValueOrDefault<string>(Fältkod.TIN); }
set { Data.AddOrUpdateValue(Fältkod.TIN, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 256</para>
///<para>Elementnamn XML-fil: Hemviststat</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text30</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Hemviststat {
get { return Data.GetValueOrDefault<string>(Fältkod.Hemviststat); }
set { Data.AddOrUpdateValue(Fältkod.Hemviststat, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 504</para>
///<para>Elementnamn XML-fil: AnnanInkomst</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp7</para>
///<para>Beskrivning: Annan inkomst</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här redovisas bl.a. avkastning på delägarrätt beräknad utifrån en oförutsedd variabel såsom ett aktieindex, återbetalning vid nedsättning av fondförvaltningsavgift och utdelningsersättningar och premier som erhålls vid värdepapperslån.</para>
///</summary>
public long AnnanInkomst {
get { return Data.GetValueOrDefault<long>(Fältkod.AnnanInkomst); }
set { Data.AddOrUpdateValue(Fältkod.AnnanInkomst, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 523</para>
///<para>Elementnamn XML-fil: Depanummer</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp12</para>
///<para>Beskrivning: Depånummer</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Depånummer ska alltid anges för samägda depåer. Anges med maximalt 12 siffror (inga bokstäver).</para>
///</summary>
public long Depanummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Depanummer); }
set { Data.AddOrUpdateValue(Fältkod.Depanummer, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 524</para>
///<para>Elementnamn XML-fil: AndelAvDepan</para>
///<para>Obl: N</para>
///<para>Fälttyp: Decimal2</para>
///<para>SambandskontrollID: 076</para>
///<para>SambandskontrollText: Om Fk524 finns ska också Fk523 finnas.</para>
///<para>Beskrivning: Andel av depån</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en depå innehas av två eller flera personer och beloppen i kontrolluppgiften avser hela depån anges här ägd andel för den uppgiften avser. Andelen anges med upp till två decimaler. OBS! Avdragen skatt anges alltid individuellt.</para>
///</summary>
public decimal AndelAvDepan {
get { return Data.GetValueOrDefault<decimal>(Fältkod.AndelAvDepan); }
set { Data.AddOrUpdateValue(Fältkod.AndelAvDepan, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 570</para>
///<para>Elementnamn XML-fil: Specifikationsnummer</para>
///<para>Obl: J</para>
///<para>Fälttyp: SpecifikationsNummer</para>
///<para>Beskrivning: Specifikationsnummer</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men lämnar du fler kontrolluppgifter av samma KU-typ för samma person måste de ha olika specifikationsnummer. Vill du senare kunna ändra eller ta bort en kontrolluppgift måste du då ange samma specifikationsnummer som nu.</para>
///</summary>
public long Specifikationsnummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Specifikationsnummer); }
set { Data.AddOrUpdateValue(Fältkod.Specifikationsnummer, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 571</para>
///<para>Elementnamn XML-fil: VPNamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 085,170</para>
///<para>SambandskontrollText: Fk571 ska finnas om Fk572 saknas och Fk205 saknas. Fk571 ska finnas om (Fk572 finns och de två första tecknen i Fk572 inte är SE och Fk201 inte är 165561128074</para>
///<para>Beskrivning: Namn på aktien/andelen</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Namnet ska alltid anges om ISIN är utländskt, dvs börjar på annan landskod än SE, eller om ISIN saknas. Bolagsnamn ska alltid anges för svenska fåmansbolag utan ISIN.</para>
///</summary>
public string VPNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.VPNamn); }
set { Data.AddOrUpdateValue(Fältkod.VPNamn, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 572</para>
///<para>Elementnamn XML-fil: ISIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Isin</para>
///<para>Beskrivning: ISIN</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Värdepapperets identitetsnummer enligt internationell standard. Anges i form av landskod (två stora bokstäver) följt av 10 tecken. För svenska värdepapper är det 10 siffror. Ex SE0000667925.</para>
///</summary>
public string ISIN {
get { return Data.GetValueOrDefault<string>(Fältkod.ISIN); }
set { Data.AddOrUpdateValue(Fältkod.ISIN, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 574</para>
///<para>Elementnamn XML-fil: UtbetaldUtdelning</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 088,168</para>
///<para>SambandskontrollText: Fk574 ska finnas om Fk205, Fk001, Fk504, Fk581 och Fk599 saknas. Fk574 får inte finnas om Fk599 finns.</para>
///<para>Beskrivning: Utbetald utdelning m.m.</para>
///</summary>
public long UtbetaldUtdelning {
get { return Data.GetValueOrDefault<long>(Fältkod.UtbetaldUtdelning); }
set { Data.AddOrUpdateValue(Fältkod.UtbetaldUtdelning, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 581</para>
///<para>Elementnamn XML-fil: AnnanKupongErsattning</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 092</para>
///<para>SambandskontrollText: Fk581 får inte finnas om Fk574 finns.</para>
///<para>Beskrivning: Annan kupongskattepliktig ersättning än utdelning</para>
///</summary>
public long AnnanKupongErsattning {
get { return Data.GetValueOrDefault<long>(Fältkod.AnnanKupongErsattning); }
set { Data.AddOrUpdateValue(Fältkod.AnnanKupongErsattning, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 599</para>
///<para>Elementnamn XML-fil: OkandVarde</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>Beskrivning: Okänt värde</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markering för när en sakutdelning ännu inte fått ett fastställt värde vid tiden för inlämning av kontrolluppgiften.</para>
///</summary>
public bool OkandVarde {
get { return Data.GetValueOrDefault<bool>(Fältkod.OkandVarde); }
set { Data.AddOrUpdateValue(Fältkod.OkandVarde, value); }
}
///<summary>
///<para>KU-typ: KU31</para>
///<para>FK: 853</para>
///<para>Elementnamn XML-fil: Avstamningsdag</para>
///<para>Obl: N</para>
///<para>Fälttyp: Datum</para>
///<para>Beskrivning: Avstämningsdag (fylls endast i vid flera utdelningar per år)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Avstämningsdagen är lika med utdelningstillfället.</para>
///</summary>
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
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 061</para>
///<para>Elementnamn XML-fil: Delagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>Beskrivning: Delägare m.fl. i fåmansföretag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här markerar du om ditt företag är ett: • fåmansföretag och om den person som kontrolluppgiften gäller är företagsledare, närstående till sådan person eller delägare i företaget • fåmanshandelsbolag och om den person kontrolluppgiften gäller är företagsledare eller närstående till en sådan person utan att vara delägare i handelsbolaget.</para>
///</summary>
public bool Delagare {
get { return Data.GetValueOrDefault<bool>(Fältkod.Delagare); }
set { Data.AddOrUpdateValue(Fältkod.Delagare, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 076</para>
///<para>Elementnamn XML-fil: LandskodTIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 045</para>
///<para>SambandskontrollText: Om Fk252 finns ska Fk076 finnas.</para>
///<para>Beskrivning: TIN-land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: I de fall utländskt skatteregistreringsnummer (TIN) lämnas ska uppgift även lämnas om vilket land som utfärdat numret.</para>
///</summary>
public string LandskodTIN {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodTIN); }
set { Data.AddOrUpdateValue(Fältkod.LandskodTIN, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 201</para>
///<para>Elementnamn XML-fil: UppgiftslamnarId</para>
///<para>Obl: J</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 053</para>
///<para>SambandskontrollText: Fk201 får ej vara identisk med Fk215.</para>
///<para>Beskrivning: Organisationsnummer</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string UppgiftslamnarId {
get { return Data.GetValueOrDefault<string>(Fältkod.UppgiftslamnarId); }
set { Data.AddOrUpdateValue(Fältkod.UppgiftslamnarId, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 202</para>
///<para>Elementnamn XML-fil: NamnUppgiftslamnare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Uppgiftslämnarens namn</para>
///<para>Xml fält grupp: Uppgiftslamnare</para>
///</summary>
public string NamnUppgiftslamnare {
get { return Data.GetValueOrDefault<string>(Fältkod.NamnUppgiftslamnare); }
set { Data.AddOrUpdateValue(Fältkod.NamnUppgiftslamnare, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 203</para>
///<para>Elementnamn XML-fil: Inkomstar</para>
///<para>Obl: J</para>
///<para>Fälttyp: Inkomstar</para>
///<para>Beskrivning: Inkomstår</para>
///</summary>
public int Inkomstar {
get { return Data.GetValueOrDefault<int>(Fältkod.Inkomstar); }
set { Data.AddOrUpdateValue(Fältkod.Inkomstar, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 205</para>
///<para>Elementnamn XML-fil: Borttag</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>SambandskontrollID: 055</para>
///<para>SambandskontrollText: Fk205 får bara finnas om alla fältkoder förutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 är tomma.</para>
///<para>Beskrivning: Borttags-KU</para>
///</summary>
public bool Borttag {
get { return Data.GetValueOrDefault<bool>(Fältkod.Borttag); }
set { Data.AddOrUpdateValue(Fältkod.Borttag, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 210</para>
///<para>Elementnamn XML-fil: Rattelse</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///</summary>
public bool Rattelse {
get { return Data.GetValueOrDefault<bool>(Fältkod.Rattelse); }
set { Data.AddOrUpdateValue(Fältkod.Rattelse, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 215</para>
///<para>Elementnamn XML-fil: Inkomsttagare</para>
///<para>Obl: N</para>
///<para>Fälttyp: Identitet</para>
///<para>SambandskontrollID: 056</para>
///<para>SambandskontrollText: Fk215 ska finnas om Fk222 och Fk224 saknas.</para>
///<para>Beskrivning: Personnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer för fysisk person eller organisationsnummer för juridisk person. För personer med samordningsnummer ska namn- och adressuppgifter skrivas i fält 216-221.</para>
///</summary>
public string Inkomsttagare {
get { return Data.GetValueOrDefault<string>(Fältkod.Inkomsttagare); }
set { Data.AddOrUpdateValue(Fältkod.Inkomsttagare, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 216</para>
///<para>Elementnamn XML-fil: Fornamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 057,142</para>
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Förnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Fornamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Fornamn); }
set { Data.AddOrUpdateValue(Fältkod.Fornamn, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 217</para>
///<para>Elementnamn XML-fil: Efternamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 058,143</para>
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas.</para>
///<para>Beskrivning: Efternamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Efternamn {
get { return Data.GetValueOrDefault<string>(Fältkod.Efternamn); }
set { Data.AddOrUpdateValue(Fältkod.Efternamn, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 218</para>
///<para>Elementnamn XML-fil: Gatuadress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 059,144,152</para>
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Gatuadress</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Gatuadress {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 219</para>
///<para>Elementnamn XML-fil: Postnummer</para>
///<para>Obl: N</para>
///<para>Fälttyp: PostNummer</para>
///<para>SambandskontrollID: 060,145,153</para>
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges istället i fält 221 nedan.</para>
///</summary>
public string Postnummer {
get { return Data.GetValueOrDefault<string>(Fältkod.Postnummer); }
set { Data.AddOrUpdateValue(Fältkod.Postnummer, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 220</para>
///<para>Elementnamn XML-fil: Postort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 061,146,154</para>
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har värde i SSÅÅ > 1800 och DD > 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postort</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string Postort {
get { return Data.GetValueOrDefault<string>(Fältkod.Postort); }
set { Data.AddOrUpdateValue(Fältkod.Postort, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 221</para>
///<para>Elementnamn XML-fil: LandskodPostort</para>
///<para>Obl: N</para>
///<para>Fälttyp: Landskod</para>
///<para>SambandskontrollID: 166</para>
///<para>SambandskontrollText: Fk221 ska finnas om Fk230 finns</para>
///<para>Beskrivning: Land</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///</summary>
public string LandskodPostort {
get { return Data.GetValueOrDefault<string>(Fältkod.LandskodPostort); }
set { Data.AddOrUpdateValue(Fältkod.LandskodPostort, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 222</para>
///<para>Elementnamn XML-fil: Fodelsetid</para>
///<para>Obl: N</para>
///<para>Fälttyp: Fodelsetid</para>
///<para>SambandskontrollID: 063</para>
///<para>SambandskontrollText: Om Fk215 finns får inte Fk222 finnas.</para>
///<para>Beskrivning: Födelsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns möjligheten att ange födelsetid istället. Födelsetiden anges med personens födelsedatum på samma sätt som i ett personnummer följt av tre valfria siffror (ÅÅÅÅMMDDnnn).</para>
///</summary>
public long Fodelsetid {
get { return Data.GetValueOrDefault<long>(Fältkod.Fodelsetid); }
set { Data.AddOrUpdateValue(Fältkod.Fodelsetid, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 224</para>
///<para>Elementnamn XML-fil: AnnatIDNr</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text20</para>
///<para>Beskrivning: Annat ID-nummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav för Annat ID-nummer.</para>
///</summary>
public string AnnatIDNr {
get { return Data.GetValueOrDefault<string>(Fältkod.AnnatIDNr); }
set { Data.AddOrUpdateValue(Fältkod.AnnatIDNr, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 226</para>
///<para>Elementnamn XML-fil: OrgNamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 065,151</para>
///<para>SambandskontrollText: Fk226 får inte finnas om Fk222 finns, om Fk215 har SS>17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges för juridisk person istället för för- och efternamn.</para>
///</summary>
public string OrgNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.OrgNamn); }
set { Data.AddOrUpdateValue(Fältkod.OrgNamn, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 228</para>
///<para>Elementnamn XML-fil: Gatuadress2</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>Beskrivning: Gatuadress forts.</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du behöver mer utrymme för gatuadress, t.ex. för en c/o-adress.</para>
///</summary>
public string Gatuadress2 {
get { return Data.GetValueOrDefault<string>(Fältkod.Gatuadress2); }
set { Data.AddOrUpdateValue(Fältkod.Gatuadress2, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 230</para>
///<para>Elementnamn XML-fil: FriAdress</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text350</para>
///<para>Beskrivning: Adress i fritt format</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utländsk adress inte går att dela in i gatuadress, postnummer och postort kan detta fält istället användas.</para>
///</summary>
public string FriAdress {
get { return Data.GetValueOrDefault<string>(Fältkod.FriAdress); }
set { Data.AddOrUpdateValue(Fältkod.FriAdress, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 252</para>
///<para>Elementnamn XML-fil: TIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text20</para>
///<para>SambandskontrollID: 066</para>
///<para>SambandskontrollText: Om Fk076 finns ska Fk252 finnas.</para>
///<para>Beskrivning: Utländskt skatteregistreringsnummer (TIN)</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Utländskt skatteregistreringsnummer, TIN (Tax Identification Number), ska alltid lämnas för person som är obegränsat skattskyldig i Sverige och har hemvist i annan stat. Personen, som uppgiften avser, får skatteregistreringsnumret av det land där han eller hon har sin skatterättsliga hemvist.</para>
///</summary>
public string TIN {
get { return Data.GetValueOrDefault<string>(Fältkod.TIN); }
set { Data.AddOrUpdateValue(Fältkod.TIN, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 523</para>
///<para>Elementnamn XML-fil: Depanummer</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp12</para>
///<para>Beskrivning: Depånummer</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Depånummer ska alltid anges för samägda depåer. Anges med maximalt 12 siffror (inga bokstäver).</para>
///</summary>
public long Depanummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Depanummer); }
set { Data.AddOrUpdateValue(Fältkod.Depanummer, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 524</para>
///<para>Elementnamn XML-fil: AndelAvDepan</para>
///<para>Obl: N</para>
///<para>Fälttyp: Decimal2</para>
///<para>SambandskontrollID: 076</para>
///<para>SambandskontrollText: Om Fk524 finns ska också Fk523 finnas.</para>
///<para>Beskrivning: Andel av depån</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en depå innehas av två eller flera personer och beloppen i kontrolluppgiften avser hela depån anges här ägd andel för den uppgiften avser. Andelen anges med upp till två decimaler. OBS! Avdragen skatt anges alltid individuellt.</para>
///</summary>
public decimal AndelAvDepan {
get { return Data.GetValueOrDefault<decimal>(Fältkod.AndelAvDepan); }
set { Data.AddOrUpdateValue(Fältkod.AndelAvDepan, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 570</para>
///<para>Elementnamn XML-fil: Specifikationsnummer</para>
///<para>Obl: J</para>
///<para>Fälttyp: SpecifikationsNummer</para>
///<para>Beskrivning: Specifikationsnummer</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men lämnar du fler kontrolluppgifter av samma KU-typ för samma person måste de ha olika specifikationsnummer. Vill du senare kunna ändra eller ta bort en kontrolluppgift måste du då ange samma specifikationsnummer som nu.</para>
///</summary>
public long Specifikationsnummer {
get { return Data.GetValueOrDefault<long>(Fältkod.Specifikationsnummer); }
set { Data.AddOrUpdateValue(Fältkod.Specifikationsnummer, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 571</para>
///<para>Elementnamn XML-fil: VPNamn</para>
///<para>Obl: N</para>
///<para>Fälttyp: Text50</para>
///<para>SambandskontrollID: 085,170</para>
///<para>SambandskontrollText: Fk571 ska finnas om Fk572 saknas och Fk205 saknas. Fk571 ska finnas om (Fk572 finns och de två första tecknen i Fk572 inte är SE och Fk201 inte är 165561128074</para>
///<para>Beskrivning: Namn på aktien/andelen</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Namnet ska alltid anges om ISIN är utländskt (börjar på annan landskod än SE) eller om ISIN saknas.</para>
///</summary>
public string VPNamn {
get { return Data.GetValueOrDefault<string>(Fältkod.VPNamn); }
set { Data.AddOrUpdateValue(Fältkod.VPNamn, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 572</para>
///<para>Elementnamn XML-fil: ISIN</para>
///<para>Obl: N</para>
///<para>Fälttyp: Isin</para>
///<para>Beskrivning: ISIN</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Värdepapperets identitetsnummer enligt internationell standard. Anges i form av landskod (två stora bokstäver) följt av 10 tecken. För svenska värdepapper är det 10 siffror. Ex SE0000667925.</para>
///</summary>
public string ISIN {
get { return Data.GetValueOrDefault<string>(Fältkod.ISIN); }
set { Data.AddOrUpdateValue(Fältkod.ISIN, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 573</para>
///<para>Elementnamn XML-fil: AvyttradTillISK</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>Beskrivning: Avyttrad till investeringssparkonto</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera här om kontrolluppgiften avser en överföring av en aktie/delägarrätt till ett investeringssparkonto.</para>
///</summary>
public bool AvyttradTillISK {
get { return Data.GetValueOrDefault<bool>(Fältkod.AvyttradTillISK); }
set { Data.AddOrUpdateValue(Fältkod.AvyttradTillISK, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 576</para>
///<para>Elementnamn XML-fil: AntalAvyttrade</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp12</para>
///<para>SambandskontrollID: 089</para>
///<para>SambandskontrollText: Om Fk205 saknas ska Fk576 finnas.</para>
///<para>Beskrivning: Antal avyttrade</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Här anges antalet avyttrade delägarrätter eller belopp av fordringsrätter.</para>
///</summary>
public long AntalAvyttrade {
get { return Data.GetValueOrDefault<long>(Fältkod.AntalAvyttrade); }
set { Data.AddOrUpdateValue(Fältkod.AntalAvyttrade, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 599</para>
///<para>Elementnamn XML-fil: OkandVarde</para>
///<para>Obl: N</para>
///<para>Fälttyp: Kryss</para>
///<para>Beskrivning: Okänt värde</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markering för när en sakutdelning som avyttrats ännu inte fått ett fastställt värde vid tiden för inlämning av kontrolluppgiften.</para>
///</summary>
public bool OkandVarde {
get { return Data.GetValueOrDefault<bool>(Fältkod.OkandVarde); }
set { Data.AddOrUpdateValue(Fältkod.OkandVarde, value); }
}
///<summary>
///<para>KU-typ: KU32</para>
///<para>FK: 810</para>
///<para>Elementnamn XML-fil: ErhallenErsattning</para>
///<para>Obl: N</para>
///<para>Fälttyp: Belopp10</para>
///<para>SambandskontrollID: 090,169</para>
///<para>SambandskontrollText: Om Fk205  och Fk599 saknas ska Fk810 finnas. Fk810 får inte finnas om Fk599 finns.</para>
///<para>Beskrivning: Erhållen ersättning</para>
///</summary>
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
AvdragsgillRanta = 540,
[Fälttyp(Fälttyp.Belopp,10)]
TotaltInbetaldRanta = 541,
[Fälttyp(Fälttyp.Belopp,10)]
BetaldRantekompensation = 543,
[Fälttyp(Fälttyp.Kryss,-1)]
GemensamtLan = 544,
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
[Fälttyp(Fälttyp.Datum,-1)]
DatumForvarv = 535,
[Fälttyp(Fälttyp.Region,-1)]
Region = 536,
[Fälttyp(Fälttyp.Verksamhetsomrade,-1)]
Verksamhetsomrade = 537,
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
Datum,
Region,
Verksamhetsomrade,
Decimal,
Isin,
}
}


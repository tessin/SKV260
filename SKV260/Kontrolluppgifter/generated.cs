using System;

namespace SKV260.Kontrolluppgifter
{
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
///<para>Beskrivning: Avdragen prelimin&#228;r skatt</para>
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
///<para>Beskrivning: Del&#228;gare m.fl. i f&#229;mansf&#246;retag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r markerar du om ditt f&#246;retag &#228;r ett: • f&#229;mansf&#246;retag och om den person som kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare, n&#228;rst&#229;ende till s&#229;dan person eller del&#228;gare i f&#246;retaget • f&#229;manshandelsbolag och om den person kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare eller n&#228;rst&#229;ende till en s&#229;dan person utan att vara del&#228;gare i handelsbolaget.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: I de fall utl&#228;ndskt skatteregistreringsnummer (TIN) l&#228;mnas ska uppgift &#228;ven l&#228;mnas om vilket land som utf&#228;rdat numret.</para>
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
///<para>Beskrivning: F&#246;delseort</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i f&#246;delseort om den uppgiften g&#228;ller &#228;r bosatt utomlands och uppgift om utl&#228;ndskt skatteregistreringsnummer saknas.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Land d&#228;r f&#246;delseorten ligger.</para>
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
///<para>SambandskontrollText: Fk201 f&#229;r ej vara identisk med Fk215.</para>
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
///<para>Beskrivning: Uppgiftsl&#228;mnarens namn</para>
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
///<para>Beskrivning: Inkomst&#229;r</para>
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
///<para>SambandskontrollText: Fk205 f&#229;r bara finnas om alla f&#228;ltkoder f&#246;rutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 &#228;r tomma.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer f&#246;r fysisk person eller organisationsnummer f&#246;r juridisk person. F&#246;r personer med samordningsnummer ska namn- och adressuppgifter skrivas i f&#228;lt 216-221.</para>
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
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
///<para>Beskrivning: F&#246;rnamn</para>
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
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
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
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges ist&#228;llet i f&#228;lt 221 nedan.</para>
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
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Om Fk215 finns f&#229;r inte Fk222 finnas.</para>
///<para>Beskrivning: F&#246;delsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns m&#246;jligheten att ange f&#246;delsetid ist&#228;llet. F&#246;delsetiden anges med personens f&#246;delsedatum p&#229; samma s&#228;tt som i ett personnummer f&#246;ljt av tre valfria siffror (&#197;&#197;&#197;&#197;MMDDnnn).</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav f&#246;r Annat ID-nummer.</para>
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
///<para>SambandskontrollText: Fk226 f&#229;r inte finnas om Fk222 finns, om Fk215 har SS&gt;17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges f&#246;r juridisk person ist&#228;llet f&#246;r f&#246;r- och efternamn.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du beh&#246;ver mer utrymme f&#246;r gatuadress, t.ex. f&#246;r en c/o-adress.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utl&#228;ndsk adress inte g&#229;r att dela in i gatuadress, postnummer och postort kan detta f&#228;lt ist&#228;llet anv&#228;ndas.</para>
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
///<para>Beskrivning: Utl&#228;ndskt skatteregistreringsnummer (TIN)</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Utl&#228;ndskt skatteregistreringsnummer, TIN (Tax Identification Number), ska alltid l&#228;mnas f&#246;r person som &#228;r obegr&#228;nsat skattskyldig i Sverige och har hemvist i annan stat. Personen, som uppgiften avser, f&#229;r skatteregistreringsnumret av det land d&#228;r han eller hon har sin skatter&#228;ttsliga hemvist.</para>
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
///<para>SambandskontrollText: Fk500 m&#229;ste finnas om Fk205, Fk001, Fk503 och Fk504 saknas.</para>
///<para>Beskrivning: R&#228;nteinkomst</para>
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
///<para>SambandskontrollText: Fk502 f&#229;r inte finnas om Fk503 eller Fk504 finns.</para>
///<para>Beskrivning: F&#246;rfogarkonto (fler &#228;n fem)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera h&#228;r om kontot innehas gemensamt av fler &#228;n fem personer (f&#246;rfogarkonto). D&#229; f&#229;r hela r&#228;ntan f&#246;r kontot redovisas p&#229; en enda kontrolluppgift. Kontrolluppgiften l&#228;mnas med personnummer p&#229; den som svarar f&#246;r kontot.</para>
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
///<para>Beskrivning: R&#228;nteinkomst, ej konto</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r redovisas summan av tillgodor&#228;knad eller utbetald r&#228;nta fr&#229;n annat &#228;n inl&#229;ningskonton i bank.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r redovisas annan inkomst &#228;n r&#228;nteinkomst.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men l&#228;mnar du fler kontrolluppgifter av samma KU-typ f&#246;r samma person m&#229;ste de ha olika specifikationsnummer. Vill du senare kunna &#228;ndra eller ta bort en kontrolluppgift m&#229;ste du d&#229; ange samma specifikationsnummer som nu.</para>
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
///<para>Beskrivning: Del&#228;gare m.fl. i f&#229;mansf&#246;retag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r markerar du om ditt f&#246;retag &#228;r ett: • f&#229;mansf&#246;retag och om den person som kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare, n&#228;rst&#229;ende till s&#229;dan person eller del&#228;gare i f&#246;retaget • f&#229;manshandelsbolag och om den person kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare eller n&#228;rst&#229;ende till en s&#229;dan person utan att vara del&#228;gare i handelsbolaget.</para>
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
///<para>SambandskontrollText: Fk201 f&#229;r ej vara identisk med Fk215.</para>
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
///<para>Beskrivning: Uppgiftsl&#228;mnarens namn</para>
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
///<para>Beskrivning: Inkomst&#229;r</para>
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
///<para>SambandskontrollText: Fk205 f&#229;r bara finnas om alla f&#228;ltkoder f&#246;rutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 &#228;r tomma.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer f&#246;r fysisk person eller organisationsnummer f&#246;r juridisk person. F&#246;r personer med samordningsnummer ska namn- och adressuppgifter skrivas i f&#228;lt 216-221.</para>
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
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
///<para>Beskrivning: F&#246;rnamn</para>
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
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
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
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges ist&#228;llet i f&#228;lt 221 nedan.</para>
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
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Om Fk215 finns f&#229;r inte Fk222 finnas.</para>
///<para>Beskrivning: F&#246;delsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns m&#246;jligheten att ange f&#246;delsetid ist&#228;llet. F&#246;delsetiden anges med personens f&#246;delsedatum p&#229; samma s&#228;tt som i ett personnummer f&#246;ljt av tre valfria siffror (&#197;&#197;&#197;&#197;MMDDnnn).</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav f&#246;r Annat ID-nummer.</para>
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
///<para>SambandskontrollText: Fk226 f&#229;r inte finnas om Fk222 finns, om Fk215 har SS&gt;17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges f&#246;r juridisk person ist&#228;llet f&#246;r f&#246;r- och efternamn.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du beh&#246;ver mer utrymme f&#246;r gatuadress, t.ex. f&#246;r en c/o-adress.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utl&#228;ndsk adress inte g&#229;r att dela in i gatuadress, postnummer och postort kan detta f&#228;lt ist&#228;llet anv&#228;ndas.</para>
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
///<para>Beskrivning: Betald och f&#246;r &#229;ret avdragsgill r&#228;nta</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r redovisas under inkomst&#229;ret betald r&#228;nta som avser tiden fram till 31 januari &#229;ret efter inkomst&#229;ret.</para>
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
///<para>SambandskontrollText: Om Fk541 finns och &#228;r st&#246;rre &#228;n noll och Fk540 finns s&#229; ska Fk541 vara &gt;= Fk540</para>
///<para>Beskrivning: Totalt inbetald r&#228;nta (anges endast om f&#246;rskotts-r&#228;nta erlagts som inte &#228;r avdragsgill f&#246;r &#229;ret)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r redovisas all r&#228;nta som betalats under inkomst&#229;ret.</para>
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
///<para>Beskrivning: Betald r&#228;ntekompensation</para>
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
///<para>Beskrivning: Gemensamt l&#229;n f&#246;r fler &#228;n fem personer d&#228;r l&#229;ngivaren inte kan ange vilka samtliga personer &#228;r</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera h&#228;r om kontrolluppgiften avser utgiftsr&#228;nta p&#229; gemensamt l&#229;n som fler &#228;n fem personer har. Kontrolluppgiften l&#228;mnas med personnummer p&#229; den som svarar f&#246;r l&#229;net.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men l&#228;mnar du fler kontrolluppgifter av samma KU-typ f&#246;r samma person m&#229;ste de ha olika specifikationsnummer. Vill du senare kunna &#228;ndra eller ta bort en kontrolluppgift m&#229;ste du d&#229; ange samma specifikationsnummer som nu.</para>
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
///<para>Beskrivning: Del&#228;gare m.fl. i f&#229;mansf&#246;retag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r markerar du om ditt f&#246;retag &#228;r ett: • f&#229;mansf&#246;retag och om den person som kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare, n&#228;rst&#229;ende till s&#229;dan person eller del&#228;gare i f&#246;retaget • f&#229;manshandelsbolag och om den person kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare eller n&#228;rst&#229;ende till en s&#229;dan person utan att vara del&#228;gare i handelsbolaget.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: I de fall utl&#228;ndskt skatteregistreringsnummer (TIN) l&#228;mnas ska uppgift &#228;ven l&#228;mnas om vilket land som utf&#228;rdat numret.</para>
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
///<para>SambandskontrollText: Fk201 f&#229;r ej vara identisk med Fk215.</para>
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
///<para>Beskrivning: Uppgiftsl&#228;mnarens namn</para>
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
///<para>Beskrivning: Inkomst&#229;r</para>
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
///<para>SambandskontrollText: Fk205 f&#229;r bara finnas om alla f&#228;ltkoder f&#246;rutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 &#228;r tomma.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer f&#246;r fysisk person eller organisationsnummer f&#246;r juridisk person. F&#246;r personer med samordningsnummer ska namn- och adressuppgifter skrivas i f&#228;lt 216-221.</para>
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
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
///<para>Beskrivning: F&#246;rnamn</para>
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
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
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
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges ist&#228;llet i f&#228;lt 221 nedan.</para>
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
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Om Fk215 finns f&#229;r inte Fk222 finnas.</para>
///<para>Beskrivning: F&#246;delsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns m&#246;jligheten att ange f&#246;delsetid ist&#228;llet. F&#246;delsetiden anges med personens f&#246;delsedatum p&#229; samma s&#228;tt som i ett personnummer f&#246;ljt av tre valfria siffror (&#197;&#197;&#197;&#197;MMDDnnn).</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav f&#246;r Annat ID-nummer.</para>
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
///<para>SambandskontrollText: Fk226 f&#229;r inte finnas om Fk222 finns, om Fk215 har SS&gt;17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges f&#246;r juridisk person ist&#228;llet f&#246;r f&#246;r- och efternamn.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du beh&#246;ver mer utrymme f&#246;r gatuadress, t.ex. f&#246;r en c/o-adress.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utl&#228;ndsk adress inte g&#229;r att dela in i gatuadress, postnummer och postort kan detta f&#228;lt ist&#228;llet anv&#228;ndas.</para>
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
///<para>Beskrivning: Utl&#228;ndskt skatteregistreringsnummer (TIN)</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Utl&#228;ndskt skatteregistreringsnummer, TIN (Tax Identification Number), ska alltid l&#228;mnas f&#246;r person som &#228;r obegr&#228;nsat skattskyldig i Sverige och har hemvist i annan stat. Personen, som uppgiften avser, f&#229;r skatteregistreringsnumret av det land d&#228;r han eller hon har sin skatter&#228;ttsliga hemvist.</para>
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
///<para>SambandskontrollText: Fk528 ska finnas om Fk529 finns. Fk528 ska vara &lt;= Fk529.</para>
///<para>Beskrivning: Underlag f&#246;r investeraravdrag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Ange underlag f&#246;r investeraravdrag f&#246;r den uppgiften avser. H&#246;gsta underlag &#228;r 1 300 000 kr.</para>
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
///<para>Beskrivning: Totalt underlag f&#246;r investeraravdrag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Ange totalt underlag f&#246;r investeraravdrag, dvs det fysiska personer betalat f&#246;r andelar i f&#246;retaget. Maximala beloppet &#228;r 20 000 000 kr.</para>
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
///<para>SambandskontrollText: Fk530 f&#229;r inte finnas om Fk528 saknas.</para>
///<para>Beskrivning: Inbetalning gjord &#229;ret f&#246;re inkomst&#229;ret</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera h&#228;r om betalning av andelarna gjordes &#229;ret f&#246;re inkomst&#229;ret, men villkoren f&#246;r investeraravdrag uppfylldes f&#246;rst under inkomst&#229;ret.</para>
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
///<para>SambandskontrollText: Fk531 f&#229;r inte finnas om Fk528 finns. Fk531 f&#229;r inte finnas om Fk529 finns. Fk531 f&#229;r inte finnas om Fk530 finns.</para>
///<para>Beskrivning: &#197;terf&#246;ring p&#229; grund av avyttring</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera h&#228;r om andelarna avyttrats.</para>
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
///<para>SambandskontrollText: Fk532 f&#229;r inte finnas om Fk528 finns. Fk532 f&#229;r inte finnas om Fk529 finns. Fk532 f&#229;r inte finnas om Fk530 finns.</para>
///<para>Beskrivning: &#197;terf&#246;ring p&#229; grund av utflyttning</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera h&#228;r om den uppgiften avser  upph&#246;rt att vara skattskyldig i Sverige f&#246;r kapitalvinst p&#229; andelarna.</para>
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
///<para>SambandskontrollText: Fk533 f&#229;r inte finnas om Fk528 finns. Fk533 f&#229;r inte finnas om Fk529 finns. Fk533 f&#229;r inte finnas om Fk530 finns.</para>
///<para>Beskrivning: &#197;terf&#246;ring p&#229; grund av f&#246;r h&#246;g v&#228;rde&#246;verf&#246;ring</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera h&#228;r om den uppgiften avser (eller n&#229;gon n&#228;rst&#229;ende) under n&#229;got av de fem n&#228;rmaste &#229;ren efter betalnings&#229;ret tar emot en v&#228;rde&#246;verf&#246;ring fr&#229;n f&#246;retaget &#246;verstigande j&#228;mf&#246;relsebeloppet.</para>
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
///<para>SambandskontrollText: Fk534 f&#229;r inte finnas om Fk528 finns. Fk534 f&#229;r inte finnas om Fk529 finns. Fk534 f&#229;r inte finnas om Fk530 finns.</para>
///<para>Beskrivning: &#197;terf&#246;ring p&#229; grund av vissa interna f&#246;rv&#228;rv</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera h&#228;r om f&#246;retaget under de tv&#229; &#229;ren n&#228;rmast efter betalnings&#229;ret genomf&#246;r vissa interna f&#246;rv&#228;rv.</para>
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
///<para>Beskrivning: Datum n&#228;r andelarna f&#246;rv&#228;rvades</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r anges datumet f&#246;r n&#228;r andelarna f&#246;rv&#228;rvades.</para>
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
///<para>Beskrivning: Region d&#228;r f&#246;retaget finns (NUTS 2-niv&#229;)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r v&#228;ljs regionen d&#228;r f&#246;retaget finns. Var f&#246;retaget &#228;r geografiskt bel&#228;get best&#228;ms utifr&#229;n den indelning i territoriella enheter som g&#228;ller enligt den s.k. NUTS 2-niv&#229;n.</para>
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
///<para>Beskrivning: F&#246;retagets verksamhetsomr&#229;de (Nace-gruppniv&#229;)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r anges f&#246;retagets verksamhetsomr&#229;de genom att uppge Nace-kod. Nace-koden &#228;r en statistisk kod som beskriver f&#246;retagets verksamhet och motsvaras av de tre f&#246;rsta siffrorna i SNI-koden. SNI-koden framg&#229;r av det registerutdrag f&#246;retaget f&#229;tt vid registrering.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men l&#228;mnar du fler kontrolluppgifter av samma KU-typ f&#246;r samma person m&#229;ste de ha olika specifikationsnummer. Vill du senare kunna &#228;ndra eller ta bort en kontrolluppgift m&#229;ste du d&#229; ange samma specifikationsnummer som nu.</para>
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
///<para>Beskrivning: Avdragen prelimin&#228;r skatt</para>
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
///<para>SambandskontrollText: Fk002 f&#229;r ej vara st&#246;rre &#228;n Fk574+Fk504.</para>
///<para>Beskrivning: Avdragen utl&#228;ndsk skatt</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r anges eventuell inneh&#229;llen utl&#228;ndsk k&#228;llskatt som dragits p&#229; utdelningen. Beloppet anges i svenska kronor. Observera att hela den inneh&#229;llna utl&#228;ndska k&#228;llskatten ska redovisas oavsett vad som framg&#229;r av ett skatteavtal.</para>
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
///<para>SambandskontrollText: Om Fk574 finns f&#229;r Fk003 inte vara st&#246;rre &#228;n Fk574. Fk003 f&#229;r inte finnas om Fk001 och/eller Fk002 finns. Om Fk581 finns f&#229;r Fk003 inte vara st&#246;rre &#228;n Fk581.</para>
///<para>Beskrivning: Inneh&#229;llen svensk kupongskatt</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Inneh&#229;llen kupongskatt anges i hela kronor avrundat ned&#229;t.</para>
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
///<para>Beskrivning: Del&#228;gare m.fl. i f&#229;mansf&#246;retag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r markerar du om ditt f&#246;retag &#228;r ett: • f&#229;mansf&#246;retag och om den person som kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare, n&#228;rst&#229;ende till s&#229;dan person eller del&#228;gare i f&#246;retaget • f&#229;manshandelsbolag och om den person kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare eller n&#228;rst&#229;ende till en s&#229;dan person utan att vara del&#228;gare i handelsbolaget.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: I de fall utl&#228;ndskt skatteregistreringsnummer (TIN) l&#228;mnas ska uppgift &#228;ven l&#228;mnas om vilket land som utf&#228;rdat numret.</para>
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
///<para>Beskrivning: F&#246;delseort</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i f&#246;delseort om den uppgiften g&#228;ller &#228;r bosatt utomlands och uppgift om utl&#228;ndskt skatteregistreringsnummer saknas.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Land d&#228;r f&#246;delseorten ligger.</para>
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
///<para>SambandskontrollText: Fk201 f&#229;r ej vara identisk med Fk215.</para>
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
///<para>Beskrivning: Uppgiftsl&#228;mnarens namn</para>
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
///<para>Beskrivning: Inkomst&#229;r</para>
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
///<para>SambandskontrollText: Fk205 f&#229;r bara finnas om alla f&#228;ltkoder f&#246;rutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 &#228;r tomma.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer f&#246;r fysisk person eller organisationsnummer f&#246;r juridisk person. F&#246;r personer med samordningsnummer ska namn- och adressuppgifter skrivas i f&#228;lt 216-221.</para>
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
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
///<para>Beskrivning: F&#246;rnamn</para>
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
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
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
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges ist&#228;llet i f&#228;lt 221 nedan.</para>
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
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Om Fk215 finns f&#229;r inte Fk222 finnas.</para>
///<para>Beskrivning: F&#246;delsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns m&#246;jligheten att ange f&#246;delsetid ist&#228;llet. F&#246;delsetiden anges med personens f&#246;delsedatum p&#229; samma s&#228;tt som i ett personnummer f&#246;ljt av tre valfria siffror (&#197;&#197;&#197;&#197;MMDDnnn).</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav f&#246;r Annat ID-nummer.</para>
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
///<para>SambandskontrollText: Fk226 f&#229;r inte finnas om Fk222 finns, om Fk215 har SS&gt;17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges f&#246;r juridisk person ist&#228;llet f&#246;r f&#246;r- och efternamn.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du beh&#246;ver mer utrymme f&#246;r gatuadress, t.ex. f&#246;r en c/o-adress.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utl&#228;ndsk adress inte g&#229;r att dela in i gatuadress, postnummer och postort kan detta f&#228;lt ist&#228;llet anv&#228;ndas.</para>
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
///<para>Beskrivning: Utl&#228;ndskt skatteregistreringsnummer (TIN)</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Utl&#228;ndskt skatteregistreringsnummer, TIN (Tax Identification Number), ska alltid l&#228;mnas f&#246;r person som &#228;r obegr&#228;nsat skattskyldig i Sverige och har hemvist i annan stat. Personen, som uppgiften avser, f&#229;r skatteregistreringsnumret av det land d&#228;r han eller hon har sin skatter&#228;ttsliga hemvist.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r redovisas bl.a. avkastning p&#229; del&#228;garr&#228;tt ber&#228;knad utifr&#229;n en of&#246;rutsedd variabel s&#229;som ett aktieindex, &#229;terbetalning vid neds&#228;ttning av fondf&#246;rvaltningsavgift och utdelningsers&#228;ttningar och premier som erh&#229;lls vid v&#228;rdepappersl&#229;n.</para>
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
///<para>Beskrivning: Dep&#229;nummer</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Dep&#229;nummer ska alltid anges f&#246;r sam&#228;gda dep&#229;er. Anges med maximalt 12 siffror (inga bokst&#228;ver).</para>
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
///<para>SambandskontrollText: Om Fk524 finns ska ocks&#229; Fk523 finnas.</para>
///<para>Beskrivning: Andel av dep&#229;n</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en dep&#229; innehas av tv&#229; eller flera personer och beloppen i kontrolluppgiften avser hela dep&#229;n anges h&#228;r &#228;gd andel f&#246;r den uppgiften avser. Andelen anges med upp till tv&#229; decimaler. OBS! Avdragen skatt anges alltid individuellt.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men l&#228;mnar du fler kontrolluppgifter av samma KU-typ f&#246;r samma person m&#229;ste de ha olika specifikationsnummer. Vill du senare kunna &#228;ndra eller ta bort en kontrolluppgift m&#229;ste du d&#229; ange samma specifikationsnummer som nu.</para>
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
///<para>SambandskontrollText: Fk571 ska finnas om Fk572 saknas och Fk205 saknas. Fk571 ska finnas om (Fk572 finns och de tv&#229; f&#246;rsta tecknen i Fk572 inte &#228;r SE och Fk201 inte &#228;r 165561128074</para>
///<para>Beskrivning: Namn p&#229; aktien/andelen</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Namnet ska alltid anges om ISIN &#228;r utl&#228;ndskt, dvs b&#246;rjar p&#229; annan landskod &#228;n SE, eller om ISIN saknas. Bolagsnamn ska alltid anges f&#246;r svenska f&#229;mansbolag utan ISIN.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: V&#228;rdepapperets identitetsnummer enligt internationell standard. Anges i form av landskod (tv&#229; stora bokst&#228;ver) f&#246;ljt av 10 tecken. F&#246;r svenska v&#228;rdepapper &#228;r det 10 siffror. Ex SE0000667925.</para>
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
///<para>SambandskontrollText: Fk574 ska finnas om Fk205, Fk001, Fk504, Fk581 och Fk599 saknas. Fk574 f&#229;r inte finnas om Fk599 finns.</para>
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
///<para>SambandskontrollText: Fk581 f&#229;r inte finnas om Fk574 finns.</para>
///<para>Beskrivning: Annan kupongskattepliktig ers&#228;ttning &#228;n utdelning</para>
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
///<para>Beskrivning: Ok&#228;nt v&#228;rde</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markering f&#246;r n&#228;r en sakutdelning &#228;nnu inte f&#229;tt ett fastst&#228;llt v&#228;rde vid tiden f&#246;r inl&#228;mning av kontrolluppgiften.</para>
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
///<para>Beskrivning: Avst&#228;mningsdag (fylls endast i vid flera utdelningar per &#229;r)</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Avst&#228;mningsdagen &#228;r lika med utdelningstillf&#228;llet.</para>
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
///<para>Beskrivning: Del&#228;gare m.fl. i f&#229;mansf&#246;retag</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r markerar du om ditt f&#246;retag &#228;r ett: • f&#229;mansf&#246;retag och om den person som kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare, n&#228;rst&#229;ende till s&#229;dan person eller del&#228;gare i f&#246;retaget • f&#229;manshandelsbolag och om den person kontrolluppgiften g&#228;ller &#228;r f&#246;retagsledare eller n&#228;rst&#229;ende till en s&#229;dan person utan att vara del&#228;gare i handelsbolaget.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: I de fall utl&#228;ndskt skatteregistreringsnummer (TIN) l&#228;mnas ska uppgift &#228;ven l&#228;mnas om vilket land som utf&#228;rdat numret.</para>
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
///<para>SambandskontrollText: Fk201 f&#229;r ej vara identisk med Fk215.</para>
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
///<para>Beskrivning: Uppgiftsl&#228;mnarens namn</para>
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
///<para>Beskrivning: Inkomst&#229;r</para>
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
///<para>SambandskontrollText: Fk205 f&#229;r bara finnas om alla f&#228;ltkoder f&#246;rutom Fk201, Fk203, Fk570, Fk215, Fk222 och Fk224 &#228;r tomma.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Fyll i personnummer eller samordningsnummer f&#246;r fysisk person eller organisationsnummer f&#246;r juridisk person. F&#246;r personer med samordningsnummer ska namn- och adressuppgifter skrivas i f&#228;lt 216-221.</para>
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
///<para>SambandskontrollText: Fk216 ska finnas om Fk222 finns och Fk205 saknas. Fk216 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
///<para>Beskrivning: F&#246;rnamn</para>
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
///<para>SambandskontrollText: Fk217 ska finnas om Fk222 finns och Fk205 saknas. Fk217 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas.</para>
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
///<para>SambandskontrollText: Fk218 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk218 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Fk219 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk219 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
///<para>Beskrivning: Postnummer</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges utan ev. landskod. Land anges ist&#228;llet i f&#228;lt 221 nedan.</para>
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
///<para>SambandskontrollText: Fk220 ska finnas om Fk222 finns och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk215 har v&#228;rde i SS&#197;&#197; &gt; 1800 och DD &gt; 60 och Fk205 saknas och Fk230 saknas. Fk220 ska finnas om Fk224 finns och Fk205 och Fk215 och Fk222 saknas och Fk230 saknas.</para>
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
///<para>SambandskontrollText: Om Fk215 finns f&#229;r inte Fk222 finnas.</para>
///<para>Beskrivning: F&#246;delsetid</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Har personen som uppgiften avser inget personnummer finns m&#246;jligheten att ange f&#246;delsetid ist&#228;llet. F&#246;delsetiden anges med personens f&#246;delsedatum p&#229; samma s&#228;tt som i ett personnummer f&#246;ljt av tre valfria siffror (&#197;&#197;&#197;&#197;MMDDnnn).</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Avser uppgiften en juridisk person som saknar svenskt organisationsnummer ska, som identifikator, Annat ID-nummer anges. Det finns inga formkrav f&#246;r Annat ID-nummer.</para>
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
///<para>SambandskontrollText: Fk226 f&#229;r inte finnas om Fk222 finns, om Fk215 har SS&gt;17, om Fk216 finns eller om Fk217 finns. Fk226 ska finnas om Fk224 finns och Fk205, Fk215, Fk216, Fk217 och Fk222 alla saknas.</para>
///<para>Beskrivning: Organisationsnamn</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Anges f&#246;r juridisk person ist&#228;llet f&#246;r f&#246;r- och efternamn.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om du beh&#246;ver mer utrymme f&#246;r gatuadress, t.ex. f&#246;r en c/o-adress.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en utl&#228;ndsk adress inte g&#229;r att dela in i gatuadress, postnummer och postort kan detta f&#228;lt ist&#228;llet anv&#228;ndas.</para>
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
///<para>Beskrivning: Utl&#228;ndskt skatteregistreringsnummer (TIN)</para>
///<para>Xml fält grupp: Inkomsttagare</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Utl&#228;ndskt skatteregistreringsnummer, TIN (Tax Identification Number), ska alltid l&#228;mnas f&#246;r person som &#228;r obegr&#228;nsat skattskyldig i Sverige och har hemvist i annan stat. Personen, som uppgiften avser, f&#229;r skatteregistreringsnumret av det land d&#228;r han eller hon har sin skatter&#228;ttsliga hemvist.</para>
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
///<para>Beskrivning: Dep&#229;nummer</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Dep&#229;nummer ska alltid anges f&#246;r sam&#228;gda dep&#229;er. Anges med maximalt 12 siffror (inga bokst&#228;ver).</para>
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
///<para>SambandskontrollText: Om Fk524 finns ska ocks&#229; Fk523 finnas.</para>
///<para>Beskrivning: Andel av dep&#229;n</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Om en dep&#229; innehas av tv&#229; eller flera personer och beloppen i kontrolluppgiften avser hela dep&#229;n anges h&#228;r &#228;gd andel f&#246;r den uppgiften avser. Andelen anges med upp till tv&#229; decimaler. OBS! Avdragen skatt anges alltid individuellt.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Ska alltid anges. Kan vara valfritt nummer, men l&#228;mnar du fler kontrolluppgifter av samma KU-typ f&#246;r samma person m&#229;ste de ha olika specifikationsnummer. Vill du senare kunna &#228;ndra eller ta bort en kontrolluppgift m&#229;ste du d&#229; ange samma specifikationsnummer som nu.</para>
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
///<para>SambandskontrollText: Fk571 ska finnas om Fk572 saknas och Fk205 saknas. Fk571 ska finnas om (Fk572 finns och de tv&#229; f&#246;rsta tecknen i Fk572 inte &#228;r SE och Fk201 inte &#228;r 165561128074</para>
///<para>Beskrivning: Namn p&#229; aktien/andelen</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Namnet ska alltid anges om ISIN &#228;r utl&#228;ndskt (b&#246;rjar p&#229; annan landskod &#228;n SE) eller om ISIN saknas.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: V&#228;rdepapperets identitetsnummer enligt internationell standard. Anges i form av landskod (tv&#229; stora bokst&#228;ver) f&#246;ljt av 10 tecken. F&#246;r svenska v&#228;rdepapper &#228;r det 10 siffror. Ex SE0000667925.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: Markera h&#228;r om kontrolluppgiften avser en &#246;verf&#246;ring av en aktie/del&#228;garr&#228;tt till ett investeringssparkonto.</para>
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
///<para>SKVs tooltip i etjänst för direkt-registrering: H&#228;r anges antalet avyttrade del&#228;garr&#228;tter eller belopp av fordringsr&#228;tter.</para>
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
///<para>Beskrivning: Ok&#228;nt v&#228;rde</para>
///<para>SKVs tooltip i etjänst för direkt-registrering: Markering f&#246;r n&#228;r en sakutdelning som avyttrats &#228;nnu inte f&#229;tt ett fastst&#228;llt v&#228;rde vid tiden f&#246;r inl&#228;mning av kontrolluppgiften.</para>
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
///<para>SambandskontrollText: Om Fk205  och Fk599 saknas ska Fk810 finnas. Fk810 f&#229;r inte finnas om Fk599 finns.</para>
///<para>Beskrivning: Erh&#229;llen ers&#228;ttning</para>
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


Om inget annat framgår, utgå från Skatteverkets dokumentation "Teknisk beskrivning och XML-schemalager för inkomstår 2018".

https://www.skatteverket.se/foretagochorganisationer/sjalvservice/allaetjanster/tjanster/lamnakontrolluppgifter/tekniskbeskrivningochxmlschemalagerforinkomstar2018.4.4a4d586616058d860bc86a2.html

----

Det här är ett .NET lib som hjälper dig med elektronisk redovisning av kontrolluppgifter till skatteverket. **Tessin Nordic AB** har tagit fram en lösning för KU20, KU31 och KU32. Stöd för ytterligare kontrolluppgifter finns inte i dags läget men det går att bygga vidare efter samma principer som övriga kontrolluppgifter använder.

----

# Exempel

Titta närmare på `Program.cs` is mappen SKV260 eller xml2xlsx för mer information.

# Bra att veta

- Skatteverket använder [12-siffriga organisationsnummer](https://sv.wikipedia.org/wiki/Organisationsnummer#12-siffriga_organisationsnummer). 
- Skatteverket tillåter inga skiljetecken i person-/samordnings- eller, organisationsnummer.
- Alla text fält har längdbegränsningar

----

När KU lämnas till Skatteverket måste motsvarande information lämnas till den som KU avser.

Den kan lämnas på valfritt sätt, t.ex.

- på sista lönebeskedet för året
- på årsbesked
- på eget formulär anpassat för egna utskriftsrutiner och behov
- via e-post

Det är viktigt att det är enkelt för den som KU avser, att jämföra uppgifterna mot inkomstdeklarationen.

Har KU13 eller KU14 lämnats ska uppgiften till den anställde innehålla en upplysning med följande innebörd:

KU13: ”Denna uppgift avser inkomst som enligt beslut om särskild inkomstskatt för utomlands bosatta inte ska deklareras i Sverige.”

KU14: ”Denna uppgift avser särskild kontrolluppgift - Pensionsgrundande inkomst och utbyte av kontrolluppgifter, för inkomster som inte ska deklareras i Sverige”.

# Hur hanterar vi uppdateringar av Skatteverkets tjänst

Skatteverket gör emellertid uppdateringar av sin tjänst men nya fältkoder och versioner. Detta kräver att man manuellt uppdaterar vissa filer och genererar ny kod som följd av detta. En specifik version av detta hjälp biblotek är inte tänkt att användas för något annat än 1 specifkt inkomst år.

Vi uppdaterar genom att exportera från Skatteverkets Excel listor till CSV som vi sedan kan konsumera i en T4 mall som skapar den kod vi behöver. Ev. sambandskontroller som görs, måste läggas till manuellt.

Hur en uppdatering går till kan man se här https://github.com/tessin/SKV260/commit/c301d972d5c5edaa39965c11a488e8127b9ee8a8
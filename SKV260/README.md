Om inget annat framgår, utgå från "Teknisk beskrivning och XML-schemalager för inkomstår 2017".

https://www.skatteverket.se/foretagochorganisationer/sjalvservice/allaetjanster/tjanster/lamnakontrolluppgifter/tekniskbeskrivningochxmlschemalagerforinkomstar2017.4.515a6be615c637b9aa46fe8.html

----

Skatteverket, https://www.skatteverket.se/download/18.3f4496fd14864cc5ac978e3/1413979543502/30436.pdf

FK570 Specifikationsnummer

Specifikationsnummer ska **alltid** anges. Du ska alltså fylla i specifikationsnummer även om du bara lämnar en kontrolluppgift av viss typ för en och samma person.

Specifikationsnumret ska vara unikt för kontrolluppgiftstypen, personen och uppgiftslämnaren. I övrigt finns inga krav på hur numreringen görs. Du kan till exempel låta alla kontrolluppgifter från en enhet ha specifikationsnummer 1 och alla kontrolluppgifter
från en annan enhet specifikationsnummer 2 och så vidare. Observera att det inte får förekomma fler kontrolluppgifter med samma specifikationsnummer för en och samma person. 

**Viktigt att komma ihåg!** När du rättar en kontrolluppgift ska den nya rättade kontrolluppgiften ha samma specifikationsnummer som den tidigare insända (se sidan 7 under ”Så rättar du en felaktig kontrolluppgift”). Specifikationsnumret behövs för att man
ska kunna identifiera den kontrolluppgift som ursprungligen har lämnats. 



Med "kontrolluppgiftstyp" avser man det olika blanketterna, KU21, KU25, KU28, etc.

Med "person" avser man person-/samordnings- eller, organisationsnummer (FK215, alt FK222 eller FK224, 6.2 Identifikatorer).

Med "uppgiftslämnaren" avser man Tessin Nordic AB.

----

Skatteverket, https://www.skatteverket.se/download/18.57cadbbd15a3688ff4411b8/1487155856670/SKV260_3.0.pdf

6.2 Identifikatorer

En kontrolluppgift identifieras som unik genom en kombination av fem fält. Dessa fem fält kallas identifikatorerna. Så snart en av identifikatorerna skiljer sig åt jämfört med en annan kontrolluppgift är kontrollupgifterna unika mot varandra. Identifikatorerna är: 

- **KU-typ:** Den blankett som ska användas för de aktuella kontrolluppgifterna, t.ex. KU25
- **FK201:** Uppgiftslämnarens person-/organisationsnummer
- **FK203:** Inkomstår
- **FK215\*, FK222 eller FK224:** Den som KU avser. Person-/samordnings- eller, organisationsnummer, FK215. Om sådant nummer saknas anges födelsetid för fysisk person, FK222, eller annat ID-nr, FK224, för juridisk person
- **FK570:** Specifikationsnummer

\* = FK215 avser svenskt person-/samordnings- eller, organisationsnummer, endast i övriga fall blir FK222 eller FK224 relevant.

SpecifikationsNummer	HELTAL	1 - 9999999999

----

Om vi tilldelar alla projekt fasta specifikationsnummer, från 1- och uppåt så kan vi använda det rakt av, enda undantaget vore om vi behövde lämna in mer än 1 uppsättning av kontrolluppgifter för en och samma identitet per projekt. dvs om vi skulle behöva lämna in KU25 i två eller fler exemplar

Alternativt kan vi beräkna detta värdet baserat på när projektet är skapat och dess ID, detta skulle dock sluta fungera om man tog bort en post, vilket gör det hela mer ömtåligt.

Ett tredje alternativ är att bokföra alla i ett fristående system. Vilket kanske är den bästa lösning eftersom det midför minst besvär för det existerande platformen.

Vid borttag av en kontrolluppgift så behöver man kunna markera detta på något vis vid sidan av ett specifikationsnummer, vilket innebär att en företeckning över vilka kontrolluppgifter som skapas är att föredra

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

----
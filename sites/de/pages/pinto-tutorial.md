---
title: "Pinto -- Ein maßgeschneidertes CPAN in der Box"
timestamp: 2013-05-03T16:30:05
tags:
  - cpan
  - pinto
published: true
original: pinto-tutorial
author: thalhammer
translator: mca
---


<i>
Das ist ein Gast-Artikel von [Jeffrey Ryan Thalhammer](http://twitter.com/thaljef), Autor von Pinto
und von Perl::Critic. Jeff betreibt eine kleine Beratungsagentur in San Francisco
und ist in der Perl-Gemeinde schon viele Jahre aktiv.
Bis 07. Mai hat Jeff eine  [Spendenaktion](https://www.crowdtilt.com/campaigns/specify-module-version-ranges-in-pint)
laufen, um die Entwicklung eines Features zu finanzieren, dass es erlaubt, <b>in Pinto
für Module Versionsintervalle anzugeben</b>.
</i>

Eines der besten Dinge an Perl sind all die Open-Source-Module, die
es in CPAN gibt. Aber es ist schwierig, mit all diesen Modulen Schritt
zu halten. Jede Woche gibt es hunderte neuer Versionen und Veröffentlichungen,
von denen man nie weiß, welche einen neuen Fehler in Deine 
Applikation einbringt.


This article was originally published on [Pragmatic Perl](http://pragmaticperl.com/)

Eine Startegie, um dieses Problem zu lösen, ist das Erstellen
eines maßgeschneiderten CPAN-[Repositorys](http://de.wikipedia.org/wiki/Repository),
das nur die Modulversionen enthält, die Du benötigst.
Dann kannst Du alle CPAN-Werkzeuge benutzen, um Deine Applikation
mit den Modulen aus dem eigenen maßgeschneiderten Repository zusammenzubauen,
ohne sich dem öffentlichen CPAN-Moloch auszusetzen.

Über Jahre hinweg habe ich einige maßgeschneiderte CPAN-Repositorys
mit [CPAN::Mini](https://metacpan.org/pod/CPAN::Mini)
und [CPAN::Site](https://metacpan.org/pod/CPAN::Site)
aufgebaut. Aber immer wirkten sie ein wenig hölzern und ich war nie
mit ihnen zufrieden. Vor einigen Jahren wurde ich von einem Kunden
beauftragt, ein weiteres maßgeschneidertes CPAN aufzubauen. Aber
dieses Mal hatte ich die Chance, ganz von vorne anzufangen.
Pinto ist das Ergebnis dieser Arbeit.

[Pinto](https://metacpan.org/pod/Pinto) ist ein robustes
Hilfsmittel, um ein maßgeschneidertes CPAN-Repository zu
erstellen und zu verwalten. Es hat einige mächtige Features, die es
Dir ermöglichen, alle diejenigen Module sicher zu verwalten, von
denen Deine Applikation abhängig ist. Dieses Tutorial wird Dir zeigen,
wie man mit Pinto ein eigenes CPAN-Repository aufbaut, und Dir
einige dieser Features demonstrieren.

## Pinto installieren

Pinto ist auf CPAN verfügbar und kann - wie jedes andere Modul -
mit cpan oder `cpanm` installiert werden. Aber Pinto ist
mehr eine Applikation als eine Bibliothek. Es ist ein Werkzeug, mit
dem Du Deine Applikation verwaltest, aber Pinto ist eigentlich nicht
Teil davon. Daher rate ich dazu, Pinto als eigenständiges Programm
mit den folgenden zwei Kommandos zu installieren:

```
curl -L http://getpinto.stratopan.com | bash
source ~/opt/local/pinto/etc/bashrc
```

Damit wird Pinto nach `~/opt/local/pinto` installiert und die
notwendigen Verzeichnisse den Umgebungsvariablen  `PATH` und `MANPATH`
hinzugefügt. Alles ist in sich geschlossen, so dass Pinto weder
Änderungen an Deiner Entwicklungsumgebung vornimmt, noch Änderungen 
der Entwicklungsumgebung Pinto beeinflussen.

## Pinto erkunden

As with any new tool, the first thing you should know is how to get help:

Wie mit jedem neuen Programm, solltest Du zu allererst wissen, wie
Du Hilfe abrufen kannst.

```
pinto commands            # Zeige eine Liste der verfügbaren Befehle
pinto help <COMMAND>      # Zeige eine Zusammenfassung der Optionen und Argumente für <COMMAND>
pinto manual <COMMAND>    # Zeige eine komplette Anleitung für <COMMAND>
```

Pinto beinhaltet auch andere Dokumentation, einschließlich einem
Tutorial und einer Schnellanleitung. Du kannst auf diese Dokumente
mit folgenden Kommandos zugreifen:

```
man Pinto::Manual::Introduction  # Erklärt grundlegende Pinto-Konzepte
man Pinto::Manual::Installing    # Vorschläge, wie Pinto installiert werden sollte
man Pinto::Manual::Tutorial      # Eine ausführliche Anleitung
man Pinto::Manual::QuickStart    # Eine Zusammenfassung der gebräuchlichsten Befehle
```

## Ein Repository anlegen

Der erste Schritt mit Pinto ist das Erstellen eines Repositorys mit
dem Befehl `init`:

```
pinto -r ~/repo init
```

Das erzeugt ein neues Repository im Verzeichnis `~/repo`. Wenn es
noch nicht existiert, wird es für Dich erzeugt. Wenn es bereits existiert, muss es
leer sein.

Die Angabe -r (oder --root) legt fest, wo das Repository liegt. Das ist
für jeden Pinto-Befehl notwendig. Wenn Du es überdrüssig wirst, dies
jedesmal einzugeben, kannst Du die Umgebungsvariable `PINTO_REPOSITORY_ROOT`
entsprechend setzen und die Angabe -r weglassen.

## Ein Blick ins Repository

So, nachdem Du nun ein Repository hast, lass uns einen Blick hinein
werfen. Um den Inhalt eines Repositorys anzuzeigen, benutze
den Befehl "list":

```
pinto -r ~/repo list
```

Im Moment ist die Auflistung natürlich leer, weil nichts im Repository
ist. Aber Du wirst den Befehl "list" im Laufe des Tutorials oft
benutzen.

## CPAN-Module hinzufügen

Wir gehen davon aus, dass Du an einer Applikation arbeitest, die My-App heißt
und das Modul My::App beinhaltet. Daneben ist sie vom Modul URI abhängig.
Du kannst das URI-Modul in das Repository mit dem Befehl `pull`
einbringen:

```
pinto -r ~/repo pull URI
```

Du wirst aufgefordert eine Log-Meldung einzugeben, die beschreibt, warum
eine Änderung vorgenommen wurde. Der Anfang der Log-Vorlage beinhaltet
eine einfache, generierte Meldung, die von Dir editiert werden kann.
Im unteren Teil steht detailliert, welche Module hinzugefügt wurden.
Speichere die Datei und schließe den Editor.

Nun solltest Du das URI-Modul in Deinem Pinto-Repository haben. Also lass
uns nachsehen, was wir wirklich haben. Benutze ein weiteres
Mal den Befehl `list`, um den Inhalt des Repositorys anzuzeigen:

```
pinto -r ~/repo list
```

Dieses Mal sollte die Ausgabe folgendermaßen aussehen:

```
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```

Du kannst erkennen, dass das URI-Modul inklusive aller Voraussetzungen
und wiederum derer Veraussetzungen dem Repository hinzugefügt wurde.

## Private Module hinzufügen

Nun stell Dir vor, Du hast die Arbeit an My-App fertiggestellt und
möchtest die erste Version freigeben. Mit Deinem bevorzugten
Paketierungswerkzeug (z.B. ExtUtils::MakeMaker, Module::Build, Module::Install)
erstellst Du My-App-1.0.tar.gz, was Du mit dem Befehl `add`
dem Pinto-Repository hinzufügst:

```
$> pinto -r ~/repo add path/to/My-App-1.0.tar.gz
```

Ein weiteres Mal wirst Du aufgefordert, einen Eintrag zu verfassen,
der die Änderung beschreibt. Wenn Du Dir jetzt den Repository-Inhalt
auflisten lässt, ist das Modul My::App enthalten und Du wirst
als Autor des Pakets genannt:

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```


## Module installieren

So, nachdem Du nun Deine Module im Pinto-Repository hast, ist der 
nächste Schritt, diese tatsächlich irgendwohin zu installieren.
Unter der Haube ist Pinto genauso wie ein CPAN-Repository aufgebaut.
Damit ist es voll kompatibel mit cpanm und jedem anderen Installationswerkzeug
für Perl-Module. Das einzige, was Du tun musst, ist dem Installationsprogramm
als Quelle das Pinto-Repository mitzuteilen: 

```
cpanm --mirror file://$HOME/repo --mirror-only My::App
```

Dieser Befehl baut und installiert My::App nur mit den Modulen
aus dem Pinto-Repository. Damit bekommst Du zu jeder Zeit exakt die gleiche
Version jeden Moduls, selbst wenn das Modul im
öffentlichen CPAN gelöscht oder erneuert wurde.

Mit cpanm ist die Angabe von --mirror-only zwingend notwendig, um
zu vermeiden, dass cpanm im öffentlichen CPAN nachsieht, falls es
ein Modul nicht in Deinem Pinto-Repository finden kann. Wenn das
passiert, bedeutet das meistens, dass irgendein Modul seine
Abhängigkeiten nicht korrekt in der META-Datei deklariert hat.
Um das Problem zu lösen, musst du den Befehl `pull` für 
all diejenigen Module anwenden, die noch fehlen.

## Modul-Upgrade

Stell Dir vor, es sind einige Wochen seit der ersten Veröffentlichung
von My-App vergangen. Nun gibt es Version 1.62 des Moduls URI, welche
einige Fehlerbehebungen für kritische Fehler enthält. Ein weiteres Mal
kannst Du das Modul mit dem Befehl `pull` ins Repository
einbringen. Da aber bereits eine Version vorhanden ist, musst Du
anzeigen, dass Du eine neuere Version haben möchtest. Dies geschieht
mit der Angabe eine minimalen Versionnummer:

```
pinto -r ~/repo pull URI~1.62
```

Wenn Du nochmal die Repository-Auflistung ansiehst, wirst Du
erkennen, dass jetzt eine neuere Version von URI (und eventuell
auch anderer Module) vorhanden ist:

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.62  GAAS/URI-1.62.tar.gz
rf  URI::Escape                    3.38  GAAS/URI-1.62.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.62.tar.gz
...
```

If the new version of URI requires any upgraded or additional
dependencies, those will be in the repository too.  And when you
install My::App, now you'll get version 1.62 of URI.

Wenn die neue Version von URI neuere oder zusätzliche Abhängigkeiten
hat, dann werden diese auch ins Repository geladen. Und wenn Du nun
My::App installierst, wird auch das Modul URI in der Version 1.62
gezogen werden.

## Arbeiten mit "Stacks"

Bisher haben wir ein Repository als eine einzelne Ressource angesehen.
D.h. als wir im letzten Abschnitt das Modul URI auf einen neueren Stand
gebracht haben, beeinflusste das jede Person und jede Applikation, die
das Repository vielleicht genutzt hat. Aber so eine weite Auswirkung ist
nicht gewünscht. Vielmehr bevorzugt man, eine Änderung isoliert durchzuführen und
diese zu testen, bevor jeder dazu gezwungen ist, eine neuere Version
zu nutzen. Genau das ist es, wofür "Stacks" entworfen wurden.


Alle CPAN-ähnlichen Repositorys haben einen Index, in dem verzeichnet ist,
n welchem Archiv die aktuellste Version eines Moduls enthalten ist.
Normalerweise gibt es nur einen Index pro Repository. In einem Pinto-Repository
können hingegen mehrere Indizes vorhanden sein. Jeder dieser Indizes
wird als <b>"stack"</b> bezeichnet. Das erlaubt Dir verschiedene
Abhängigkeitsbäume innerhalb eines Repositorys aufzubauen. So kannst
Du z.B. einen Entwicklungsstack neben einem Produktivstack haben
oder einen "perl-5.8"-Stack neben einem  "perl-5.16"-Stack.
Immer wenn Du ein Modul auf den neuesten Stand bringst, betrifft
diese immer genau einen Stack.


Aber bevor wir das vertiefen, muss Du über den Standard-Stack Bescheid
wissen. Bei den meisten Befehlen ist die Angabe des Stacks optional.
D.h. sobald Du keinen Stack explizit angibst, bezieht sich ein Befehl
auf den als Standard markierten Stack.

In jedem Repository gibt es nie mehr als einen Standard-Stack. Als
wir obiges Repository eingerichtet haben, wurde ebenfalls ein Stack mit
dem Namen "master" eingerichtet und als Standard gesetzt. Man kann
den Standard-Stack ändern oder den Namen eines Stacks ändern. Darauf
gehen wir aber hier nicht ein. Du solltest Dir nur bewusst machen, dass
"master" der Name des Standard-Stacks ist, der beim Einrichten des
Repositorys angelegt wurde.

<h3>Einen Stack anlegen</h3>

Geh nun - wie vorhin - davon aus, dass Dein Repository Version 1.60 des URI-Moduls enthält,
aber Version 1.62 im CPAN veröffentlicht wurde. Du möchtest das Modul
auf den neuesten Stand bringen, aber diesmal unter Zuhilfenahme eines
separaten Stacks.

Bis jetzt ging alles, was Du zum Repository hinzugefügt oder "gepullt"
hattest, in den "master"-Stack. Daher werden wir nun einen Klon
dieses Stacks mit Hilfe des `copy`-Befehls anlegen:

```
pinto -r ~/repo copy master uri_upgrade
```

Dieser Befehl legt einen neuen Stack mit dem Namen "uri_upgrade" an. Wenn Du
den Inhalt dieses Stacks sehen willst, benutze das `list`-Kommando
mit der Option "--stack": 

```
pinto -r ~/repo list --stack uri_upgrade
```

Die Auflistung sollte identisch zu der vom "master"-Stack sein:

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
...
```

<h3>Einen Stack auf den neuesten Stand bringen</h3>

Nachdem Du nun einen separaten Stack hast, kannst Du das Modul URI erneuern.
Wie zuvor, musst Du den `pull`-Befehl benutzen. Aber dieses Mal teilst
Du Pinto mit, dass es die Module in den Stack "uri_upgrade" einspielen soll:

```
pinto -r ~/repo pull --stack uri_upgrade URI~1.62
```

Wir können den "master"- und "uri_upgrade"-Stack mit dem Befehl "diff"
vergleichen:

```
pinto -r ~/repo diff master uri_upgrade

+rf URI                                              1.62 GAAS/URI-1.62.tar.gz
+rf URI::Escape                                      3.31 GAAS/URI-1.62.tar.gz
+rf URI::Heuristic                                   4.20 GAAS/URI-1.62.tar.gz
...
-rf URI                                              1.60 GAAS/URI-1.60.tar.gz
-rf URI::Escape                                      3.31 GAAS/URI-1.60.tar.gz
-rf URI::Heuristic                                   4.20 GAAS/URI-1.60.tar.gz
```

Die Ausgabe ist ähnlich der des diff(1)-Kommandos. Einträge, die mit einem
"+" beginnen, wurden hinzugefügt, die, die mit einem "-" beginnen,
wurden entfernt. Du kannst erkennen, dass die Module der URI-1.60-Distribution
durch die Module der URI-1.62-Distribution ersetzt wurden.

<h3>Installation aus einem Stack heraus</h3>

Sobald Du neue Module in Deinem "uri_upgrade"-Stack hast, kannst Du 
versuchen, Deine Applikation zu bauen, indem Du cpanm auf diesen
Stack verweist. Jeder Stack ist nichts anderes als ein Unterverzeichnis
im Repository. Daher musst Du nur den Stack-Namen an die Quell-URL
anhängen:

```
cpanm --mirror file://$HOME/repo/stacks/uri_upgrade --mirror-only My::App
```

Wenn all Deine Tests bestanden wurden, kannst Du getrost das Modul URI
auf Version 1.62 im "master"-Stack mit dem jetzt schon bekannten Befehl `pull` anheben.
Nachdem "master" der Standard-Stack ist, brauchst Du den Parameter "--stack"
nicht angeben:

```
pinto -r ~/repo pull URI~1.62
```

## Das Arbeiten mit "Pins"

Stacks sind eine großartige Möglichkeit zu testen, wie sich die
Änderung der Applikationsabhängigkeiten auswirkt. Aber was ist,
wenn die Tests nicht bestanden wurden? Wenn das Problem in
My-App liegt und Du in der Lage bist, das Problem schnell zu korrigieren,
dann wirst Du einfach Deinen Code ändern, die Version 2.0 von My-App
veröffentlichen und mit dem Erneuern des Pakets URI im Stack
"master" weitermachen.

Aber wenn es sich um einen Fehler in URI handelt oder es sehr viel
Zeit benötigen würde, um My-App zu korrigieren, dann hast Du ein
Problem. Du wirst dann nicht wollen, dass irgendjemand anders
URI erneuert oder dass es durch eine andere Abhängigkeit von
My-App aus Versehen erneuert wird. Bis Du weißt, dass das 
Problem behoben ist, musst Du sicherstellen, dass URI nicht
erneuert wird. Das ist genau das, wofür "Pins" sind.

<h3>Ein Modul festpinnen</h3>

Wenn Du ein Modul festpinnst, wird sichergestellt, dass diese Version des
Moduls im Stack verbleibt. Jeder Versuch, das Modul auf einen neueren
Stand zu bringen (entweder direkt oder durch eine andere Abhängigkeit),
wird fehlschlagen. Um ein Modul fest zu pinnen, benutzt Du den `pin`-Befehl:

```
pinto -r ~/repo pin URI
```

Wenn Du Dir erneut die Auflistung des "master"-Stacks ansiehst,
wirst Du in etwa folgendes sehen:

```
...
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf! URI                            1.60  GAAS/URI-1.60.tar.gz
rf! URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
...
```

Das "!"-Zeichen am Anfang des Eintrags weist darauf hin, dass das Modul
"gepinnt" wurde. Wenn irgendeiner versucht, URI auf einen neueren Stand
zu bringen oder eine Distribution hinzuzufügen, die eine neuere
Version benötigt, wird Pinto eine Warnung ausgeben und die neue
Distribution ablehnen. Beachte, dass jedes Modul der URI-1.60-Distribution
"gepinnt" wurde, so dass es unmöglich wird, eine Distribution nur
zum Teil zu erneuern. (Dies könnte passieren, wenn ein Modul in
eine andere Distribution wandert.)

<h3>Loslösen eines Moduls</h3>

Vermutlich wirst Du nach einiger Zeit das Problem in My-App gelöst haben
oder eine neue Version von URI behebt den Fehler. Wenn dies geschieht, kannst
Du URI innerhalb des Stacks mit dem Befehl `unpin` wieder loslösen:

```
pinto -r ~/repo unpin URI
```

Ab da kannst Du URI jederzeit erneuern, sobald Du dazu bereit bist.
Wie beim Anpinnen, werden auch alle anderen Module einer Distribution losgelöst,
wenn Du das betreffende Modul wieder löst.

## Pins und Stacks zusammen benutzen

Pins und Stacks werden oft zusammen benutzt, um Änderungen während
des Entwicklunszyklus in den Griff zu bekommen. Z.B. könntest Du einen
Stack anlegen, der "prod" heißt und alle bekannt guten Abhängigkeiten
enthält. Gleichzeitig könntest Du einen Stack "dev" haben, der alle
experimentellen Abhängigkeiten für die nächste Version Deiner Applikation
beinhaltet. Anfangs ist der "dev"-Stack eine Kopie des "prod"-Stacks.

Während die Entwicklung fortschreitet, kann es vorkommen, dass Du verschiedene Module
zum "dev"-Stack hinzufügst oder Module erneuerst. Wenn ein neueres Modul
Deine Applikation zu Bruch gehen lässt, kannst Du im "prod"-Stack einen
Pin auf das betreffende Modul setzen, um anzuzeigen, dass dieses Modul
nicht auf eine andere Version gehoben werden darf.

<h3>Pins und [Patches](http://de.wikipedia.org/wiki/Patch_%28Software%29)</h3>

Es kann vorkommen, dass eine neue Version einer CPAN-Distribution
einen Fehler hat, den der Autor nicht beheben kann oder will, zumindest
nicht bis die Veröffentlichung Deiner neuen Applikationsversion ansteht.
In dieser Situation kann es sein, dass Du Dich für einen lokalen
Patch der CPAN-Distribution entscheidest.

Stell Dir vor, Du hast den Code für URI dubliziert und eine lokale Version
der Distribution mit dem Namen "URI-1.60_PATCHED.tar.gz" angelegt.
Du kannst diese mit dem Befehl `add` Deinem Repository hinzufügen:

```
pinto -r ~/repo add path/to/URI-1.60_PATCHED.tar.gz
```

In dieser Situation ist es weise, das Modul ebenfalls zu pinnen, da
Du nicht möchtest, dass es erneuert wird, solange nicht eine neue Version bei
CPAN Deinen Patch beinhaltet oder der Autor den Fehler in einer
anderen Weise behoben hat.

```
pinto -r ~/repo pin URI
```

Wenn der Autor von URI die Version 1.62 herausgibt, wirst Du diese zuerst
testen wolen, bevor Du Deine lokal gepatchte Version loslöst. Wie vorhin auch,
kannst Du dies erreichen, indem Du Deinen Stack mit dem Befehl `copy`
klonst. Lass uns den neuen Stack "trail" nennen:

```
pinto -r ~/repo copy master trial
```

Aber bevor Du eine neuere Version von URI einspielen kannst, musst Du
das Modul in "trial" loslösen:

```
pinto -r ~/repo unpin --stack trial URI
```

Nun kannst Du mit dem Upgrade von URI im "trial"-Stack weitermachen und
versuchen, Deine My::App wie folgt zu bauen:

```
pinto -r ~/repo pull --stack trial URI~1.62
cpanm --mirror file://$HOME/repo/stacks/trial --mirror-only My::App
```

Wenn alles gut geht, entferne den Pin vom "master"-Stack und ziehe
die neue Version von URI auch in diesen Stack:

```
pinto -r ~/repo unpin URI
pinto -r ~/repo pull URI~1.62
```

## Vergangene Änderungen durchsehen

Wie Du eventuell schon festgestellt hast, benötigt jedes Kommando, das
den Zustand eines Stacks verändert, eine Log-Meldung, die diese Änderung
beschreibt. Du kannst diese Meldungen mit dem Befehl `log`
durchsehen:

```
pinto -r ~/repo log
```

Das sollte in etwa folgendes anzeigen:

```
revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pin GAAS/URI-1.59.tar.gz

     Pinning URI because it is not causes our foo.t script to fail

revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pull GAAS/URI-1.59.tar.gz

     URI is required for HTTP support in our application

...
```

Die Kopfzeilen jeder Meldung zeigen, wer die Änderung wann durchgeführt hat.
Ebenso enthält sie einen eindeutigen Bezeichner, der ähnlich dem
SHA1-[Digest](http://de.wikipedia.org/wiki/Message_Digest) ist.
Du kannst diese Bezeichner verwenden, um den Unterschied verschiedener 
Revisionen anzuzeigen oder den Stack auf den Zustand einer vorherigen
Revision zu bringen [Bemerkung: Dieses Feature ist noch nicht implementiert].

## Fazit

In diesem Tutorial hast Du die grundlegenden Befehle gesehen, um eine
Pinto-Repository anzulegen und es mit Modulen zu befüllen. Du hast
auch gesehen, wie Du mit Stacks und Pins Deine Abhängigkeiten 
handhaben kannst, während Du mit gängigen Entwicklungshürden konfrontiert
wirst.

Jeder Befehl hat etliche Optionen, die hier in diesem Tutorial nicht
angesprochen wurden. Auch wurden einige Kommandos hier gar nicht erwähnt.
Daher möchte ich Dich ermutigen, das Handbuch für jedes Kommando anzusehen
und mehr über die verfügbaren Befehle zu lernen.

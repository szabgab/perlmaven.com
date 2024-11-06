---
title: "Installation und ein Anfang mit Perl"
timestamp: 2013-04-15T00:01:01
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
published: true
original: installing-perl-and-getting-started
books:
  - beginner
author: szabgab
translator: mca
---


Das ist der erste Teil des [Perl-Tutorials](/perl-tutorial).

In diesem Teil wirst Du lernen, wie man Perl unter Microsoft Windows installiert und
wie man beginnt es unter Windows, Linux und auf dem Mac zu benutzen.

Du wirst Hinweise bekommen, wie die Entwicklungsumgebung aufzusetzen ist. Oder in weniger grandiosen Worten:
Welchen Editor oder IDE soll ich für die Perl-Entwicklung benutzen?

Wir werden auch das Standard-Beispiel "Hallo Welt" sehen.


## Windows

Für Windows werden wir [DWIM-Perl](http://dwimperl.szabgab.com/) benutzen. Das ist
ein Paket, welches den Perl Compiler/Interpreter, [Padre, die Perl-Entwicklungsumgebung](http://padre.perlide.org/)
und eine Sammlung von CPAN-Erweiterungen enthält.

Um loslegen zu können, besuche die Webseite von [DWIM Perl](http://dwimperl.szabgab.com/)
und folgen dem Link zum Download von <b>DWIM Perl for Windows</b>.

Lade die exe-Datei herunter und installiere sie auf Deinem System.
Davor prüfe jedoch, dass keine andere Perl-Installation vorhanden ist.

Theoretisch können beide zusammenarbeiten. Das würde an dieser Stelle
aber viel mehr Erklärungen benötigen. Also, lass und mit einer einzigen
Installation starten.

## Linux

Die meisten modernen Linux-Distributionen kommen mit einer aktuellen
Version von Perl. Für's erste werden wir diese Version benutzen.
Als Editor kannst Du Padre installieren, welches i.d.R. als offizielles
Software-Paket der Distribution angeboten wird. Ansonsten kann jeder Texteditor
verwendet werden. Wenn Du vim oder Emacs kennst, benutze diese. Ansonsten
könnte auch Gedit ein guter, einfacher Editor sein.

## Apple

Ich bin mir sicher, dass Mac-Rechner auch Perl installiert haben oder dort einfach
als Standardinstallation nachinstalliert werden kann.

## Editor und IDE

Auch wenn ich dazu rate, muss die Padre-IDE nicht zwingend verwendet werden, um Perl-Code
zu schreiben. Im nächsten Teil werde ich einige [Editoren und IDE](/perl-editor)
auflisten, die zur Perl-Programmierung verwendet werden können. Auch wenn Du einen
anderen Editor auswählst, rate ich allen Windows-Nutzern zur Installation des oben
genannten DWIN-Perl-Pakets.

Es bringt schon viele Perl-Erweiterungen mit, so dass Du später viel Zeit
sparen wirst.

## Video

Wenn Du es vorziehst, kannst Du auch das Video [Hello world with Perl](http://www.youtube.com/watch?v=c3qzmJsR2H0)
auf YouTube ansehen. In diesem Fall willst Du Dir vielleicht auch den
["Beginner Perl Maven video course"](https://perlmaven.com/beginner-perl-maven-video-course) ansehen.

## Erstes Programm

Dein erstes Programm sieht folgendermaßen aus:

```perl
use 5.010;
use strict;
use warnings;

say "Hallo Welt";
```

Lass es mich Schritt für Schritt erklären.

## Hallo Welt

Nachdem DWIM-Perl installiert wurde, öffnen die Klicks auf
"Start -> Alle Programme -> DWIM Perl -> Padre" den Editor mit einer
leeren Datei.

Gib folgendes ein:

```perl
print "Hallo Welt\n";
```

Wie Du sehen kannst, enden Anweisungen in Perl mit einem Semikolon `;`.
Mit einem `\n` wird das Zeilenvorschub- bzw. Neuezeile-Zeichen (Newline) eingegeben.
Zeichenketten (Strings) sind in doppelte Anführungszeichen eingeschlossen `"`.
Die `print`-Funktion gibt auf dem Bildschirm aus.
Wenn also diese Zeile ausgeführt wird, dann gibt Perl den Text gefolgt von
einem Zeilenvorschub am Bildschirm aus.

Speichere die Datei nun mit dem Dateinamen "hallo.pl" ab, damit Du das Programm mit
der Auswahl "Ausführen -> Skript ausführen" starten kannst. Du wirst in einem
separatem Fenster die Ausgabe sehen.

Das war's. Du hast Dein erstes Perl-Skript geschrieben.

Lass es uns jetzt ein wenig erweitern.

## Perl auf der Kommandozeile für Nicht-Padre-Benutzer

Wenn Du nicht Padre oder einen der anderen [IDE](/perl-editor) benutzt,
kannst Du das Script nicht aus dem Editor heraus aufrufen. Zumindest nicht standardmäßig.
Du wirst dazu eine Shell bzw. Eingabeaufforderung öffnen und in das Verzeichnis
wechseln müssen, in dem das Skript 'hallo.pl' abgelegt ist. Dort gibst Du ein:

`perl hallo.pl`

So kann man das Perl-Skript auf der Kommandozeile ausführen.

## say() anstelle von print()

Lass uns das Einzeiler-Perl-Skript ein wenig verbessern:

Dazu müssen wir zuerst mitteilen, welche Minimalversion von
Perl genutzt werden soll:

```perl
use 5.010;
print "Hallo Welt\n";
```

Nachdem Du das eingegeben hast, kannst Du das Skript wieder mit "Ausführen -> Skript ausführen"
oder durch Drücken der Taste <b>F5</b> starten. Das speichert die Datei automatisch
bevor sie ausgeführt wird.

Es ist grundsätzlich empfohlene Praxis die Minimalversion von Perl anzugeben,
die für das Programm gebraucht wird.

In diesem Fall werden auch einige neue Eigenschaften, wie das `say`-Schlüsselwort,
hinzugefügt. `say` ist wie `print`, nur kürzer und fügt automatisch
einen Zeilenvorschub am Ende an.

Damit kann Dein Skript so geändert werden:

```perl
use 5.010;
say "Hallo Welt";
```

Wir haben `print` durch `say` ersetzt und das `\n` am Ende der Zeichenkette
entfernt.

Die aktuelle Perl-Installation hat wahrscheinlich die Version 5.12.3 oder 5.14.
Die meisten modernen Linux-Distributionen kommen mit Version 5.10 oder neuer.

Unfortunately there are still places using older versions of perl.
Those won't be able to use the `say()` keyword and might need some adjustments
to the examples later. I'll point out when I am actully using features
that require version 5.10.

Leider kommt es vor, dass ältere Versionen genutzt werden.
Diese sind nicht in der Lage das `say()`-Schlüsselwort zu benutzen
und benötigen einige Anpassungen in den späteren Beispielen. Ich werde
darauf hinweisen, wenn Merkmale verwendet werden, die mindestens
Version 5.10 benötigen.

## Sicherheitsnetz

Ich rate dringend dazu, in jedem Skript Anweisungen einzufügen, die das Verhalten
von Perl beeinflussen. Hierzu werden zwei davon, sog. Pragmas, die vergleichbar mit Compiler-Flags
anderer Programmiersprachen sind, eingefügt:

```perl
use 5.010;
use strict;
use warnings;

say "Hallo Welt";
```

In diesem Fall teilt das `use`-Schlüsselwort mit, dass die Pragmas eingeschaltet
werden sollen.

`strict` and `warnings` will help you catch some common bugs
in your code or sometimes even prevent you from making them in the first place.
They are very handy.

`strict` und `warnings` werden Dir dabei helfen, verbreitete Fehler
aufzuspüren oder Dich sogar davon abhalten, diese zu begehen. Somit sind die Pragmas
sehr nützlich.

## Benutzereingabe

So, nun lass uns unser Beispiel verbessern, indem wir den Benutzer nach
seinem Namen fragen und diesen in der Antwort einfügen.

```perl
use 5.010;
use strict;
use warnings;

say "Wie ist Dein Name? ";
my $name = <STDIN>;
say "Hallo $name, wie geht's Dir?";
```

`$name` wird als skalare Variable bezeichnet.

Variablen werden mit dem <b>my</b>-Schlüsselwort deklariert.
(Tatsächlich ist das eine der Anforderungen, die durch das
Pragma `strict` entstehen.)

Skalare Variablen beginnen immer mit einem `$`-Zeichen.
Die Anweisung &lt;STDIN&gt; wird benutzt, um eine Zeile von der Eingabe zu lesen.

Gib obiges Programm ein und starte es mit <b>F5</b>.

Es wird Dich nach Deinem Namen frage. Gib ihn ein und bestätige die Eingabe mit
der Eingabetaste (Enter, Return).

Du wirst bemerken, dass die Ausgabe ein wenig unschön ist, weil
das Komma nach dem Namen auf einer neuen Zeile erscheint. Das liegt daran
dass der Zeilenvorschub, der durch die Eingabetaste entstanden ist,
auch in die Variable `$name` eingelesen und mit ausgegeben wurde.

## Den Zeilenvorschub loswerden

```perl
use 5.010;
use strict;
use warnings;

say "Wie ist Dein Name? ";
my $name = <STDIN>;
chomp $name;
say "Hallo $name, wie geht's Dir?";
```

Es ist eine so weitverbreitete Aufgabe in Perl, einen Zeilenvorschub am
Ende einer Zeichenkette zu entfernen, dass es hierzu eine eigene Funktion `chomp`
gibt.

## Fazit

In jedem Skriptm das Du schreibst, solltest Du <b>immer</b> `use strict;` und `use warnings;`
als die beiden ersten Anweisungen hinzufügen. Ebenfalls rate ich dringend dazu,
`use 5.010;` anzugeben.

## Übungen

Ich habe Übungen versprochen.

Probiere das nachfolgende Skript aus:

```perl
use strict;
use warnings;
use 5.010;

say "Hallo ";
say "Welt";
```

Die Ausgabe ist nicht auf einer Zeile. Warum? Wie kann man es beheben?

## Übung 2

Schreibe ein Skript, das den Benutzer hintereinander nach zwei Zahlen 
fragt und anschließend die Summe davon ausgibt.

## Was kommt als Nächstes?

Der nächste Teil des Perl-Tutorials befasst sich mit
[Editoren, IDE und Entwicklungsumgebungen für Perl](/perl-editor).

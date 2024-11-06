---
title: "Debuggen von Perl-Sktipten"
timestamp: 2013-08-04T19:45:57
tags:
  - -d
  - Data::Dumper
  - print
  - debug
  - debugging
  - $VAR1
  - $VAR2
published: true
original: debugging-perl-scripts
books:
  - beginner
author: szabgab
translator: mca
---


Als ich an der Universität Informatik studiert habe, haben wir viel darüber gelernt, wie man man Programme
schreibt. So weit ich mich erinnern kann, niemand erklärte uns etwas über das Debugging. Wir
haben von der schönen Welt gehört, in der man neue Dinge erstellt, aber niemand sagte uns, dass wir
die meiste Zeit darauf verwenden werden, den Code anderer Leute zu verstehen.

Es stellt sich heraus, dass wir - während wir das Programmieren schätzen -
viel mehr Zeit darauf zu verwenden, unseren Code oder den Code anderer zu
verstehen und herauszufinden, warum er nicht wie gewünscht funktioniert, als
die Zeit, die zur initialen Programmierung verwendet wurde.


## Was ist Debuggen?

Bevor ein Programm gestartet wurde, war alles in einem bekannten, guten Zustand.

Nachdem das Programm gelaufen ist, ist irgendetwas in einem unerwarteten, schlechten Zustand.

Die Aufgabe besteht nun darin, herauszufinden, an welchem Punkt etwas falsch gelaufen ist, und
dieses zu korrigieren.

## Was ist Programmieren und was ist ein Fehler?

Im Grunde ist Programmieren das marginale Verändern der Welt durch das Verschieben von Daten in Variablen.

In jedem Schritt des Programms ändern wir einige Daten in einer Variable des Programms, oder auch etwas in der realen Welt.
(Z.B. auf der Festplatte oder auf dem Monitor.)

Wenn Du ein Programm schreibst, denkst Du bei jedem Schritt: Welcher Wert muss in welche Variable geschrieben werden.

Ein Bug ist dann der Fall, wenn Du gedacht hast, dass Du den Wert X in eine Variable geschrieben hast, wenn in
Wirklichkeit der Wert Y hineingeschrieben wurde.

Zu irgendeinem Zeitpunkt - meistens am Ende eines Programms - kanst Du es daran erkennen, dass das Programm
einen falschen Wert ausgegeben hat.

Während des Programmlaufs kann es sich darin zeigen, dass Warnungen auftreten oder das Programm unerwartet terminiert wird.

## Deguggen, aber wie?

Der direkteste Weg, ein Programm zu debuggen, ist es laufen zu lassen und bei jedem Schritt zu prüfen, ob
alle Variablen den erwarteten Wert haben. Dies kannst Du entweder unter <b>Verwendung eines Debuggers</b> oder
durch das Einbetten von <b>print-Anweisungen</b>, deren Ausgabe Du am Ende des Programmlaufs untersuchst, erreichen.

Perl hat einen sehr mächtigen Kommandozeilen-Debugger. Obwohl ich dazu rate, ihn zu erlernen,
kann er zu Beginn ein wenig einschüchternd sein. Ich habe ein Video vorbereitet, in dem ich 
die [grundlegenden Befehle des eingebauten Perl-Debuggers](https://perlmaven.com/using-the-built-in-debugger-of-perl) zeige.

IDE, wie z.B.  [Komodo](http://www.activestate.com/), [Eclipse](http://eclipse.org/) und
[Padre](http://padre.perlide.org/) haben einen grafischen Debugger. Ich habe vor,
ein disbezügliches Video vorzubereiten.


## print-Anweisungen

Viele Leute verwenden die uralte Strategie, print-Anweisungen im Code einzufügen.

In einer Sprache, in der das Kompilieren und Zusammenbauen viel Zeit in Anspruch nimmt,
wird das Hinzufügen von print-Anweisungen als keine gute Idee angesehen.
Nicht jedoch in Perl, wo selbst große Applikationen in wenigen Sekunden starten.

Beim Hinzufügen von print-Anweisungen sollte man darauf achten, dass man Begrenzungszeichen um den zu druckenden
Wert hinzufügt, um erkennen zu können, ob der Wert führende oder nachfolgende Leerzeichen ethält, welche
das Problem verursachen. Diese kann man nur schwer ohne Berenzungszeichen erkennen.

Skalare Werte kann man folgendermaßen ausgeben:

```perl
print "<$file_name>\n";
```

Hier sind die Kleiner- und Größer-Zeichen nur dazu da, dem Leser zu erleichtern, den tatsächlichen
Wert der Variable leichter zu erkennen.

```
<path/to/file
>
```

Wenn das obige ausgegeben wird, kann man schnell erkennen, dass in der Variable $file_name ein Neuezeile-Zeichen
am Ende enthalten ist. Eventuell hast Du vergessen die Funktion <b>chomp</b> aufzurufen.

## Komplexe Datenstrukturen

Wir haben bisher noch nicht einmal skalare Werte gelernt, aber lass mich ein wenig vorausspringen
und Dir zeigen, wie man den Inhalt einer komplexeren Datenstruktur ausgibt. Wenn Du das hier im
Rahmen des Perl-Tutorials liest, wirst Du eventuell zum nächsten Eintrag springen wollen und später
zurückkommen. Dies hier wird Dir wahrscheinlich nicht viel sagen.

Ansonsten, lies hier weiter.

Für komplexe Datenstrukturen (Referenzen, Arrays und Hashes) kannst Du `Data::Dumper` benutzen.

```perl
use Data::Dumper qw(Dumper);

print Dumper \@an_array;
print Dumper \%a_hash;
print Dumper $a_reference;
```

Diese Anweisungen werden exemplarisch das hier ausgeben, was hilft, den Inhalt der Variablen
zu verstehen, zeigen aber nur generische Variablennamen, wie `$VAR1` und `$VAR2`.

```
$VAR1 = [
       'a',
       'b',
       'c'
     ];
$VAR1 = {
       'a' => 1,
       'b' => 2
     };
$VAR1 = {
       'c' => 3,
       'd' => 4
     };
```

I'd recommend adding some more code and printing the name of the variable like this:

Ich rate dazu, ein wenig mehr Code zu schreiben und den Namen der Variable wie folgt auszugeben:

```perl
print '@an_array: ' . Dumper \@an_array;
```

um das hier zu erreichen:

```
@an_array: $VAR1 = [
        'a',
        'b',
        'c'
      ];
```

oder mit Data::Dumper etwa so:

```perl
print Data::Dumper->Dump([\@an_array, \%a_hash, $a_reference],
   [qw(an_array a_hash a_reference)]);
```

um das zu erhalten:

```
$an_array = [
            'a',
            'b',
            'c'
          ];
$a_hash = {
          'a' => 1,
          'b' => 2
        };
$a_reference = {
               'c' => 3,
               'd' => 4
             };
```

Es gibt bessere Arten, um Datenstrukturen auszugeben, aber im Moment sollte
`Data::Dumper` gut genug sein, und es ist auch in jeder Perl-Installation
verfübar. Wir werden andere Methoden später erörtern.

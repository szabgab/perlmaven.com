---
title: "POD - Plain Old Documentation (Dokumentationsformat von Perl)"
timestamp: 2013-04-22T12:40:59
tags:
  - POD
  - perldoc
  - =head1
  - =cut
  - =pod
  - =head2
  - Dokumentation
  - pod2html
  - pod2pdf
published: true
original: pod-plain-old-documentation-of-perl
books:
  - beginner
author: szabgab
translator: mca
---


Programmierer mögen es normalerweise nicht so sehr, Dokumentation zu schreiben.
Ein Teil des Problems rührt daher, dass Programme einfache Textdateien sind,
die Programmierer in vielen Fällen jedoch Dokumentation in einem
Textverarbeitungsprogramm schreiben müssen.

Das führt dazu, dass sowohl das Textverarbeitungsprogramm erlernt werden
muss als und viel Energie darauf verwendet wird, das Dokument gut aussehen
zu lassen, anstelle dafür zu sorgen, dass es inhaltlich gut ist.

Das ist nicht der Fall mit Perl. Normalerweise wird die Dokumentation
direkt in den Quelltext des Moduls geschrieben und darauf vertraut,
dass externe Werkzeuge diese in ein gut aussehendes Format bringen.


In dieser Episode des [Perl-Tutorials](/perl-tutorial)
werden wir die <b>POD - Plain Old Documentation</b> kennenlernen,
eine Auszeichnungssprache, die von Perl-Programmieren zur Dokumentation verwendet wird.
(Plain Old Documentation kann man in etwa übersetzen mit "Schlichte,
alte Dokumentation". Da das Akronym POD ein fester Bestandteil in der Perl-Szene
ist, werden wir hier und im weiteren Verlauf 
keinen Versuch unternehmen, eine deutsche Übersetzung zu finden.)

Ein einfaches Stück Perl-Quelltext mit POD sieht so aus:

```perl
#!/usr/bin/perl
use strict;
use warnings;

=pod

=head1 BESCHREIBUNG

Dieses Skript nimmt zwei Parameter entgegen. Den Namen und die Adresse
eines Rechners und ein Kommando. Es wird das Kommando auf
dem angegebenen Rechner ausführen und die Ausgabe auf dem Bildschirm
anzeigen.

=cut

print "Hierher kommt der Quelltext ... \n";
```

Wenn Du diese Zeilen in eine Datei `script.pl` abspeicherst und mit
`perl script.pl` zur Ausführung bringst, wird Perl alles zwischen
den Anweisungen `=pod` und  `=cut` ignorieren und den
verbleibenden Code ausführen.

Wenn Du hingegen `perldoc script.pl` eingibst, wird das <b>perldoc</b>-Kommando
jeglichen Perl-Quelltext ignorieren. Es liest die Zeilen zwischen `=pod` und
`=cut` aus, formatiert diese anhand festgelegter Regeln und gibt sie
auf dem Bildschirm aus.

Diese Regeln hängen von dem verwendeten Betriebssystem ab, sind aber exakt die
gleichen, die wir in dem Artikel [Perl-Basis- und CPAN-Modul-Dokumentation](/perl-basis-und-cpan-modul-dokumentation)
gesehen haben.

Der Zusatznutzen diese eingebettete POD zu benutzen ist, dass Dein Code nie
aufgrund eines Versehens ohne Dokumentation daher kommt, da sie ja
innerhalb deiner Skripte und Module vorhanden ist. Du kannst dabei auch
die Werkzeuge und die Infrastruktur nutzen, die die Open-Soure-Perl-Gemeinschaft
für sich selbst erstellt haben. Selbst für die private Nutzung.

## Zu einfach?

Die Annahme ist die, dass, je mehr Hürden zum Schreiben von Dokumentation genommen
werden, desto mehr wird Dokumentation geschrieben.
Anstelle ein Textverarbeitungsprogramm zu lernen, um schön aussehende Dokumente
zu kreieren, schreibst Du einfach ein wenig Text angereichert durch extra
Symbole und Du bekommst ein brauchbar aussehendes Dokument.
(Schau Dir doch mal die Dokumente auf [MetaCPAN](http://metacpan.org/)
an, um schön formatiertes POD zu sehen.)

## Die Auszeichnungssprache

Eine ausführliche Beschreibung der [POD-Auszeichnungssprache](http://perldoc.perl.org/perlpod.html)
kannst Du durch den Aufruf von [perldoc perlpod](http://perldoc.perl.org/perlpod.html)
auf der Kommandozeile erreichen. Sie ist jedoch - wie Du sehen wirst - sehr einfach.

Es gibt einige Textauszeichnungen, wie z.B. `=head1` und
`=head2`, um "sehr wichtige" und "weniger wichtige" Überschriften
zu markieren. Es gibt `=over` , um eine Einrückung einzuleiten,
und `=item`, um einen Aufzählungspunkt zu erstellen. Und einige mehr.

Es gibt `=cut`, um das Ende eines POD-Abschnitts zu markieren,
und `=pod`, um so einen Abschnitt einzuleiten, obwohl dieser
nicht zwingend erforderlich ist.

Jede Zeichenkette, die mit einem Gleichheitszeichen am Anfang einer Zeile beginnt,
wird als POD-Auszeichnung interpretiert und damit einen POD-Abschnitt starten,
welcher mit `=cut` wieder beendet wird.

POD erlaubt sogar das Einbinden von Hyperlinks mit der Notation L&lt;some-link>.

Text zwischen den Auszeichnungen wird als normaler Textabsatz dargestellt.

Wenn Text nicht auf der ersten Position einer Zeile beginnt, wird er genaus so
übernommen, wie er geschrieben wurde: Lange Zeilen werden nicht umgebrochen und
kurze Zeilen bleiben so kurz. Dieses Verhalten wird für Code-Beispiele genutzt.

Eine wichtige Sache, der man sich bewusst sein muss, ist, dass POD um die 
Auszeichnungen herum leere Zeilen fordert.
Damit

```perl
=head1 Titel
=head2 Untertitel
Einiger Text
=cut
```

macht nicht das, was Du erwartest.

## Das Aussehen

Da POD eine Auszeichungssprache ist, definiert sie selbst nicht, wie Dinge dargestellt werden.
Benutzt man `=head1` zeigt das etwas bedeutendes an, benutzt man `=head2`
bedeutet dies etwas weniger wichtiges.

Das Werkzeug, welches POD zur Anzeige bringt, wird normalerweise den mit head1 ausgezeichneten
Text mit einer größeren Schrift darstellen als den mit head2 markierten. Dieser wiederum
wird wohl größer dargestellt werden als normaler Text. Gesteuert wird dies
jedoch durch die Darstellungswerkzeuge.

Das  `perldoc`-Kommando, das mit Perl mitkommt, stellt POD als Handbuch-Seiten (man pages) dar.
Unter Linux ziemlich nützlich, unter Windows nicht ganz so gut.

Das Modul [Pod::Html](https://metacpan.org/pod/Pod::Html) stellt ein weiteres Kommandozeilen-Werkzeug
mit dem Namen `pod2html` bereit. Dieses kann POD in HTML umwandeln, welches dann im Browser angezeigt werden kann.

Es gibt andere Werkzeuge, um aus POD PDF oder Mobipocket-eBook-Dateien zu generieren.

## Wer ist die Zielgruppe?

Nachdem wir die Technik gesehen haben, sehen wir uns die Zielgruppe an.

Kommentare (die Zeilen, die mit einem # anfangen) sind Erklärungen für
denjenigen, der Wartung durchführt, der neue Funktionen hinzufügt
oder Fehler behebt.

Dokumentation, die in POD geschrieben ist, ist für Benutzer. Für diejenigen,
die sich i.d.R. keinen Quelltext ansehen. Im Fall einer Applikation
würden diese "End-User" genannt werden, also jeder.

Im Fall von Perl-Modulen sind es anderer Programmierer, die
Applikationen  oder andere Module erstellen. Dieses sollten 
trotzdem nicht den Quelltext ansehen müssen. Sie sollten in der Lage
sein, Dein Modul nur durch Lesen der Dokumentation mit `perldoc`
benutzen zu können.

## Fazit

Dokumentation zu schreiben und diese gut aussehen zu lassen, ist nicht so schwer in Perl.

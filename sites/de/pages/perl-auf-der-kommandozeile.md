---
title: "Perl auf der Kommandozeile"
timestamp: 2013-04-15T22:53:00
tags:
  - -v
  - -e
  - -p
  - -i
published: true
original: perl-on-the-command-line
books:
  - beginner
author: szabgab
translator: mca
---


Während es beim [Perl-Tutorial](/perl-tutorial) vorwiegend um Skripte geht, die
in Dateien gespeichert werden, werden wir hier einige Beispiel von sog. Einzeilern sehen.

Obwohl Du [Padre](http://padre.perlide.org/) oder eine andere IDE benutzt,
die Dir gestattet, Skripte direkt aus dem Editor heraus zu starten, ist es äußerst
wichtig, sich mit der Kommandozeile (oder Shell) auseinander zu setzen, um auch
von da aus Perl nutzen zu können.


Wenn Du Linux benutzt, öffne ein Terminal-Fenster. Du solltest ein
Bereitschaftszeichen (Prompt) sehen, das eventuell auf ein $-Zeichen endet.

Wenn Du hingegn Windows benutzt, öffne die Eingabeaufforderung mit:

Start -> Ausführen -> Tippe dort "cmd" -> ENTER

Du wirst nun ein schwarzes Fenster mit dem Titel "Eingabeaufforderung" und einem
Prompt sehen, der folgendermaßen aussieht:

```
c:\>
```

## Perl-Version

Gib nun  `perl -v` ein. Das wird Dir etwa folgendes ausgeben:

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

Mit dieser Ausgabe kann ich ersehen, dass Perl, welches unter Windows installiert ist,
die Version 5.12.3 hat.


## Eine Nummer ausgeben

Nun gib `perl -e "print 42"` ein.
Das wird die Nummer `42` auf dem Bildschirm ausgeben.
Unter Windows erscheint der Prompt auf der nächsten Zeile.

```
c:>perl -e "print 42"
42
c:>
```

Unter Linux wirst Du in etwa dieses sehen:

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

Das Ergebnis erscheint am Anfang der Zeile, direkt gefolgt vom Prompt.
Der Unterschied ergibt sich aus dem unterschiedlichen Verhalten der beiden Kommandozeilen-Interpreter.

In diesem Beispiel benutzen wir die Option  `-e` um Perl folgendes mitzuteilen:
"Erwarte keine Datei. Es folgt direkt der Perl-Code auf der Kommandozeile."

Die obigen Beispiele sind natürlich nicht sonderlich interessant. Lass mich Dir ein leicht
komplexeres Beispiel zeigen, ohne Erklärung:

## Ersetze Java durch Perl

Das Kommando `perl -i.bak -p -e "s/\bJava\b/Perl/" lebenslauf.txt`
wird alle Vorkommen des Worts <b>Java</b> durch das Wort <b>Perl</b>
in Deinem Lebenslauf ersetzen, wobei es ein Backup der Originaldatei anlegt.

Unter Linux könntest Du sogar `perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt`
schreiben, um das Wort Java durch Perl in allen Deinen Text-Dateien zu ersetzen.

In einem späteren Abschnitt werden wir mehr über Einzeiler reden und Du wirst lernen,
wie Du sie nutzen kannst. Genug geplaudert: Das Wissen um Perl-Einzeiler ist 
ein mächtiges Werkzeug in Deinen Händen.

Übrigens, wenn Du Interesse an einigen wirklich guten Einzeilern hast, empfehle ich
[Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/)
von Peteris Krumins zu lesen.

## Demnächst

Der nächste Teil handelt über [Perl-Basisdokumentation und Dokumentation der CPAN-Module](/perl-basis-und-cpan-modul-dokumentation).

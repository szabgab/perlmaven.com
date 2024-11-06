---
title: "Perl-Tutorial"
timestamp: 2012-07-06T00:01:00
description: "Freies Perl-Tutorial für Leute, die Perl-Code pflegen müssen, die kleine Perl-Skripte schreiben, und für die Perl-Applikationsentwicklung."
types:
  - Kurs
  - Anfänger
  - Tutorial
  - Training
published: true
original: perl-tutorial
author: szabgab
translator: mca
archive: false
---

<div class="main-content">
Anmerkung: Das Perl-Tutorial, welches in englischer Sprache von [Gabor Szabo](/about)
verfasst wurde und verfasst wird, wird auf eine Initiative von Gabor hin durch
freiwillige Helfer in verschiedene Sprachen übersetzt. Früher oder später wird man
als Perl-Programmierer und Programmierer im Allgemeinen nicht umhin kommen, Grundlagen
der englischen Spache zu lernen, um von der primär in englischer Sprache verfassten
Dokumentation profitieren zu können. Auch andere Informationsquellen, wie z.B. Foren,
Newsletter, werden i.d.R. in Englisch verfasst.
Die Einstiegshürde muss jedoch - speziell für Anfänger - nicht unnötig erhöht werden,
zumal ja schon eine Sprache, die Perl-Programmiersprache gelernt werden soll.
Alle Verweise auf Artikel, die noch nicht übersetzt wurden, sind auf das englische
Original gelenkt, um die Navigationsstruktur bestmöglich aufrecht zu erhalten.
</div>

Das Perl-Maven-Tutorial wird Dir die Grundlagen der Perl-Programmiersprache beibringen.
Du wirst in der Lage sein, kleine Skripte zu schreiben, Log-Dateien zu analysieren und
CSV-Dateien zu schreiben. Nur um einige der verbreiteten Aufgaben zu nennen.

Du wirst lernen, wie man das CPAN und einige ausgesuchte CPAN-Module benutzt.

Es wird eine gute Grundlage sein, worauf Du aufbauen kannst.

Die freie Online-Vesrion des Tutorials is momentan in Entwicklung. Viele Teile sind fetig.
Zusätzliche Teile werden alle paar Tage veröffentlicht. Der letzte wurde am 12. April 2013 publiziert.
Wenn Du daran interessiert bist, benachrichtigt zu werden, wenn neue Artikel verfügbar sind,
dann melde Dich bitte zum [Newsletter](/register) an.

Es gibt auch eine [E-Book-Version](https://perlmaven.com/beginner-perl-maven-e-book) des gesamten Materials zum Kauf.
Zusätzlich zum freien Tutorial enthält diese Version auch die Unterlagen der betreffenden Kurse inklusive
vieler Übungen und derer Lösungen. Das Kursmaterial deckt alle Teile ab, inklusive der Bereiche, die
noch nicht durch die freie Version abgedeckt sind.

Der begleitende [Video-Kurs](https://perlmaven.com/beginner-perl-maven-video-course) beinhaltet über 210 Filme
mit einer Gesamtlänge über 5 Stunden. Zusätzlich zur Präsentation des Materials werden Erklärungen
zur Lösungen aller Übungen gegeben.
Das Paket beinhaltet ebenfalls den Source-Code aller Beispiele und Übungen.

## Freies Online-Perl-Maven-Tutorial für Anfänger

In diesem Tutorial wirst Du lernen, wie man mit Perl 5 <b>seine Aufgaben erledigen</b> kann.

Du wirst sowohl grundlegende Sprach-Bestandteile als auch Erweiterungen und Bibilotheken oder -
wie der Perl-Programmierer sie nennt - <b>Module</b> kennenlernen. Wir werden neben Standard-Modulen,
die mit Perl ausgeliefert werden, auch Dritt-Module sehen, die wir von <b>CPAN</b>
installieren werden.

Wenn es geht, werde ich versuchen, Bereiche aufgabenbezogen zu lehren.
D.h. ich werde Aufgabenstellungen formulieren, um diese dann mit den
notwendigen Werkzeugen zu lösen. Wenn möglich, werde ich Übungen anbieten,
mit denen Du das vertiefen kannst, was Du gerade gelernt hast.

<p>
<b>Einführung</b>
<ol>
<li>[Installation von Perl, Ausgabe 'Hallo Welt', Sicherheitsnetz (use strict, use warnings)](/installation-und-ein-anfang-mit-perl)</li>
<li>[Editoren, IDE und Entwicklungsumgebungen für Perl](/perl-editor)</li>
<li>[Perl auf der Kommandozeile](/perl-auf-der-kommandozeile)</li>
<li>[Perl-Basisdokumentation, CPAN-Modul-Dokumentation](/perl-basis-und-cpan-modul-dokumentation)</li>
<li>[POD - Plain Old Documentation](/pod-plain-old-documentation-dokumentationsformat-von-perl)</li>
<li>[Debuggen von Perl-Skripten](/debuggen-von-perl-skripten)</li>
</ol>

<b>Skalare</b>
<ol>
<li>Verbreitete Warnungen und Fehler-Meldungen<br />
* [Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)
* [Use of uninitialized value](/use-of-uninitialized-value)
* [Bareword not allowed while "strict subs" in use](/barewords-in-perl)
* [Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo)
* [Unknown warnings category](/unknown-warnings-category)
* [Scalar found where operator expected](/scalar-found-where-operator-expected)
</li>
<li>[Automatische Umwandlung von Zeichenkette zu Zahl](/automatische-typ-convertierung-bzw-casting-in-perl)</li>
<li>Bedingte Anweisung: if</li>
<li>[Wahrheitswerte (wahr/falsch) in Perl](/boolesche-werte-in-perl)</li>
<li>Numerische und Zeichenketten-Operatoren</li>
<li>[undef, der Initialwert und die defined-Funktion](/undef-und-defined-in-perl)</li>
<li>HERE-Dokumente</li>
<li>[Skalare](https://perlmaven.com/scalar-variables)</li>
<li>[Skalare vergleichen](https://perlmaven.com/comparing-scalars-in-perl)</li>
<li>[Zeichenketten-Funktionen: length, lc, uc, index, substr](https://perlmaven.com/string-functions-length-lc-uc-index-substr)</li>
<li>[Zahlenratespiel (rand, int)](https://perlmaven.com/number-guessing-game)</li>
<li>[while-Schleife in Perl](https://perlmaven.com/while-loop)</li>
</ol>

<b>Dateien</b>
<ol>
<li>die, warn and exit</li>
<li>[In Dateien schreiben](https://perlmaven.com/writing-to-files-with-perl)</li>
<li>[An Dateien anfügen](https://perlmaven.com/appending-to-files)</li>
<li>[Dateien öffnen und lesen](https://perlmaven.com/open-and-read-from-files)</li>
<li>[Dateien nicht auf die alte Art öffnen](https://perlmaven.com/open-files-in-the-old-way)</li>
<li>Binärmodus und mit Unicode umgehen</li>
<li>Aus Binärdateien lesen, read, eof</li>
<li>tell, seek</li>
<li>truncate</li>
</ol>

<b>Listen und Arrays</b>
<ol>
<li>Perls foreach-Schleife</li>
<li>[Die for-Schleife in Perl](https://perlmaven.com/for-loop-in-perl)</li>
<li>Listen in Perl</li>
<li>Module benutzen</li>
<li>[Arrays in Perl](https://perlmaven.com/perl-arrays)</li>
<li>Kommandozeilen-Parameter verarbeiten: @ARGV, Getopt::Long</li>
<li>[Wie wird eine CSV-Datei gelesen und verarbeitet? (split, Text::CSV_XS)](https://perlmaven.com/how-to-read-a-csv-file-using-perl)</li>
<li>[join](https://perlmaven.com/join)</li>
<li>[Das Jahr 19100 (time, localtime, gmtime)](https://perlmaven.com/the-year-19100) und die Einführung von Kontext</li>
<li>[Kontext-Abhängigkeit in Perl](https://perlmaven.com/scalar-and-list-context-in-perl)</li>
<li>[Arrays sortieren in Perl](https://perlmaven.com/sorting-arrays-in-perl)</li>
<li>[Eindeutige Werte in einem Array](https://perlmaven.com/unique-values-in-an-array-in-perl)</li>
<li>[Perl-Arrays manipulieren: shift, unshift, push, pop](https://perlmaven.com/manipulating-perl-arrays)</li>
<li>Stapel und Reihe</li>
<li>reverse</li>
<li>Der ternäre Operator</li>
<li>Schleifen-Kontrollen: next und last</li>
<li>min, max, sum: Nutzung von List::Util</li>
</ol>

<b>Unterroutinen</b>
<ol>
<li>[Unterroutinen und Funktionen in Perl](https://perlmaven.com/subroutines-and-functions-in-perl)</li>
<li>Parameter passing and checking for subroutines</li>
<li>Parameter-Übergabe und -Prüfung in Unterroutinen</li>
<li>Variable Anzahl von Parametern</li>
<li>Eine Liste zurückgeben</li>
<li>Rekursive Unterroutinen</li>
</ol>

<b>Hashes, Arrays</b>
<ol>
<li>[Perl Hashes (dictionary, associative array, look-up table)](https://perlmaven.com/perl-hashes)</li>
<li>[Perl-Hashes (Assoziative Arrays, Nachschlagetabellen)](https://perlmaven.com/perl-hashes)</li>
<li>exists, delete Hash-Elemente</li>
</ol>

<b>Reguläre Ausdrücke</b>
<ol>
<li>Reguläre Ausdrücke in Perl</li>
<li>Regex: Zeichenklassen</li>
<li>Regex: Quantifizierer</li>
<li>Regex: gieriger und nicht-gieriger Treffer</li>
<li>Regex: Gruppierung und Capture</li>
<li>Regex: Anker</li>
<li>Regex Optionen und Modifizierer</li>
<li>Ersetzungen (Suchen und Ersetzen)</li>
<li>[trim - führende und folgende Leerzeichen entfernen](https://perlmaven.com/trim)</li>
</ol>

<b>Perl und Shell-verwandte Funktionalitäten</b>
<ol>
<li>Perl -X Operatoren</li>
<li>Perl-Pipes</li>
<li>Externe Programme ausführen</li>
<li>Unix-Kommandos: rm, mv, chmod, chown, cd, mkdir, rmdir, ln, ls, cp</li>
<li>[Wie man Dateien mit Perl löscht, kopiert und umbenennt.](https://perlmaven.com/how-to-remove-copy-or-rename-a-file-with-perl)</li>
<li>Windows/DOS-Kommandos: del, ren, dir</li>
<li>Datei-Globbing (Platzhalter)</li>
<li>Verzeichnis-Handles</li>
<li>Verzeichnisbaum durchlaufen (find)</li>
</ol>

<b>CPAN</b>
<ol>
<li>[Herunterladen und Installation von Perl (Strawberry Perl oder manuelles Kompilieren)](https://perlmaven.com/download-and-install-perl)</li>
<li>Herunterladen und Installation von Perl mithilfe von Perlbrew</a></li>
<li>Auffinden und Evaluierung von CPAN-Modulen</li>
<li>Herunterladen und Installation von Perl-Modulen von CPAN</li>
<li>[Wie muss @INC geändert werden, um Perl-Module in Nicht-Standard-Verzeichnissen zu finden?](https://perlmaven.com/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)</li>
<li>Wie wird @INC auf ein relatives Verzeichnis geändert?</li>
<li>local::lib</li>
</ol>

<b>Einige Beispiele für den Gebrauch von Perl</b>
<ol>
<li>[Wie wird eine Zeichenkette in einer Datei ersetzt (slurp)](https://perlmaven.com/how-to-replace-a-string-in-a-file-with-perl)</li>
<li>Excel-Dateien mit Perl lesen</li>
<li>Excel-Dateien erstellen mit Perl</li>
<li>E-Mail versenden mit Perl</li>
<li>CGI-Skripte mit Perl</li>
<li>Web-Applikationen mit Perl: PSGI</li>
<li>XML-Dateien parsen</li>
<li>JSON-Dateien lesen und schreiben</li>
<li>Datenbank-Zugriff mit Perl (DBI, DBD::SQLite, MySQL, PostgreSQL, ODBC)</li>
<li>Zugriff auf LDAP mit Perl</li>
</ol>

<b>Sonstiges</b>
<ol>
<li>[Splice, um Arrays in Perl zu zerschneiden](https://perlmaven.com/splice-to-slice-and-dice-arrays-in-perl)</li>
<li>[Wie erstellt man ein Perl-Modul für Code-Wiederverwendung?](https://perlmaven.com/how-to-create-a-perl-module-for-code-reuse)</li>
<li>[Objektorientiertes Perl mit Moose](https://perlmaven.com/object-oriented-perl-using-moose)</li>
<li>[Attributtypen in Perl-Klassen mit Moose](https://perlmaven.com/attribute-types-in-perl-classes-when-using-moose)
</ol>

<hr />

Nur als Erinnerung: Es gibt zugehörige [E-Books](https://perlmaven.com/beginner-perl-maven-e-book) und
[Video-Kurse](https://perlmaven.com/beginner-perl-maven-video-course) zu kaufen.


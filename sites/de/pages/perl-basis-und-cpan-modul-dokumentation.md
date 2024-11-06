---
title: "Perl-Basis- und CPAN-Modul-Dokumentation"
timestamp: 2013-04-20T07:45:56
tags:
  - perldoc
  - Dokumentation
  - POD
  - CPAN
published: true
original: core-perl-documentation-cpan-module-documentation
books:
  - beginner
author: szabgab
translator: mca
---


Perl kommt mit wirklich viel Dokumentation daher, aber es braucht seine Zeit
bis man sich daran gewöhnt hat, sie zu benutzen. In diesem Teil
des [Perl-Tutorials](/perl-tutorial) werde ich erklären,
wie man sich darin zurecht findet.


## perldoc im Web

Die bequemste Weise, auf die Dokumentation von Perl zuzugreifen,
ist ein Besuch der [perldoc](http://perldoc.perl.org/)-Webseite.

Sie enthält die HTML-Version der Perl-Dokumentation, sowohl für die Skriptsprache
selbst als auch für die Module, die mit der Perl-Kerninstallation von den "Perl 5 Porters"
veröffentlicht werden.

Sie beinhaltet hingegen nicht die Dokumentation der CPAN-Module. Es gibt
jedoch Überschneidungen, da einige der Module, die vom CPAN bezogen werden können,
auch in der Standard-Perl-Distribution enthalten sind. (Diese
werden oft als <b>dual-lifed</b> bezeichnet.)

Du kannst das Such-Eingabefeld in der oberen rechten Ecke benutzen. Wenn Du dort
z.B. `split` eintippst, bekommst Du die Dokumentation von `split`
angezeigt.

Leider weiß es weder mit der Eingabe von `while`, noch mit der 
Eingabe von `$_` oder `@_` etwas anzufangen. Um eine Erklärung
für diese Elemente zu bekommen, musst Du die Dokumentation blättern.

Die wichtigste Seite ist wahrscheinlich [perlvar](http://perldoc.perl.org/perlvar.html),
auf der Du Informationen über Variablen wie `$_` und `@_` erhältst.

[perlsyn](http://perldoc.perl.org/perlsyn.html) erklärt die Syntax von Perl
einschließlich der [while loop](https://perlmaven.com/while-loop).

## perldoc auf der Kommandozeile

Die gleiche Dokumentation ist beim Source-Code von Perl dabei, aber nicht
jede Linux-Distribution installiert sie standardmäßig. In einigen Fällen ist
sie in ein eigenes Paket ausgelagert. Bei Debian und Ubuntu ist es z.B.
das <b>perl-doc</b>-Paket. Um es zu installieren, musst Du `sudo aptitude install perl-doc`
eingeben. Dann kannst Du `perldoc` benutzen.

Nachdem Du perldoc installiert hast, kannst Du `perldoc perl` auf der 
Kommandozeile eintippen, worauf Du einleitende Erklärungen und eine Liste der
Kapitel innerhalb der Perl-Dokumentation erhältst. Die Anzeige kannst Du
mit Drücken der Taste `q` beenden. Danach kannst Du einen Kapitelnamen
eingeben, z.B. `perldoc perlsyn`.

Das funktioniert sowohl unter Linux als auch unter Windows, wobei das Anzeigeprogramm
von Windows relativ schwach ist. Unter Linux ist es das bekannte manpage-Anzeigeprogramm,
mit dem Du schon vertraut sein solltest.

## Dokumentation der CPAN-Module

Jedes Modul auf CPAN kommt mit Dokumentation und Beispielen, wobei
der Umfang und die Qualität dieser von Autor zu Autor unterschiedlich
ist. Und selbst ein einzelner Autor kann sehr gut und eher schlecht dokumentierte
Module haben.

Nachdem Du ein Modul mit dem Namen Module::Name installiert hast,
kannst Du die Dokumentation mit Eingabe von `perldoc Module::Name`
aufrufen.

Jedoch gibt es auch einen bequemeren Weg, der nicht einmal die Installation
des Moduls erfordert. Es gibt verschiedene Weboberflächen für CPAN.
Die wichtigsten sind [MetaCPAN](http://metacpan.org/)
und [Search CPAN](http://search.cpan.org/).

Beide basieren auf der gleichen Dokumentation, doch das Erscheinungsbild
ist ein wenig anders.


## Schlüsselwortsuche bei Perl-5-Maven

Eine der letzten Erweiterungen in diesem Web-Auftritt ist die
Schlüsselwortsuche in der oberen Menüleiste. Nach und nach wirst
Du hier immer mehr Beschreibungen zu Perl finden. Irgendwann wirst
Du hier auch die Perl-Basisdokumentation und die der wichtigsten
CPAN-Module finden.

Solltest Du hier etwas vermissen, dann schreibe doch einfach einen
Kommentar mit dem von Dir vermissten Schlüsselwort. Es ist gut 
möglich, dass Deine Anfrage erfüllt wird.


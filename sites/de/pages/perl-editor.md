---
title: "Perl-Editor"
timestamp: 2013-04-16T19:45:56
tags:
  - IDE
  - editor
  - Padre
  - vim
  - emacs
  - Eclipse
  - Komodo
published: true
original: perl-editor
books:
  - beginner
author: szabgab
translator: mca
---


Perl-Skripte bzw. Perl-Programme sind eigentlich nur einfache Text-Dateien.
Du kannst jede Art von Editor nutzen, aber Du solltest keine Textverarbeitung
verwenden. Lass mich einige Editoren und IDE vorstellen.

Übrigens: Dieser Artikel ist Teil des [Perl-Tutorials](/perl-tutorial).


## Editor oder IDE?

Zur Perl-Entwicklung kannst Du entweder einen einfachen Text-Editor
oder eine integrierte Entwicklungsumgebung (eng. Integrated Development
Environment, kurz IDE) verwenden.

Zuerst werden ich auf die Editoren eingehen, die Du auf den gängigen
Plattformen benutzen kannst, und dann auf integrierte Entwicklungsumgebungen,
die normalerweise plattformunabhängig sind.

## Unix / Linux

Wenn Du unter Linux oder Unix arbeitest, dann sind die gängigsten Editoren
[Vim](http://www.vim.org/) und
[Emacs](http://www.gnu.org/software/emacs/).
Diese beiden verfolgen sehr unterschiedliche Philosophien, in Bezug
auf den anderen und auf jeden sonstigen der meisten Editoren.

Wenn Du mit einem von den beiden vertraut bist, dann rate ich ihn zu verwenden.

Für jeden der beiden gibt es spezielle Erweiterungen oder Modi, um
bessere Perl-Unterstützung zu bieten. Aber selbst ohne diese sind sie
für die Perl-Entwicklung sehr gut geeignet.

Wenn Dir diese Editoren nicht bekannt sind, dass rate ich dazu das Erlernen
des Editors vom Erlernen von Perl zu trennen.

Beide diser Editoren sind sehr leistungsfähig, brauchen aber eine lange Einarbeitung.

Es ist jetzt wohl besser, sich auf das Erlernen von Perl zu fokussieren, und später
einen dieser Editoren zu erlernen.

Obwohl sie ursprünglich aus dem Unix/Linux-Umfeld stammen, gibt es
<b>Emacs</b> und <b>Vim</b> auf allen anderen maßgeblichen Plattformen.

## Perl-Editoren für Windows

Unter Windows benutzen viele Leute die sogenannten "Programmierer-Editoren".

* [Ultra Edit](http://www.ultraedit.com/) ist ein kommerzieller Editor.
* [TextPad](http://www.textpad.com/) ist Shareware.
* [Notepad++](http://notepad-plus-plus.org/) ist ein Open-Source- und freier Editor.

Ich habe <b>Notepad++</b> sehr viel genutzt und auf Windows installiert gelassen,
weil er sehr nützlich sein kann.

## Mac-OSX

Ich habe keinen Mac, aber - was man allgemein hört - ist
der [TextMate](http://macromates.com/) der meistgenutzte
Editor für Perl auf dem Mac.

## Perl-IDE

Keiner der beiden oben erwähnten Editoren stellt eine integrierte Entwicklungsumgebungen dar,
da keiner einen echten, integrierten Debugger für Perl und auch keine
sprachspezifische Hilfe anbietet.

[Komodo](http://www.activestate.com/) von ActiveState kostet einige hundert Euro.
Es gibt eine kostenlose Version mit eingeschränkter Funktionalität.

Programmierer, die schon [Eclipse](http://www.eclipse.org/)-Nutzer sind, sind
vielleicht interessiert zu hören, dass es ein Perl-Plugin für Eclipse mit dem Namen EPIC gibt.
Ebenfalls gibt es ein Projekt mit dem Namen [Perlipse](https://github.com/skorg/perlipse).

## Padre, die Perl-IDE

Im Juli 2008 habe ich damit angefangen eine <b>IDE für Perl in Perl</b> zu schreiben.
Ich habe sie Padre - Perl Application Development and Refactoring Environment -
oder auch einfach [Padre, die Perl-IDE](http://padre.perlide.org/)
genannt.

Viele Leute sind dem Projekt beigetreten. Padre wird von den maßgeblichen Linux-Distributionen
mitgeliefert, kann aber auch von CPAN installiert werden.
Sieh Dir die [Download](http://padre.perlide.org/download.html)-Seite für Details an.

In einigen Belangen ist Padre noch nicht so gut wie Eclipse oder Komodo, aber in anderen,
Perl-spezifischen Gebieten ist sie mittlerweile besser als die beiden anderen.

Außerdem wird Padre aktiv weiterentwickelt. Also, wenn Du nach einem Perl-Editor
bzw. nach einer Perl-IDE suchst, dann rate ich zu einem Versuch.

## Die große Perl-Editor-Umfrage

Im Oktober 2009 habe ich eine Umfrage ins Leben gerufen
und gefragt: [Welchen Editor oder IDE benutzt Du zur Perl-Entwicklung?](http://perlide.org/poll200910/)

So, nun kannst Du mit den Massen gehen, oder gegen sie, oder Du kannst einen Editor auswählen, 
der Dir am meisten zusagt.

## Andere

Alex Shatlovsky empfiehlt [Sublime-Text](http://www.sublimetext.com/), der ein plattformunabhängiger Editor ist,
der jedoch etwas Geld kostet.

## Demnächst

Der nächste Teil im Tutorial ist ein Schritt zur Seite, um über
[Perl auf der Kommandozeile](/perl-auf-der-kommandozeile)
zu sprechen.

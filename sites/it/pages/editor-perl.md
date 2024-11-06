---
title: "Editor Perl"
timestamp: 2013-04-17T11:55:01
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
translator: giatorta
---


Gli script e i programmi Perl sono semplicemente dei file di testo.
Potete usare un editor di testo qualunque per crearli, ma dovreste
evitare i word processor. Qui di seguito vi suggerisco un paio di editor e IDE.

Tra l'altro, quest'articolo fa parte del [tutorial Perl](/perl-tutorial).


## Editor o IDE?

Per sviluppare in Perl potete usare sia un semplice editor di testo che
un cosiddetto <b>Integrated Development Environment</b> (IDE).

Per prima cosa descriverò gli editor disponibili sulle principali piattaforme in uso,
e quindi descriverò gli IDE che solitamente sono multi-piattaforma.

## Unix / Linux

Se lavorate su Linux o Unix gli editor più comuni sono
[Vim](http://www.vim.org/) e
[Emacs](http://www.gnu.org/software/emacs/).
Le filosofie di questi due editor sono molto diverse, sia tra di loro che rispetto
alla maggior parte degli altri editor.

Se avete familiarità con uno di essi vi suggerisco di usarlo.

Ciascuno dei due editor ha le proprie estensioni o modalità che forniscono un supporto speciale al Perl,
ma anche senza di esse sono degli ottimi strumenti per lo sviluppo in Perl.

Se non ne conoscete nessuno dei due, vi consiglio invece di
tener separata la curva di apprendimento del Perl da quella dell'editor.

Emacs e Vim sono molto potenti ma richiedono molto tempo per essere padroneggiati.

Probabilmente è meglio focalizzarsi sullo studio del Perl, e imparare ad usare uno di questi editor in un altro momento.

Anche se <b>Emacs</b> e <b>Vim</b> in origine sono stati sviluppati per Unix/Linux, entrambi
 sono anche disponibili per tutti gli altri sistemi operativi più diffusi.

## Editor Perl per Windows

Sn Windows, molte persone usano i cosiddetti "editor per programmatori".

* [Ultra Edit](http://www.ultraedit.com/) è commerciale.
* [TextPad](http://www.textpad.com/) è shareware.
* [Notepad++](http://notepad-plus-plus.org/) è gratuito e open source.

Personalmente ho usato molto <b>Notepad++</b> e lo tengo installato sulla mia macchina Windows
perché può essere molto utile.

## Mac OSX

Non possiedo un Mac ma, secondo la vulgata comune,
[TextMate](http://macromates.com/) è l'editor specifico per Mac
usato più spesso per sviluppare in Perl.

## IDE Perl

Nessuno degli strumenti trattati sopra è un IDE, ovvero nessuno di essi integra
un vero debugger Perl oppure un help specifico per il linguaggio.

[Komodo](http://www.activestate.com/) della ActiveState costa qualche centinaio di dollari USA.
Ne esiste anche una versione limitata gratuita.

Gli utenti di [Eclipse](http://www.eclipse.org/) potrebbero essere interessati a sapere
che esiste un plug-in Perl per Eclipse chiamato EPIC. C'è anche il progetto
[Perlipse](https://github.com/skorg/perlipse).

## Padre, l'IDE Perl

A Luglio 2008 ho iniziato a scrivere un <b>IDE per Perl in Perl</b>. Ho deciso di chiamarlo Padre -
Perl Application Development and Refactoring Environment o
[Padre, l'IDE Perl](http://padre.perlide.org/).

Molte persone si sono unite al progetto. È distribuito insieme alle principali distribuzioni Linux
e può anche essere installato da CPAN. Vedete la pagina
[download](http://padre.perlide.org/download.html) per maggiori dettagli.

Per alcuni aspetti non è ancora all'altezza di Eclipse o Komodo ma per certi altri aspetti
specifici per il Perl è già superiore ad entrambi.

Inoltre, è sviluppato molto attivamente.
Se state cercando un <b>editor Perl</b> o un <b>IDE Perl</b>,
vi consiglio di provarlo.

## Il grande sondaggio sugli editor Perl

A Ottobr 2009 ho fatto un sondaggio chiedendo
[Quale/i editor o IDE usate per sviluppare in Perl?](http://perlide.org/poll200910/)

Sta a voi seguire la corrente, andarci contro o semplicemente scegliere l'editor perl editor più adatto a voi.

## Altro

Alex Shatlovsky ha suggerito [Sublime Text](http://www.sublimetext.com/), un editor multi-piattaforma
che però non è gratuito.

## E poi?

La prossima parte del tutorial è una piccola digressione sul [Perl da linea di comando](/perl-da-linea-di-comando).

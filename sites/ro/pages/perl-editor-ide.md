---
title: "Perl Editor"
timestamp: 2013-04-06T11:45:56
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
translator: tudorconstantin
---


Programele Perl sunt simple fișiere text.
Poți folosi orice editor de text pentru a le crea, dar nu recomand să folosești un procesor de text de tip office.
În articolul acesta voi descrie o listă a celor mai folosite editoare şi IDE-uri de Perl.

Articolul acesta e parte din [tutorialul de Perl](/perl-tutorial).



## Editor sau IDE?

Pentru dezvoltarea în Perl poți folosi, fie un simplu editor de text, fie un "mediu de dezvoltare integrat" (<b>Integrated Development Environment</b>), cunoscut ca IDE.

Să începem prin descrierea editoarelor specifice platformelor majore pe care e cel mai probabil să le folosești.


## Unix / Linux

Cele mai folosite editoare pentru Linux sau Unix, sunt:

[Vim](http://www.vim.org/) și
[Emacs](http://www.gnu.org/software/emacs/).

Amândouă au filosofii diferite între ele, precum și față de restul editoarelor existente pe piață.

Dacă ești obișnuit cu vreunul din ele, iți recomand să-l folosești.
Pentru fiecare există extensii speciale și moduri de lucru care oferă suport pentru Perl, dar chiar și fără acestea sunt foarte potrivite pentru dezvoltarea în Perl.

Dacă niciunul din ele nu iți este familiar, iți recomand să înveți editorul și Perl-ul separat.
Ambele sunt editoare foarte puternice, dar necesita un timp îndelungat pentru acomodare.

Este probabil mai bine să te concentrezi pe studiul Perl-ului momentan, iar mai încolo să înveți unul din aceste editoare.

Chiar dacă sunt editoare native în Linux/Unix, atât <b>Emacs</b> cât și <b>Vim</b>  sunt disponibile pe toate sistemele de operare importante.

## Editoare de Perl pentru Windows

Cele mai folosite editoare pentru Windows sunt:

* [Ultra Edit](http://www.ultraedit.com/) e un editor comercial
* [TextPad](http://www.textpad.com/) e shareware.
* [Notepad++](http://notepad-plus-plus.org/) e un editor open source și gratis. 

Folosesc mult <b>Notepad++</b> și îl am instalat pe calculatorul Windows deoarece poate fi foarte util.

## Mac OSX

Deși nu folosesc un Mac, umblă vorba-n sat cum că [TextMate](http://macromates.com/) este cel mai popular editor de Perl.

## IDE-uri de Perl

Niciunul din editoarele de mai sus nu este un IDE, adică, niciunul nu dispune de un debugger de Perl integrat.
De asemenea, niciunul nu dispune de ajutor integrat (help) specific limbajului.


[Komodo](http://www.activestate.com/) de la ActiveState costă câteva sute de dolari. Are o versiune gratis, dar cu capabilități limitate.

Cei care folosesc [Eclipse](http://www.eclipse.org/) trebuie să știe că există un plugin de Eclipse ce se cheamă EPIC.
De asemenea, există si [Perlipse](https://github.com/skorg/perlipse).

## Padre, the Perl IDE

În iulie 2008 am început să scriu un <b>IDE de Perl, în ... Perl</b>. L-am numit Padre (Perl Application Development and Refactoring Environment), de asemenea cunoscut și ca [Padre, the Perl IDE](http://padre.perlide.org/).

Proiectul a devenit popular și s-a alăturat multă lume. Este distribuit de versiunile majore de Linux și poate fi instalat de pe CPAN.
Vezi [pagina de download](http://padre.perlide.org/download.html) pentru detalii.

Nu este încă atât de puternic precum Eclipse sau Komodo din unele puncte de vedere, dar în câteva zone legate de Perl e deja mai bun decât cele două.
Mai mult de atât, este foarte activ dezvoltat.

Deci dacă ești în căutarea unui <b>editor de Perl </b> sau a unui <b>IDE pentru Perl</b>, iți recomand să-l încerci.

## Marele sondaj legat de editoarele de Perl

În Octombrie 2009 am făcut un sondaj în care am întrebat lumea ce editor de Perl folosește: [Which editor(s) or IDE(s) are you using for Perl development?](http://perlide.org/poll200910/)

Normal, poți face ce face toată lumea, să fii unic, sau să-ți alegi editorul cel mai potrivit ție.

## În continuare

Următoarea parte a tutorialului este legată de Perl în linia de comandă (doar în engleză deocamdată): [Perl on the command line](https://perlmaven.com/perl-on-the-command-line).

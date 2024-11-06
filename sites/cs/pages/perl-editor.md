---
title: "Perl Editor"
timestamp: 2013-09-16T06:45:56
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
translator: rampa
---


Perl skripty a programy v Perlu jsou jen textové soubory.
K jejich tvorbě můžete použít libovolný textový editor, neměli byste ale používat word procesory. Rád bych doporučil několik eidtorů a IDE.

Mimochodem, tento článek je součástí [Perl tutoriálu](/perl-tutorial).


## Editor nebo IDE?

Pro vývoj v Perlu můžete použít buď jednoduchý textový editor nebo <b>Integrované vývojové prostředí (Integrated Development Environment)</b>, přezdívané IDE.

Nejdříve popíšu textové editory, které můžete použít na nejběžnějších platformách, a pak IDE, která jsou zpravidla platformově nezávislá.

## Unix / Linux

Jestliže používáte Linux nebo Unix, nejběžnější používané editory jsou
[Vim](http://www.vim.org/) a
[Emacs](http://www.gnu.org/software/emacs/).
Oba vyznávají velmi rozdílnou filozofii, jak mezi sebou, tak ve srovnání s osatními editory.

Pokud jeden z nich znáte, není důvod jej nepoužít.

Pro každý z nich existují rozšíření nebo módy, které poskytují lepší podporu pro Perl. I bez nich jsou ale velmi dobré pro vývoj v Perlu.

Pokud žádný z těchto editorů neznáte, doporučuji oddělit učení se práci s editorem od učení se Perlu.

Oba tyto editory jsou velmi mocné, ale jejich ovládnutí vyžaduje dlouhou dobu.

Pravděpodobně je lepší se teď soustředit na studium Perlu, a až později se naučit práci s Vimem nebo Emacsem.

I když byly <b>Emacs</b> a <b>Vim</b> původně vyvíjeny pro Unix/Linux, jsou dnes k dispozici pro většinu ostatních operačních systémů.

## Perl editory pro Windows

Pod Windows jsou často používány tzv. "programátorské editory".

* [Ultra Edit](http://www.ultraedit.com/) je komerční produkt.
* [TextPad](http://www.textpad.com/) je share-ware.
* [Notepad++](http://notepad-plus-plus.org/) je open source a volně dostupný editor.

Používal jsem <b>Notepad++</b> často a protože je velmi užitečný, mám jej na svém Windows stroji stále k dispozici.

## Mac OSX

Nepoužívám Mac, ale zdá se, že [TextMate](http://macromates.com/) je nejčastěji používaný Mac editor pro vývoj v Perlu.

## Perl IDE

Žádný ze jmenovaných editorů není IDE, žádný z nich neposkytuje skutečný vestavěný debugger pro Perl. Také neposkytují nápovědu specifickou pro Perl.

[Komodo](http://www.activestate.com/) od ActiveState stojí pár set dolarů.
Má taky volnou verzi s omezenými možnostmi.

Ty, kteří už používají [Eclipse](http://www.eclipse.org/), bude zajímat, že existuje Perl plug-in pro Eclipse jménem EPIC. Také existuje projekt jménem
[Perlipse](https://github.com/skorg/perlipse).

## Padre, Perl IDE

V červenci 2008 jsem začal vyvíjet <b>IDE pro Perl v Perlu</b>. Nazval jsem jej Padre -
Perl Application Development and Refactoring Environment nebo-li
[Padre, the Perl IDE](http://padre.perlide.org/).

K projektu se připojilo hodně dalších lidí. Je součástí hlavních distribucí Linuxu a také může být nainstalován z CPANu. Pro detaily jdi na stránku [Stáhnout](http://padre.perlide.org/download.html).

V některých ohledech není ještě tak silný jako Eclipse nebo Komodo, ale v jiných, specifických pro Perl, je lepší než druhé dva.

Navíc se na něm velmi aktivně pracuje.
Jestli hledáte <b>Perl editor</b> nebo <b>Perl IDE</b>,
doporučuji jej vyzkoušet.

## Velké hlasování o Perl editoru

V říjnu 2009 jsem organizoval průzkum
[Který editor nebo IDE používáte pro vývoj v Perlu?](http://perlide.org/poll200910/)

Teď můžete jít s davem, proti němu, nebo si vybrat editor, který vám nejlépe vyhovuje.

## Ostatní

Alex Shatlovsky doporučil [Sublime Text](http://www.sublimetext.com/), který je nezávislý na platformě, ale stojí peníze.

## Další

Další částí tutoriálu je malá odbočka [Perl na příkazové řádce](/perl-na-prikazove-radce).



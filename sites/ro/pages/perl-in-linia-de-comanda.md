---
title: "Perl în linia de comandă"
timestamp: 2013-04-19T14:45:56
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
translator: stefansbv
---


Deși cea mai mare a [Tutorialului de Perl](/perl-tutorial)
este despre scripturi salvate în fișiere, vom vedea de asemenea câteva
exemple de utilizare în linia de comandă, așa numitele one-liners.

Chiar dacă folosești [Padre](http://padre.perlide.org/) sau
alt IDE care te lasă să rulezi scriptul direct din editor este foarte
importantă familiarizarea cu linia de comandă (sau shell) și să fii
în stare să folosești Perl astfel.


Dacă folosești Linux, deschide un terminal. Ar trebui să vezi un
prompter, care se termină probabil, cu caracterul $.

Dacă folosești Windows deschide o fereastră de comenzi: Clic pe

Start -> Run -> tastează "cmd" -> ENTER

Vei vedea fereastra neagră CMD cu un prompter care arată probabil astfel:

```
c:\>
```

## Versiunea Perl

Tastează `perl -v`. Acesta va printa ceva de genul acesta:

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

În baza aceasta, pot vedea că am instalată versiunea 5.12.3 de Perl pe
acest calculator cu Windows.


## Printarea unui număr

Tastați `perl -e "print 42"`.  Aceasta va printa
numărul `42` pe ecran. În Windows promptul va apărea pe linia
următoare:

```
c:>perl -e "print 42"
42
c:>
```

Pe Linux vei vedea ceva de genul acesta:

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

Rezultatul este la începutul rândului, urmat imediat de prompter.
Această diferență este legată de modul de comportare al interpretorul
de linie de comandă.

În acest exemplu voi folosi opțiunea `-e` care spune Perl-ului,
"Nu aștepta un fișier. Următorul lucru pe linia de comandă este cod
Perl".

Exemplele de mai sus nu sunt probabil prea interesante. Dați-mi voie
să vă arăt un exemplu ceva mai complex, fără să-l explic:

## Înlocuiește Java cu Perl

Această comandă: `perl -i.bak -p -e "s/\bJava\b/Perl/"
resume.txt` va înlocui toate aparițiile cuvântului <b>Java</b>
cu <b>Perl</b> în fișierul resume.txt și va păstra o copie a
originalului.

Pe Linux ai putea chiar să scrii astfel `perl -i.bak -p -e
"s/\bJava\b/Perl/" *.txt` ca să înlocuiești Java cu Perl în <b>toate</b>
fișierele tale text.

Într-o secțiune viitoare vom vorbi mai mult despre one-liners și vei
învăța cum să le folosești.  Este de ajuns să spunem, că aceste
cunoștințe pot fi unelte puternice la îndemâna ta.

Dacă tot veni vorba, dacă ești interesat de one-liners, îți recomand
să citești
<a href="http://www.catonmat.net/blog/perl-book/">Perl One-Liners
explained</a> de Peteris Krumins.

## Mai departe

Partea următoare este despre
<a href="https://perlmaven.com/core-perl-documentation-cpan-module-documentation">
documentația Perl și despre documentațiile modulelor CPAN</a>.

---
title: "Documentația Perl și documentația modulelor CPAN"
timestamp: 2013-04-20T17:45:55
tags:
  - perldoc
  - documentation
  - POD
  - CPAN
published: true
original: core-perl-documentation-cpan-module-documentation
books:
  - beginner
author: szabgab
translator: stefansbv
---


Perl vine cu multă documentație, dar durează puțin până să te
obișnuiești s-o folosești. În această parte
a [Tutorialului de Perl](/perl-tutorial) îți voi explica
cum să-ți găsești calea prin documentație.


## perldoc pe web

Cea mai convenabilă cale de a accesa documentația Perl este să
vizitezi situl [perldoc](http://perldoc.perl.org/).

Acesta conține o versiune HTML a documentației limbajului Perl, și a
modulellor care vin cu Perl așa cum sunt publicate de autori: Perl 5
Porters.

Nu conține documentația pentru modulele CPAN.  Există totuși o
suprapunere, există module care sunt disponibile pe CPAN dar sunt de
asemenea incluse în distribuția Perl standard.  (Aceste sunt de obicei
numite <b>dual-lifed</b> - în traducere, cu viață dublă.)

Poți folosi caseta de căutare din colțul din dreapta sus. De exemplu
poți tasta `split` și vei obține documentația funcției `split`.

Din păcate nu știe ce să facă dacă tastezi `while`, `$_`
sau `@_`.  Ca să obții explicații pentru acestea va trebui să
răsfoiești documentația.

Ce mai importantă pagină ar putea
fi [perlvar](http://perldoc.perl.org/perlvar.html), unde
poți găsi informații despre variabile ca `$_` și `@_`.

[perlsyn](http://perldoc.perl.org/perlsyn.html) explică
sintaxa Perl inclusiv cea pentru [while loop](https://perlmaven.com/while-loop).

## perldoc în linia de comandă

Aceeași documentație vine și cu codul sursă Perl, dar nu toate
distribuțiile Linux o instalează implicit.  În unele cazuri există un
pachet separat. De exemplu în Debian și Ubuntu este pachetul
<b>perl-doc</b>. Trebuie instalat folosind comanda `sudo aptitude
install perl-doc` înainte de a putea folosi
comanda `perldoc`.

Odată instalat, poți tasta `perldoc perl` în linia de comandă
și vei obține câteva explicații și o listă a capitolelor documentației
Perl.

Poți întrerupe folosind tasta `q`, iar după aceea poți tasta
numele unuia dintre capitole.  De exemplu: `perldoc perlsyn`.

Aceasta funcționează atât pe Linux cât și pe Windows dar utilitarul de
paginare din Windows este foarte slab, deci nu pot să-ți recomand să-l
folosești.  Pe Linux este folosit utilitarul de citit manuale deci ar
trebui să-ți fie deja familiar.

## Documentația modulelor CPAN

Fiecare modul pe CPAN vine cu documentație și cu exemple.  Calitatea
aceste documentații variază mult în funcție de autor și pe de altă
parte fiecare autor poate avea module foarte bine documentate și
module cu o documentație slabă.

După instalarea unui modul numit de exemplu Module::Name, poți să-i
accesezi documentația tastând `perldoc Module::Name`.

Există și o modalitate mai convenabilă totuși, care nu presupune ca
modulul să fie instalat. Sunt mai multe interfețe web pentru
CPAN. Cele principale sunt <a href="http://metacpan.org/">Meta
CPAN</a> și [search CPAN](http://search.cpan.org/).
Ambele se bazează pe aceeași documentație, dar furnizează o experiență
puțin diferită.


## Căutare după cuvinte cheie în Perl Maven

O funcție recent adăugată pe acest sit este căutarea după cuvinte
cheie de pe bara de meniu de la începutul paginii.  Încet încet vei
găsi explicații pentru, din ce în ce mai multe părți din, Perl.  La un
moment dat documenația limbajului Perl și documentația celor mai
importante module CPAN va fi de asemenea inclusă.

Dacă crezi că lipsește ceva de aici, adaugă un comentariu dedesubt, cu
cuvintele cheie pe care le-ai folosit și există șanse bune să ți se
îndeplinească dorința. (n.t. deocamdată numai pe pagina originală în
limba engleză).

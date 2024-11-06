---
title: "Instalează Perl în Windows, Linux și Mac"
timestamp: 2013-04-03T18:45:56
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
published: true
original: installing-perl-and-getting-started
books:
  - beginner
author: szabgab
translator: tudorconstantin
---


Aceasta este prima parte a [tutorialului de Perl](/perl-tutorial).

În această parte vei învăța cum să instalezi Perl pe Microsoft Windows precum și primii pași în folosirea limbajului de programare Perl în Windows, Linux și Mac.

Vei învăța să-ți setezi mediul de dezvoltare (development environment), sau, spus mai simplu: ce editor să folosești pentru a scrie cod Perl.

De asemenea vom vedea cum se implementează faimosul program "Hello World" în Perl.


## Windows

Pentru Windows vom folosi [DWIM Perl](http://dwimperl.szabgab.com/). Este un pachet care conține compilatorul/interpretorul de Perl,
[Padre, IDE-ul pentru Perl](http://padre.perlide.org/), precum și un număr de extensii din CPAN.

Pentru început, du-te la site-ul [DWIM Perl](http://dwimperl.szabgab.com/)
și dă click pe linkul de download cu titlul <b>DWIM Perl for Windows</b>.

Downloadează fișierul executabil și instalează-l la tine pe calculator. Înainte de asta, asigură-te că nu mai ai nici o versiune de Perl instalată.

Se pot configura să funcționeze împreună, dar ar necesita explicații suplimentare.
Deocamdată să rămânem la o singură versiune de Perl instalată pe calculator.

## Linux

Majoritatea distribuțiilor de Linux vin cu o versiune (relativ) recentă de Perl preinstalat.
Deocamdată vom folosi acea versiune. Pentru editor (IDE), poți instala Padre - majoritatea distribuțiilor de Linux îl oferă în sistemele de management de pachete. Altfel, poți alege orice editor de texte obișnuit.
Dacă ești obișnuit cu vim sau Emacs, folosește-l pe cel ce-ți place mai mult. Și Gedit poate fi un editor simplu și bun.


## Apple

Mac-urile vin probabil cu un Perl instalat, sau îl poți instala ca orice alt program standard de Mac.


## Editor şi IDE

Chiar dacă este recomandat, nu trebuie să folosești Padre ca editor pentru a scrie cod Perl.
În părțile următoare vei găsi o listă de [editoare și IDE-uri](/perl-editor-ide) pe care le poți folosi pentru a programa în Perl.
Chiar dacă alegi să folosești alte editoare, iți recomand - dacă ești pe Windows - să instalezi DWIM-ul mai sus menționat.
Vine la pachet cu o multitudine de extensii de Perl gata instalate și îți va salva o grămadă de timp pe parcurs.

## Video

În caz că preferi filmulețele, poți viziona ["Hello world"-ul în Perl](http://www.youtube.com/watch?v=c3qzmJsR2H0) pe Youtube (versiunea în limba engleză).
În cazul acesta, s-ar putea să ți se pară interesant și cursul de [Omnisciență în Perl](https://perlmaven.com/beginner-perl-maven-video-course) (de asemenea în limba engleza).

## Primul program

Primul tău program va arăta așa:

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

Explicațiile pas cu pas:

## Hello world

Odată ce ai instalat DWIM Perl, dă click pe "Start -> All programs -> DWIM Perl -> Padre" și ți se va deschide editorul cu un fișier gol.

Scrie în el:

```perl
print "Hello World\n";
```

După cum vezi, instrucțiunile în Perl se termină cu punct și virgulă `;`
`\n`-ul este semnul folosit pentru a reprezenta o linie nouă.
Stringurile sunt între ghilimele `"`.
Funcția `print` scrie pe ecran.
Când execuți acest program, va apărea pe ecran textul (Hello World - poți scrie orice acolo), la sfârșitul căruia va fi linia nouă.

Salvează fișierul ca hello.pl și apoi execută codul selectând "Run -> Run Script".
Vei vedea apărând o fereastră separată cu output-ul programului.

Atât, tocmai ai scris primul tău script în Perl.

Să-l îmbunătățim puțin.

## Perl în linia de comandă pentru utilizatorii care nu folosesc Padre

Dacă nu folosești Padre sau unul din celelalte [IDE-uri](/perl-editor-ide)
nu vei fi capabil să rulezi scriptul din editor. Cel puțin nu implicit.
Trebuie să deschizi o consolă și să schimbi directorul în locația unde ai salvat fișierul hello.pl
și să scrii:

`perl hello.pl`

Așa rulezi scripturile Perl din linia de comandă.

## say() in loc de print()

Să îmbunătățim one-liner-ul nostru puțin:

Să începem prin a specifica versiunea minimă de Perl pe care vrem să o folosim:

```perl
use 5.010;
print "Hello World\n";
```

Odată ce ai scris asta, rulează programul selectând "Run -> Run Script" sau apăsând <b>F5</b>.
Fișierul va fi salvat automat înainte să fie rulat.

În general este o bună practică menționarea versiunii minime de Perl pe care o necesită codul tău.

În acest caz sunt adăugate și câteva funcționalități noi Perl-ului, incluzând cuvântul cheie `say`.

`say` e ca `print`, dar este mai scurt și adaugă automat linia nouă la sfârșitul stringului.

Schimbă codul astfel:

```perl
use 5.010;
say "Hello World";
```

Am schimbat `print` cu `say` și am șters `\n`-ul de la sfârșitul stringului.

Versiunea pe care o folosești acum e, probabil, 5.12.3 sau 5.14. Cele mai moderne distribuții de Linux vin cu versiunea 5.10 sau mai nouă.
Din păcate, mai sunt locuri unde se folosesc versiuni mai vechi de Perl.

Acestea nu vor avea keyword-ul `say()` și s-ar putea să aibă nevoie de ajustări.
Voi scoate în evidență când folosim funcționalități care necesita versiunea 5.10

## Plasa de siguranță.

Este extrem de recomandat să aducem niște modificări comportamentului implicit al Perl-ului.
Pentru asta adăugăm două, așa numite pragmatas, care sunt foarte similare cu flag-urile de compilare în alte limbaje:


```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

În acest caz, keyword-ul `use` îi zice Perl-ului să încarce și să activeze fiecare pragma în parte.

`strict` și `warnings` te vor ajuta să preîntâmpini apariția de erori comune în cod și uneori te vor împiedica să le faci.
Sunt foarte la îndemână.

## Input-ul de la utilizator

Să îmbunătățim mai departe exemplul nostru întrebând userul ce nume are și să îl includem în răspuns.

```perl
use 5.010;
use strict;
use warnings;

say "Cum te cheama? ";
my $name = <STDIN>;
say "Salut $name, ce mai faci?";
```

`$name` este o variabilă de tip scalar.

Variabilele se declară folosind keyword-ul <b>my</b>.
(de fapt, asta e una din constrângerile pe care `strict` le aduce.)

Variabilele scalare întotdeauna încep cu semnul `$`

&lt;STDIN&gt; este instrumentul de citire a unei linii de la tastatura.

Scrie codul de mai sus și rulează-l apăsând F5.
Iți va cere numele. Scrie-ți numele și apasă ENTER pentru a spune Perl-ului că ți-ai terminat de scris numele.

Vei observa că outputul e puțin stricat: virgula de după nume apare pe linie nouă. Asta e din cauza că ENTER-ul apăsat când ți-ai scris numele a ajuns în variabila `$name`.

## Scăparea de liniile noi

```perl
use 5.010;
use strict;
use warnings;

say "Cum te cheama? ";
my $name = <STDIN>;
chomp $name;
say "Salut $name, ce mai faci?";
```

Fiind un lucru des întâlnit în Perl, este funcția speciala numită `chomp` care șterge liniile noi din stringuri.


## Concluzii

În fiecare script pe care-l scrii, trebuie <b>întotdeauna</b> să adaugi `use strict;` și `use warnings;` ca prime doua comenzi.
E de asemenea recomandat să adaugi `use 5.010;`.

## Exerciții

Am promis exerciții.

Rulează următorul script:

```perl
use strict;
use warnings;
use 5.010;

say "Salutare ";
say "lume buna";
```

Nu a apărut pe o singura linie. De ce? Cum faci textul să apară pe o singura linie?

## Exercițiul 2

Scrie un script care cere utilizatorului să introducă 2 numere, unul după celalalt și apoi afișează suma lor.

## Ce urmează?

Partea următoare a tutorialului este despre
[editoare, IDE-uri și mediul de dezvoltare în Perl](/perl-editor-ide).

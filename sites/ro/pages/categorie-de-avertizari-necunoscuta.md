---
title: "Categorie de avertizări necunoscută"
timestamp: 2013-12-14T10:35:56
tags:
  - ;
  - warnings
  - unknown warnings
published: true
original: unknown-warnings-category
books:
  - beginner
author: szabgab
translator: stefansbv
---


Nu cred că acesta este un mesaj de eroare forte des întâlnit în Perl.
Cel puțin eu nu-mi amintesc să-l fi întâlnit până acum, dar m-am
împiedicat de el recent în timpul unui curs de pregătire Perl.


## Categorie necunoscută de avertizări '1'

Mesajul de eroare complet arată astfel:

```
Unknown warnings category '1' at hello_world.pl line 4
BEGIN failed--compilation aborted at hello_world.pl line 4.
Hello World
```

Acestă eroare a fost foarte deranjantă, mai ales datorită simplității
codului:

```
use strict;
use warnings

print "Hello World";
```

M-am holbat la cod destul de mult și nu am observat nici o problemă cu el.
Așa cum poți vedea și tu, a tipărit șirul "Hello World".

M-a uimit și mi-a luat ceva timp să observ ceea ce tu probabil ai
observat deja:

Problema este caracterul punct și virgulă lipsă de după
comanda `use warnings`.  Perl a executat comanda "print", a
tipărit mesajul, iar funcția
`print` a returnat 1 indicând astfel că s-a încheiat cu succes.

Perl crede că am scris `use warnings 1`.

Sunt multe categorii de avertizare, dar nici una nu se numește "1".

## Categorie necunoscută de avertizări 'Foo'

Acesta este un alt caz al aceleași probleme.

Mesajul de eroare arată așa:

```
Unknown warnings category 'Foo' at hello.pl line 4
BEGIN failed--compilation aborted at hello.pl line 4.
```

iar codul dat ca exemplu arată felul în care lucrează interpolarea
șirurilor de caractere.  Aceasta este despre al doilea exemplu pe care
îl predau, chiar după "Hello World".

```perl
use strict;
use warnings

my $name = "Foo";
print "Hi $name\n";
```

## Lipsește caracterul punct și virgulă

Bineînțeles acestea sunt doar cazuri speciale ale unei probleme
generale acea de a omite caracterul punct și virgulă.  Perl poate
remarca acesta doar când întâlnește următoarea comandă.

Este în general o idee bună să verificăm linia dinainte de locația
menționată în mesajul de eroare.  Poate lipsește un caracter punct și
virgulă.

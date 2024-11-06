---
title: "Folosirea unei valori neinițializate"
timestamp: 2013-09-29T21:45:56
tags:
  - undef
  - uninitialized value
  - $|
  - warnings
  - buffering
published: true
original: use-of-uninitialized-value
books:
  - beginner
author: szabgab
translator: stefansbv
---


Acesta este una dintre cele mai comune avertizări (în lb. en:
warning) pe care le întâlnești când rulezi cod Perl.

Este doar o avertizare, nu va opri execuția programului și este
generată numai dacă avertizările sunt activate.  Ceea ce este
recomandat.

Cea mai uzuală cale de a activa avertizările este prin includerea unei
comenzi `use warnings;` la începutul scriptului sau al
modulului.


Calea mai veche metodă este prin adăugarea fanionului `-w` pe
linia "sh-bang".  În mod uzual acesta arată astfel:

`#!/usr/bin/perl -w`

Sunt şi câteva diferențe, dar cum `use warnings` este
disponibilă de 12 ani, nu sunt motive pentru a o evita. Cu alte
cuvinte:

Întotdeauna `use warnings;`!

Să ne întoarcem la mesajul de avertizare pe care am dorit să-l
explicăm.

## O explicație rapidă

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.
```

Acesta înseamnă că variabile `$x` nu are valoare (valoarea ei
este de fapt valoarea specială `undef`).

Adică nu a avut niciodată o valoare (alta decât undef), sau la un
moment dat a primit valoarea `undef`.

Ar trebui să examinezi liniile de cod unde variabila a primit ultima
dată o nouă valoare sau ar trebui să încerci să înțelegi de ce acea
bucățică de cod nu a mai ajuns să fie executată.

## Un exemplu simplu

Exemplul următor va genera o astfel de avertizare.

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
```

Perl este foarte amabil, îți spune care fișier a generat avertizarea
și la ce linie.

## Doar o avertizare


Așa cum am mai menționat, acesta este doar o avertizare. Dacă scriptul
are mai multe comenzi după cea cu `say`, acestea vor fi
executate:

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
$x = 42;
say $x;
```

Acesta va printa

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.

42
```

## Ordine derutantă

Atenție însă, dacă codul are comenzi de printare înainte de linia care
generează avertizarea, așa ca în exemplul următor:

```perl
use warnings;
use strict;
use 5.010;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

rezultatul poate fi derutant.

```
Use of uninitialized value $x in say at perl_warning_1.pl line 7.
OK
42
```

Aici, 'OK', rezultatul comenzii `print` este văzut <b>după</b>
mesajul de avertizare, chiar dacă comanda a fost
executată <b>înainte</b> de codul care a generat avertizarea.

Acestă ciudățenie este rezultatul a `IO buffering`. În mod
implicit Perl folosește o zonă de memorie tampon pentru STDOUT, ieșirea
standard, dar nu și pentru STDERR, ieșirea de eroare standard.

Adică, în timp ce cuvântul 'OK' așteaptă ca memoria tampon să fie
golită, mesajul de eroare ajunge deja pe ecran.

## Dezactivare memorie tampon

Pentru a evita acesta poți să dezactivezi memoria tampon pentru STDOUT.

Aceasta se face prin folosirea comenzii: `$| = 1;` la începutul
scriptului;


```perl
use warnings;
use strict;
use 5.010;

$| = 1;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

```
OKUse of uninitialized value $x in say at perl_warning_1.pl line 7.
42
```

(Avertizare este pe aceeași linie cu <b>OK</b> pentru că nu am printat
un caracter de linie nouă `\n` după OK.)

## Vizibilitate nedorită

```perl
use warnings;
use strict;
use 5.010;

my $x;
my $y = 1;

if ($y) {
  my $x = 42;
}
say $x;
```

Și acest cod produce `Use of uninitialized value $x in say at
perl_warning_1.pl line 11.`

Am reușit să fac acestă greșeală de mai multe ori.  Nu am fost atent
și am folosit `my $x` în interiorul blocului `if`, ceea
ce a însemnat că am creat o altă variabilă $x, i-am dat valoarea 42
doar pentru a lăsa-o apoi să iasă din zona de vizibilitate (en: out of
the scope) la sfârșitul blocului.

(Comanda $y = 1 este doar un substituent pentru cod real și pentru
condiții reale.  Este folosit numai pentru a face ca acest exemplu să
arate un pic mai realist.)

Sunt, bineînțeles, cazuri în care este nevoie să declar variabile în
interiorul unui bloc, dar nu întotdeauna.  Când se întâmplă din
greșeală, este greu de depistat eroarea.

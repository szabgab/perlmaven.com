---
title: "Simbolul global necesită un nume de pachet explicit"
timestamp: 2013-09-12T07:45:56
tags:
  - strict
  - my
  - package
  - global symbol
published: true
original: global-symbol-requires-explicit-package-name
books:
  - beginner
author: szabgab
translator: stefansbv
---


<b>Global symbol requires explicit package name</b> adică în limba
română: "simbolul global necesită un nume de pachet explicit", este un
mesaj de eroare comun, și după opinia mea unul foarte derutant al
interpretorului Perl.  Cel puțin pentru începători.

Sensul mesajului ar fi "Trebuie să declari o variabilă cu ajutorul
operatorului <b>my</b>."


## Cel mai simplu exemplu

```perl
use strict;
use warnings;

$x = 42;
```

Iar eroarea este

```
Global symbol "$x" requires explicit package name at ...
```

deși mesajul este corect, este puțin folositor programatorului Perl
începător.  Probabil ei nu au învățat încă ce sunt pachetele (n.t. en:
packages).  Și nici nu știu ce poate fi mai explicit decât $x ?

Această eroare este generată de <b>use strict</b>.

Explicația din documentație este:

<i>
Aceasta generează o eroare la compilare dacă accesezi o variabilă
care nu a fost declarată via "our" sau "use vars", localizată via
"my()", sau nu a fost calificată variabile (en: fully qualified).
</i>

Un începător, este de dorit să înceapă toate scripturile cu <b>use
strict</b>, și probabil va învăța despre <b>my</b> mult înainte de
celelalte variante.

Nu știu dacă acest mesaj de eroare poate fi, sau ar trebui să fie
schimbat în Perl.  Nu acesta este scopul acestui articol.  Scopul este
să ajutăm începătorii să înțeleagă, la nivelul lor, ce înseamnă de fapt
acest mesaj de eroare.

Pentru a elimina mesajul de eroare de mai sus trebuie să scriem:

```perl
use strict;
use warnings;

my $x = 42;
```

Adică, trebuie să <b>declarăm variabila folosind "my" înainte de prima utilizare.</b>.

## Soluția nerecomandată

Cealaltă "soluție" este este să ștergem <b>use strict</b>:

```perl
#use strict;
use warnings;

$x = 23;
```

Aceasta va funcționa, dar acest cod va genera o atenționare:
<a href="https://perlmaven.com/name-used-only-once-possible-typo">Name "main::x" used only
once: possible typo at ...</a>.

În orice caz, în mod normal nu v-ați conduce mașina fără centura de
siguranță, nu-i așa?

## Exemplul 2: scopul

Un alt caz des întâlnit arată cam așa:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
my $y = 2;
}

print $y;
```

Mesajul de eroare pe care-l primim este același ca mai sus:

```
Global symbol "$y" requires explicit package name at ...
```

Ceea ce este surpinzător pentru multă lume.  Mai ales când încep să scrie programe.  La urma urmelor au declarat `$y` folosind `my`.

Întâi de toate îți sare în ochi o problemă.  Indentarea lui `my $y
= 2;` lipsește.  Dacă ar fi fost indentat cu câteva spații sau cu
un Tab la dreapta, ca în exemplul următor, sursa problemei ar fi fost
evidentă:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
}

print $y;
```

Problema este că variabila `$y` este declarată în cadrul
blocului, (între perechea de acolade) ceea ce înseamnă că nu există în
afara acelui bloc.  Aceasta se
numește <a href="https://perlmaven.com/scope-of-variables-in-perl"><b>vizibilitatea</b>
variabilei</a> (n.t. en: <b>scope</b>).

Conceptul de <b>vizibilitate</b> diferă în funcție de limbajul de
programare.  În Perl, un bloc închis între acolade creează o
vizibilitate limitată.  Ceea ce este declarat înăuntru
folosind `my` nu va fi accesibil în afara blocului.

(Apropo `$x = 1` este folosit numai pentru a da o aparență de
legitimitate care creează o vizibilitate.  Cu alte cuvinte,
condiționarea `if ($x) {` este menită pentru a face ca exemplul
să arate realist.)

Soluția este, ori să punem `print` în interiorul blocului:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
    print $y;
}
```

ori declarăm variabila în afara blocului (și nu în interior!):

```perl
use strict;
use warnings;

my $x = 1;
my $y;

if ($x) {
    $y = 2;
}

print $y;
```

Care variantă o alegeți depinde de sarcina reală.  Acestea sunt doar
soluții posibile și corecte d.p.d.v. sintactic.

Bine înțeles, dacă uităm să ștergem `my` din interiorul
blocului, sau dacă `$x` este fals, atunci primim un mesaj de avertizare
[Use of uninitialized value](https://perlmaven.com/use-of-uninitialized-value)
(folosirea unei valori neinițializate).

## Celelalte căi

Explicațiile privind `our` și `use vars`, sau cum se pot
califica numele de variabile este subiectul altor articole.

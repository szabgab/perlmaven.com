---
title: "Cuvinte "goale" în Perl"
timestamp: 2013-12-14T10:45:56
tags:
  - bareword
  - strict
published: true
original: barewords-in-perl
books:
  - beginner
author: szabgab
translator: stefansbv
---


`use strict` are 3 părți.  Una dintre ele, numită și `use
strict "subs"`, previne utilizarea neadecvată a cuvintelor "goale"
(n.t.: adică a cuvintelor care nu sunt încadrate în
ghilimele) <b>barewords</b>.

Ce înseamnă asta?


Fără nici o restricție un astfel de cod ar rula și ar imprima "hello".

```perl
my $x = hello;
print "$x\n";    # hello
```

Aceasta este o chestiune ciudată, în sine, pentru că noi suntem
obișnuiți să punem cuvintele între ghilimele, dar Perl, implicit,
permite așa numitelor <b>barewords</b> să se comporte ca șiruri de
caractere.

Codul de mai sus ar imprima "hello".

Bine, cel puțin până când cineva ar adăuga o subrutină numită "hello"
la începutul scriptului:

```perl
sub hello {
  return "zzz";
}

my $x = hello;
print "$x\n";    # zzz
```

Da.  În această versiune Perl vede subrutina hello(), o execută și
atribuie valoarea returnată lui $x.

Apoi, dacă cineva mută subrutina la sfârșitul fișierului, după
atribuire, Perl pe neașteptate nu mai vede subrutina în momentul
atribuirii, deci obținem vechea ... de avea "hello" în $x.

Nu, nu vrei să intri într-o astfel de încurcătură accidental.  Sau
chiar mai probabil, niciodată.  Având `use strict` în cod, Perl
nu va permite acel cuvânt fără ghilimele: <b>hello</b> în codul tău,
evitând astfel acest tip de confuzie.

```perl
use strict;

my $x = hello;
print "$x\n";
```

Acesta va genera următoarea eroare:

```
Bareword "hello" not allowed while "strict subs" in use at script.pl line 3.
Execution of script.pl aborted due to compilation errors.
```

## Utilizarea corectă a cuvintelor fără ghilimele (barewords)

Sunt locuri în care utilizarea cuvintelor fără ghilimele (barewords)
este acceptată chiar dacă folosim `use strict "subs"`.

În primul rând, numele subrutinelor pe care le creăm
sunt <b>barewords</b>.  Acestea sunt folositoare.

De asemenea, atunci când facem referință la un element a
unui <b>hash</b> putem folosi <b>barewords</b> în interiorul
acoladelor și cuvintele din partea stângă a => (en: fat arrow) pot fi
lăsate fără ghilimele:

```perl
use strict;
use warnings;

my %h = ( name => 'Foo' );

print $h{name}, "\n";
```

În ambele cazuri, în codul de mai sus, "name" este un cuvânt fără
ghilimele adică <b>bareword</b>, dar acestea sunt permise chiar
dacă este utilizat <b>use strict</b>.

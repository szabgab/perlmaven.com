---
title: "Avizare (warn) când ceva este în neregulă"
timestamp: 2013-07-09T16:01:01
tags:
  - warn
  - STDERR
published: true
original: warn
books:
  - beginner
author: szabgab
translator: stefansbv
---


În momentul în care ceva este în neregulă în script/program/aplicație,
este uzual să avizezi utilizatorul despre problemă.  În scripturile
pentru linia de comandă acesta se face în mod normal prin printarea
unui mesaj de avertizare
la [Ieșirea de Eroare Standard](https://perlmaven.com/stdout-stderr-and-redirection).


Așa cum a fost explicat în articolul
despre <a href="https://perlmaven.com/stdout-stderr-and-redirection">standard output and
error</a>, în Perl se poate face prin direcționarea printării
către `STDERR`

```perl
print STDERR "Slight problem here...\n";
```

Există însă o cale mai bună, standard, poate fi apelată
funcția `warn` (avizare, avertizare):

```perl
warn "Slight problem here.\n";
```

Este mai scurtă, mai expresivă și în forma de mai sus are același efect.

În ambele cazuri scriptul, după ce printează mesajul de avizare, va
continua să ruleze!

Totuși are mai multe facilități.  Dacă omiți caracterul linie nouă (new-line)
(adică `\n` de la sfârșit):

```perl
warn "Slight problem here.";
```

atunci rezultatul va include numele fișierului și numărul liniei,
de unde a fost apelată funcția `warn`:

```
Slight problem here. at programming.pl line 5.
```

Acesta poate fi foarte utilă atunci când ai un script care apelează multe alte
scripturi, sau când ai o aplicație mai mare cu mai multe module.

Acesta va ușura găsirea sursei problemei pentru tine sau pentru
utilizatorul programului.

## Capturarea avizărilor

Încă și mai mult.

Perl a introdus un așa numit <b>signal-handle</b> special pentru avizări.
Acesta înseamnă că tu, sau altcineva, poate adăuga mai târziu cod în
program care să
<a href="https://perlmaven.com/how-to-capture-and-save-warnings-in-perl">captureze toate
avizările</a>.  Acesta este un subiect puțin mai avansat totuși, dar
dacă ești interesat, mergi mai departe și citește acea pagină.

## Avertizare

O mică avertizare aici. Pot fi întâlnite cazuri în care o avizare
apelată după o comandă de printare apare înaintea conținutului
comenzii de printare.

Acest cod:

```perl
print "before";
warn "Slight porblem here.\n";
print STDERR "More problems.\n";
print "after";
```

generează acestă ieșire:

```
Slight porblem here.
More problems.
beforeafter
```

Unde cuvântul "before" apare după ambele mesaje de avizare.

În acest caz, citește despre [folosirea memoriei tampon (buffering)](https://perlmaven.com/stdout-stderr-and-redirection#buffering).

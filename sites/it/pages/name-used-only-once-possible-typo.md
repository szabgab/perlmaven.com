---
title: "Name "main::x" used only once: possible typo at ..."
timestamp: 2013-06-02T12:00:00
tags:
  - warning
  - strict
  - possible typo
published: true
original: name-used-only-once-possible-typo
books:
  - beginner
author: szabgab
translator: giatorta
---


Se vedete questo warning in uno script Perl siete in guai seri.


## Assegnamento a una variabile

Assegnare un valore a una variabile e poi non usarla
o usare una variabile una sola volta senza assegnarle alcun valore
sono difficilmente delle azioni corrette.

Probabilmente, l'unico caso "legittimo" è quello in cui avete commesso un errore di battitura
(in Inglese: "typo") che spiega il perché avete usato quella variabile una sola volta.

In questo codice d'esempio facciamo <b>solo un assegnamento a una variable</b>:

```perl
use warnings;

$x = 42;
```

Viene generato un warning del tipo:

```
Name "main::x" used only once: possible typo at ...
```

Il prefisso "main::" e la mancanza del sigillo $ potrebbero causarvi confusione.
La presenza del prefisso "main::" è dovuta al fatto che per default
ogni variabile in Perl appartiene al namespace "main". Inoltre, ci possono
essere diverse entità chiamate "main::x" e solo una di esse
è preceduta dal simbolo $. Se tutto questo suona strano, non preoccupatevi.
È davvero strano, ma per fortuna non avrete bisogno di occuparvene per un bel po' di tempo.

## Accesso al valore

Se invece <b>usate una variable una sola volta</b>

```perl
use warnings;

print $x;
```

probabilmente riceverete due warning:

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

Uno di essi è oggetto della nostra discussione, mentre l'altro è discusso in
[Use of uninitialized value](/use-of-uninitialized-value).


## Che cosa c'entreno i typo?

Potreste chiedervi.

Immaginate che qualcuno usi una variabile `$l1` nel codice. Quando
tocca a voi lavorare su quel codice volete usare la stessa variabile ma scrivete `$ll`.
In base al vostro font, i due nomi potrebbero avere un aspetto molto simile.

Oppure potrebbe esserci una variabile `$color` ma voi potreste essere Inglese
e digitare automaticamente `$colour` ogni volta che vi volete riferire a quella variabile.

Oppure c'è una variabile `$number_of_misstakes` ma non vi accorgete
dell'errore di battitura nel suo nome e scrivete `$number_of_mistakes`.

Dovreste esservi fatti un'idea.

Se siete fortunati commettete l' errore una sola volta, ma se non lo siete e
usate (almeno) due volte la variabile sbagliata il warning non verrà generato.
Dopo tutto, se state usando lo stesso nome due volte probabilmente avrete le vostre buone ragioni.

Come potete evitare tutto questo?

Anzitutto, evitate quando possibile l'uso di lettere ambigue nei nomi di variabili e fate
molta attenzione quando li digitate.

Ma se volete davvero risolvere il problema, dovete ricorrere a <b>use strict</b>!

## use strict

Come avrete notato, negli esempi precedenti non ho usato strict. Se lo avessi usato,
invece di ricevere un warning a proposito di un errore di battitura, avrei ricevuto un errore di
compilazione:
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name).

Questo errore viene generato anche quando si usa più di una volta la variabile sbagliata.

E naturalmente qualcuno sarà tentato di correre ai ripari e aggiungere "my" davanti alla variabile
sbagliata, ma voi non siete quel tipo di persone, giusto? Voi preferite pensare al problema e cercare finché
non trovate il vero nome della variabile.

La situazione più comune in cui vedrete questo warning è proprio quando non usate strict.

E allora siete in guai seri.

## Casi in cui usate strict

Come hanno fatto notare GlitchMr e un altro commentatore anonimo, ci sono alcuni altri casi:

Anche questo codice genera il warning

```perl
use strict;
use warnings;

$main::x = 23;
```

Il warning dice: <b>Name "main::x" used only once: possible typo ...</b>

Questa volta almeno è chiaro da dove venga quel 'main' o, nel
prossimo esempio, il 'Mister'. (suggerimento. è il nome del package di cui
si lamentava l'[errore sui nomi di package](/global-symbol-requires-explicit-package-name).)
Nel prossimo esempio, il nome del package è 'Mister'.

```perl
use strict;
use warnings;

$Mister::x = 23;
```

Il warning dice <b>Name "Mister::x" used only once: possible typo ...</b>.

Anche l'esempio che segue genera il warning, per ben due volte:

```perl
use strict;
use warnings;

use List::Util qw/reduce/;
print reduce { $a * $b } 1..6;
```

```
Name "main::a" used only once: possible typo at ...
Name "main::b" used only once: possible typo at ...
```

Questo succede perché `$a` e `$b` sono
variabili speciali usate nella funzione nativa sort e
quindi non è necessario dichiararle, ma in questo codice
vengono usate una volta sola.
(A dire il vero non mi è chiaro perché questo codice generi i warning,
mentre lo stesso codice con <b>sort</b> non lo fa, ma i
[Perl Monks](http://www.perlmonks.org/?node_id=1021888) potrebbero saperlo.



---
title: "undef, il valore iniziale e la funzione defined in Perl"
timestamp: 2013-05-02T10:45:56
tags:
  - undef
  - defined
published: true
original: undef-and-defined-in-perl
books:
  - beginner
author: szabgab
translator: paologianrossi
---


In alcuni linguaggi c'è un modo specifico per dire "questo campo non ha un valore".
In <b>SQL</b>, <b>PHP</b> e <b>Java</b> questo valore è `NULL`. In <b>Python</b> è `None`.
In <b>Ruby</b> si chiama `Nil`.

In Perl questo valore è `undef`.

Vediamo alcuni dettagli.


## Da dove viene undef?

Quando dichiari una variabile scalare senza assegnarvi un valore, il suo contenuto sarà il valore ben definito `undef`.

```perl
my $x;
```

Alcune funzioni restituiscono `undef` per indicare
fallimento. Altre possono ritornare undef se non hanno nulla di
sensato da restituire.

```perl
my $x = do_something();
```

Si può usare la funzione `undef()` per resettare il valore di una variabile ad `undef`:

```perl
# some code
undef $x;
```

Si può anche utilizzare il valore di ritorno della
funzione `undef()` per settare una variabile ad `undef`:

```perl
$x = undef;
```

Le parentesi dopo il nome della funzione sono opzionali e le ho
tralasciate nell'esempio.

Come si può vedere, ci sono diversi modi per far valere <b>undef</b> una variabile scalare.
La domanda successiva è: cosa succede se usi una variabile del genere?

Prima di pensarci, vediamo qualcos'altro:

## Come verificare se il valore di una variabile è undef?

La funzione `defined()`
restituisce [vero](/boolean-values-in-perl) se il valore
passato <b>non è undef</b>. Restituirà
invece [falso](/boolean-values-in-perl) se il valore
passato è <b>undef</b>.

Può essere usata in questo modo:

```perl
use strict;
use warnings;
use 5.010;

my $x;

# some code here that might set $x

if (defined $x) {
    say '$x is defined';
} else {
    say '$x is undef';
}
```


## Qual è il vero valore di undef?

Anche se <b>undef</b> indica l'assenza di valore, non è utilizzabile
come valore di per sé. Perl fornisce due default utilizzabili invece
di undef.

Se si usa una variabile che è undef in un'operazione numerica, viene considerata 0.

Se la si usa in un'operazione tra stringhe, viene considerata come la stringa vuota.

Si veda il seguente esempio:

```perl
use strict;
use warnings;
use 5.010;

my $x;
say $x + 4, ;  # 4
say 'Foo' . $x . 'Bar' ;  # FooBar

$x++;
say $x; # 1
```

Nell'esempio sopra, la variabile $x - che è undef per default - si
comporta come uno zero nella somma (+), come la stringa vuota nella
concatenazione (.) e di nuovo come 0 nell'operazione di autoincremento
(++).

Comunque, non filerà tutto liscio. Se si sono richiesti i warnings,
attraverso il pragma `use warnings`
(<a href="https://perlmaven.com/installing-perl-and-getting-started">cosa sempre
raccomandata</a>), si otterranno due warning di
tipo <a href="/use-of-uninitialized-value">use of unitialized
value</a> per le prime due operazioni, ma non per l'autoincremento:

```
Use of uninitialized value $x in addition (+) at ... line 6.
Use of uninitialized value $x in concatenation (.) or string at ... line 7.
```

Penso che non ci sia un warning per l'autoincremento perché perl
perdona. Nel seguito vedremo che questo è comodo nelle situazioni in
cui si voglia contare qualcosa.

Ovviamente, si possono evitare i warning inizializzando la variabile
al valore corretto (0 o la stringa vuota, a seconda della necessità),
o disabilitando selettivamente i warning. Vedremo quest'opzione in un
articolo diverso.

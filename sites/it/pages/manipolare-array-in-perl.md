---
title: "Manipolare gli array in Perl: shift, unshift, push e pop"
timestamp: 2013-05-02T09:45:56
tags:
  - array
  - shift
  - unshift
  - push
  - pop
published: true
original: manipulating-perl-arrays
books:
  - beginner
author: szabgab
translator: paologianrossi
---


Oltre a permettere l'accesso diretto a singoli elementi di un array,
Perl fornisce altri interessanti modi per interagire con tali
strutture dati. In particolare, esistono funzioni che rendono molto
efficiente l'uso di un array in Perl per implementare una coda o uno
stack.


## pop

La funzione `pop` rimuove e restituisce l'ultimo elemento di un array.

In questo primo esempio, dato un array di tre elementi, la
funzione `pop` rimuove l'ultimo elemento (l'elemento con indice
massimo) e lo restituisce.

```perl
my @names = ('Foo', 'Bar', 'Baz');
my $last_one = pop @names;

print "$last_one\n";  # Baz
print "@names\n";     # Foo Bar
```

Nel caso particolare in cui l'array di origine fosse vuoto, la
funzione `pop`
ritornerà [undef](https://perlmaven.com/undef-and-defined-in-perl).

## push

La funzione `push` aggiunge uno o più elementi in coda ad un
array. (Beh, in realtà può anche aggiungere zero elementi, ma non
sembra una cosa molto utile di per sé).

```perl
my @names = ('Foo', 'Bar');
push @names, 'Moo';
print "@names\n";     # Foo Bar Moo

my @others = ('Darth', 'Vader');
push @names, @others;
print "@names\n";     # Foo Bar Moo Darth Vader
```

In questo esempio, partiamo da un array di due
elementi. Attaverso `push` "spingiamo" un singolo scalare in
coda al nostro array, che viene esteso così a tre valori.

Con la seconda chiamata a `push`, abbiamo spinto il contenuto
dell'array `@others` in coda all'array `@names`,
cosicché quest'ultimo è ora un array di cinque elementi.

## shift

La funzione `shift` trasla l'intero array verso sinistra, se
assumiamo l'array cominciare dal lato sinistro e crescere verso
destra.  L'elemento che era al primo posto nell'array "cade giù"
dall'array e diventa il valore di ritorno della funzione. (Se l'array
è vuoto, <b>shift</b>
restituisce [undef](/undef-and-defined-in-perl)).

Al termine dell'operazione, l'array sarà più corto di un elemento.

```perl
my @names = ('Foo', 'Bar', 'Moo');
my $first = shift @names;
print "$first\n";     # Foo
print "@names\n";     # Bar Moo
```

Questo è analogo a `pop`, ma funziona dal lato minore dell'array.

## unshift

La funzione `unshift` è l'operazione inversa di `shift`:
prende uno o più valori (o nessun valore, se ci tieni) e lo inserisce
all'inizio dell'array, spostando gli elementi preesistenti verso
destra.

Gli argomenti di `unshift` possono essere un singolo scalare,
nel qual caso quel valore diventerà il primo elemento dell'array; o,
come si vede nel secondo esempio, un secondo array. In questo caso,
gli elementi del secondo array (`@others` nel nostro caso)
saranno copiati in testa al primo array (`@names` nel nostro
caso), spostando gli alti elementi in posizioni maggiori.

```perl
my @names = ('Foo', 'Bar');
unshift @names, 'Moo';
print "@names\n";     # Moo Foo Bar

my @others = ('Darth', 'Vader');
unshift @names, @others;
print "@names\n";     # Darth Vader Moo Foo Bar
```

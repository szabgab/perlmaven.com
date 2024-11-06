---
title: "Indovina un Numero"
timestamp: 2013-09-28T16:00:00
tags:
  - rand
  - casuale
  - int
  - intero
published: true
original: number-guessing-game
books:
  - beginner
author: szabgab
translator: giatorta
---


In questo episodio del [tutorial Perl](/perl-tutorial) inizieremo a
creare un gioco semplice ma divertente.
È stato il primo gioco che ho scritto quando ero alle scuole superiori, prima ancora che fosse rilasciato Perl 1.0.


Per scrivere questo gioco abbiamo bisogno di introdurre due semplici argomenti tra loro indipendenti:
<b>Come generare numeri casuali in Perl</b> e
<b>Come ottenere la parte intera di un numero</b>.

## Parte intera di un numero frazionario

La funzione `int()` restituisce la parte intera del suo parametro:

```perl
use strict;
use warnings;
use 5.010;

my $x = int 3.14;
say $x;          # stampa 3

my $z = int 3;
say $z;          # stampa di nuovo 3.

                 # Perfino questo stampa 3.
my $w = int 3.99999;
say $w;

say int -3.14;   # stampa -3
```

## Numeri casuali

Una chiamata alla funzione Perl `rand($n)` restituisce un numero frazionario casuale
tra 0 e $n. Incluso 0 ed escluso $n.

Se `$n = 42`, la chiamata a `rand($n)` restituisce un numero casuale tra 0 e 42.
Incluso 0 ed escluso 42. Per esempio può essere 11.264624821095826 .

Se non le passiamo alcun valore, di default `rand()` restituisce valori tra 0 e 1, incluso 0
ed escluso 1.

Combinando `rand` e `int` possiamo generare numeri interi casuali:

```perl
use strict;
use warnings;
use 5.010;

my $z = int rand 6;
say $z;
```

Questo codice restituisce un numero tra 0 e 6. Incluso 0 ed escluso 6. Quindi può
essere uno qualunque dei seguenti numeri: 0,1,2,3,4,5.

Se aggiungiamo 1 al risultato otteniamo uno qualunque dei numeri 1,2,3,4,5,6 proprio come se avessimo lanciato un dado.

## Esercizio: Indovina il Numero

Iniziamo la scrittura di un gioco che completeremo più avanti. Un piccolo gioco che però è divertente.

Create uno script in cui, usando la funzione `rand()`, il computer "pensa" 
un numero intero tra 1 e 200. L'utente deve indovinare il numero.

Dopo che l'utente ha tentato con un valore, il computer gli dice se tale valore è
più grande o più piccolo del numero generato.

A questo punto <b>non</b> è necessario permettere all'utente di fare altri tentativi.
Ci arriveremo in un prossimo episodio. Ma naturalmente non voglio impedirvi
di studiare il [loop while](https://perlmaven.com/while-loop)
in Perl, potete leggerlo e poi permettere all'utente di fare più di un tentativo.






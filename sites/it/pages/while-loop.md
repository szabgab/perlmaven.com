---
title: "while loop"
timestamp: 2013-10-07T14:00:00
tags:
  - while
  - while (1)
  - ciclo
  - ciclo infinito
  - last
published: true
original: while-loop
books:
  - beginner
author: szabgab
translator: giatorta
---


In questo episodio del [tutorial Perl](/perl-tutorial) vedremo <b>come funziona il ciclo while in Perl</b>.


```perl
use strict;
use warnings;
use 5.010;

my $counter = 10;

while ($counter > 0) {
  say $counter;
  $counter -= 2;
}
say 'fatto';
```

Il ciclo `while` ha una condizione, nel nostro esempio il controllo se la variabile $counter è maggiore di 0,
e un blocco di codice tra parentesi graffe.

Quando l'esecuzione arriva per la prima volta all'inzio del ciclo while controlla se la condizione è [vera o falsa](/boolean-values-in-perl). Se è `FALSA` il blocco viene ignorato e viene eseguita l'istruzione successiva, nel nostro caso la stampa di 'fatto'.

Se la condizione del `while` è `VERA`, il blocco viene eseguito e si ritorna alla
condizione per valutarla di nuovo. Se è falsa il blocco viene ignorato e si stampa 'fatto'.
Se è vera il blocco viene eseguito e si torna alla condizione ...

Si va avanti così fintanto che la condizione è vera, ovvero, in Italo-Inglese:

`while (la-condizione-è-vera) { fai-qualcosa }`

## Cicli infiniti

Nel codice qui sopra la variabile veniva sempre decrementata e quindi eravamo certi che prima o poi la condizione sarebbe diventata falsa.
Se, per qualche ragione, la condizione non diventa mai falsa avete creato un `ciclo infinito`. Il vostro programma resterà bloccato in un
piccolo blocco dal quale non potrà mai uscire.

Per esempio, se avessimo dimenticato di decrementare `$counter` oppure se lo avessimo incrementato
pur avendo, nella condizione, un controllo su un limite inferiore.

Se questo succede per errore, allora è certamente un bug.

D'altra parte, in alcuni casi l'uso <b>volontario</b> di un ciclo infinito può rendere il vostro programma più facile da scrivere e
da leggere. E a noi piace molto il codice leggibile!
Se vogliamo creare un ciclo infinito è sufficiente specificare una condizione sempre vera.

Possiamo quindi scrivere:

```perl
while (42) {
  # fai qualcosa
}
```

Naturalmente le persone prive dei
[riferimenti culturali opportuni](http://en.wikipedia.org/wiki/Answer_to_Life,_the_Universe,_and_Everything#Answer_to_the_Ultimate_Question_of_Life.2C_the_Universe.2C_and_Everything_.2842.29)
si chiederanno perché abbiamo scelto 42, quindi lo stile generalmente accettato, anche se un po' ripetitivo, è quello di specificare sempre il numero 1 nei cicli infiniti.

```perl
while (1) {
  # fai qualcosa
}
```

Vedendo che il codice non può uscire da questo ciclo, viene naturale chiedersi come possa terminare l'intero programma a meno che venga interrotto dall'esterno.

In realtà, ci sono alcuni modi perché termini senza intervento esterno.

Uno di essi consiste nel chiamare l'istruzione `last` nel ciclo while.
Il suo effetto è di ignorare il resto del blocco e non tornare più a controllare la condizione,
terminando di fatto il ciclo. Spesso viene usato all'interno di qualche condizione.

```perl
use strict;
use warnings;
use 5.010;

while (1) {
  print "Quale linguaggio di programmazione stai imparando in questo momento? ";
  my $name = <STDIN>;
  chomp $name;
  if ($name eq 'Perl') {
    last;
  }
  say 'Sbagliato! Riprova!';
}
say 'fatto';
```

In questo esempio facciamo una domanda all'utente e speriamo che lui/lei sappia rispondere correttamente. Se non sarà capace di rispondere 'Perl' rimarrà nel ciclo a tentare per sempre di rispondere alla domanda.

La conversazione potrebbe svolgersi come segue:

```
Quale linguaggio di programmazione stai imparando in questo momento?
>  Java
Sbagliato! Riprova!
Quale linguaggio di programmazione stai imparando in questo momento?
>  PHP
Sbagliato! Riprova!
Quale linguaggio di programmazione stai imparando in questo momento?
>  Perl
fatto
```

Come vedete, quando l'utente digita la risposta corretta viene chiamata `last`, il resto del blocco
(incluso `say 'Sbagliato! Riprova!';`) viene saltato e l'esecuzione continua dopo il
`ciclo while`.



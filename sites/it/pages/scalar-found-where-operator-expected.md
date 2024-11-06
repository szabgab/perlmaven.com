---
title: "Scalar found where operator expected"
timestamp: 2013-06-16T06:00:00
tags:
  - errore di sintassi
  - scalar found
  - operator expected
published: true
original: scalar-found-where-operator-expected
books:
  - beginner
author: szabgab
translator: giatorta
---



Questo errore si vede davvero molto spesso ed è un po' difficile da capire.

Il fatto è che molte persone pensano agli <b>operatori numerici</b> e agli <b>operatori stringa</b>,
ma non pensano alla virgola `,` come a un operatore. Per loro, la terminologia del
messaggio di errore è un po' confusa.

Vediamo un paio di esempi:


## Virgola mancante

Il codice è il seguente:

```perl
use strict;
use warnings;

print 42 "\n";
my $name = "Foo";
```

e il messaggio d'errore è

```
String found where operator expected at ex.pl line 4, near "42 "\n""
      (Missing operator before  "\n"?)
syntax error at ex.pl line 4, near "42 "\n""
Execution of ex.pl aborted due to compilation errors.
```

Dice chiaramente dove si trova il problema, ma mi capita spesso di vedere persone che si affrettano
a tornare all'editor e a provare a risolvere il bug prima ancora di leggere il messaggio d'errore.
Fanno qualche modifica sperando che risolverà il problema e finiscono per ricevere
di nuovo il messaggio d'errore.

In questo caso il problema è che abbiamo dimenticato di aggiungere una virgola `,` dopo il numero 42.
La linea corretta sarebbe `print 42, "\n";`.


## String found where operator expected

In questo codice abbiamo dimenticato l' operatore di concatenazione `.`, e riceviamo lo stesso messaggio d'errore:

```perl
use strict;
use warnings;

my $name = "Foo"  "Bar";
```

```
String found where operator expected at ex.pl line 4, near ""Foo"  "Bar""
      (Missing operator before   "Bar"?)
syntax error at ex.pl line 54, near ""Foo"  "Bar""
Execution of ex.pl aborted due to compilation errors.
```

Il codice corretto sarebbe: `my $name = "Foo" . "Bar";`.

## Number found where operator expected

```perl
use strict;
use warnings;

my $x = 23;
my $z =  $x 19;
```

Genera questo messaggio d'errore:

```
Number found where operator expected at ex.pl line 5, near "$x 19"
  (Missing operator before 19?)
syntax error at ex.pl line 5, near "$x 19"
Execution of ex.pl aborted due to compilation errors.
```

In questo codice probabilmente mance un operatore di addizione `+` o di moltiplicazione `*`,
ma potrebbe anche trattarsi di un operatore di ripetizione `x`.

## Errore di sintassi per la mancanza di una virgola

La mancanza di una virgola non viene sempre riconosciuta come mancanza di un operatore.
Per esempio questo codice:

```perl
use strict;
use warnings;

my %h = (
  foo => 23
  bar => 19
);
```

genera il seguente messaggio d'errore: <b>syntax error at ... line ..., near "bar"</b>
senza ulteriori dettagli.

Aggiungendo una virgola dopo il numero 23 si risolve il problema:

```perl
my %h = (
  foo => 23,
  bar => 19
);
```

Personalmente preferisco aggiungere una virgola dopo ogni coppia in un hash (in questo caso, anche dopo il numero 19):

```perl
my %h = (
  foo => 23,
  bar => 19,
);
```

Questa abitudine mi aiuta a evitare gli errori di sintassi come quello qui sopra in quasi tutti i casi.


## Scalar found where operator expected at

```perl
use strict;
use warnings;

my $x = 23;
my $y = 19;

my $z =  $x $y;
```

```
Scalar found where operator expected at ... line 7, near "$x $y"
    (Missing operator before $y?)
syntax error at ... line 7, near "$x $y"
Execution of ... aborted due to compilation errors.
```

Di nuovo, può esserci un operatore numerico o stringa tra $x e $y.

## Array found where operator expected

```perl
use strict;
use warnings;

my @x = (23);
my $z =  3 @x;
```

## Quali altri casi vi capita spesso di incontrare?

Conoscete altri casi interessanti in cui viene generato questo tipo di errore di sintassi?



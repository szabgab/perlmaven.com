---
title: "Unknown warnings category"
timestamp: 2013-06-08T14:00:00
tags:
  - ;
  - warning
  - unknown warnings
published: true
original: unknown-warnings-category
books:
  - beginner
author: szabgab
translator: giatorta
---


Non credo che questo messaggio d'errore sia molto comune in Perl.
O, quanto meno, non ricordo di averlo visto prima di inciamparci durante una
lezione di Perl che ho tenuto recentemente.


## Unknown warnings category '1'

Il messaggio d'errore completo era qualcosa come:

```
Unknown warnings category '1' at hello_world.pl line 4
BEGIN failed--compilation aborted at hello_world.pl line 4.
Hello World
```

Un messaggio piuttosto inquietante, specialmente perché il codice era davvero semplicissimo:

```
use strict;
use warnings

print "Hello World";
```

Ho passato un bel po' di tempo a guardare il codice senza trovare alcun problema.
Tra l'altro, come vedete, la stringa "Hello World" veniva stampata correttamente.

Sono rimasto spiazzato, e mi ci è voluto un certo tempo per accorgermi di ciò che probabilmente avete già notato:

Il problema è che manca il punto e virgola dopo l'istruzione
`use warnings`. Perl esegue l'istruzione print,
la stringa viene stampata e la funzione `print` restituisce 1
per indicare che ha avuto successo.

Perl crede che io abbia scritto `use warnings 1`.

Ci sono molte categorie di warning, ma nessuna do loro si chiama "1".

## Unknown warnings category 'Foo'

Ecco un altro caso dello stesso problema.

Il messaggio d'errore è il seguente:

```
Unknown warnings category 'Foo' at hello.pl line 4
BEGIN failed--compilation aborted at hello.pl line 4.
```

e il codice di esempio illustra il funzionamento dell'interpolazione di stringhe.
Questo è solitamente il secondo esempio che faccio, subito dopo "Hello World".

```perl
use strict;
use warnings

my $name = "Foo";
print "Hi $name\n";
```

## Manca il punto e virgola

Naturalmente, quelli discussi sopra sono semplicemente casi speciali del
problema più generale di dimenticare un punto e virgola. Perl se ne accorge soltanto
all'istruzione succesiva.

Può essere una buona idea, in generale, controllare la linea precedente
a quella indicata nel messaggio d'errore.
Potrebbe mancare il punto e virgola.


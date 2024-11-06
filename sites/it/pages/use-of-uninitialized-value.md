---
title: "Use of uninitialized value"
timestamp: 2013-05-15T07:45:56
tags:
  - undef
  - uninitialized value
  - $|
  - warning
  - buffering
published: true
original: use-of-uninitialized-value
books:
  - beginner
author: szabgab
translator: giatorta
---


Questo warning è uno dei più comuni tra quelli che incontrerete eseguendo del codice Perl.

Essendo un warning, non impedisce l'esecuzione del vostro script e viene generato solo se
i warning sono stati attivati, cosa che vi raccomando di fare.

Il modo più comune di attivare i warning è quello di includiere un'istruzione `use warnings;`
all'inizio del vostro script o modulo.


Il vecchio modo era invece quello di aggiungere un'opzione `-w` sulla cosiddetta linea sh-bang, ovvero la prima
linea del vostro script contenente l'invocazione di perl:

`#!/usr/bin/perl -w`

Ci sono alcune differenze, ma siccome `use warnings` è ormai disponibile da 12 anni,
non c'è alcuna ragione per non usarlo. In altre parole:

Usate sempre `use warnings;`!


Torniamo al warning che volevo spiegare.

## Una spiegazione veloce

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.
```

Il senso del messaggio è che la variabile `$x` non ha un valore (o meglio, ha il valore speciale `undef`).
Potrebbe non avere mai avuto un valore o averlo avuto prima che, ad un certo punto, le sia stato assegnato `undef`.

Dovreste cercare il punto dove è stato fatto l'ultimo assegnamento alla variabile
oppure cercare di capire perché un certo pezzo di codice non è stato eseguito.

## Un semplice esempio

L'esempio seguente genera quel tipo di warning.

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
```

Perl è così gentile da dirci quale file ha generato il warning e a quale linea.

## È solo un warning

Come ho già detto, questo è solo un warning. Se lo script ha altre istruzioni dopo l'istruzione
`say`, tali istruzioni verranno eseguite:

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
$x = 42;
say $x;
```

Questo codice stampa

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.

42
```

## Output in ordine sparso

Attenzione però che, se il vostro codice ha stampato qualcosa prima della linea
dove viene generato il warning, come in questo esempio:

```perl
use warnings;
use strict;
use 5.010;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

il risultato potrebbe essere un po' strano.

```
Use of uninitialized value $x in say at perl_warning_1.pl line 7.
OK
42
```

Come vedete, il risultato della `print` appare <b>dopo</b>
il warning, anche se essa è stata eseguita <b>prima</b> del
codice che ha generato il warning.

Questa anomalia è causata dal `buffering dell'IO`.
DI default Perl applica il buffering a STDOUT, il canale standard di output,
mentre non lo applica a STDERR, il canale standard per i messaggi di errore.

Quindi, mentre la parola 'OK' è in attesa che il buffer venga svuotato,
il messaggio di warning viene emesso sullo schermo.

## Disattivare il buffering

Se volete evitare questo comportamento potete disattivare il buffering su STDOUT.

A questo scopo dovete aggiungere il seguente codice: `$| = 1;`
all'inizio dello script.


```perl
use warnings;
use strict;
use 5.010;

$| = 1;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

```
OKUse of uninitialized value $x in say at perl_warning_1.pl line 7.
42
```

(Il warning è sulla stessa linea di <b>OK</b> perché non abbiamo emesso un carattere di a capo
`\n` dopo OK.)

## Lo scope indesiderato

```perl
use warnings;
use strict;
use 5.010;

my $x;
my $y = 1;

if ($y) {
  my $x = 42;
}
say $x;
```

Anche questo codice genera `Use of uninitialized value $x in say at perl_warning_1.pl line 11.`

Mi è successo molte volte di commettere questo errore. Ho inserito distrattamente `my $x`
dentro al blocco `if`, creando un'altra variabile $x e
assegnandole il valore 42 senza accorgermi che sarebbe uscita dal proprio scope alla fine del blocco.
(L'assegnamento $y = 1 sta al posto di un vero pezzo di codice e di una vera condizione.
Serve solo a rendere questo esempio un po' più realistico.)

Ovviamente in alcuni casi dichiaro la variabile nel blocco if perché è necessario, ma in altri casi no.
E nei casi in cui la dichiaro per errore è difficile trovare il bug.





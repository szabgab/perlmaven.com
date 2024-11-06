---
title: "Variabili Scalari"
timestamp: 2013-08-17T20:00:00
tags:
  - strict
  - my
  - undef
  - say
  - +
  - x
  - .
  - sigilli
  - $
  - "@"
  - "%"
  - warning FATAL
published: true
original: scalar-variables
books:
  - beginner
author: szabgab
translator: giatorta
---


In questa parte del [Tutorial Perl](/perl-tutorial) daremo
un'occhiata a quali sono le strutture dati disponibili in Perl e a come potete usarle.

In Perl 5 ci sono tre strutture dati di base. <b>Scalari, array e hash</b>. Questi ultimi sono anche
noti come dizionari, tabelle di look-up o array associativi in altri linguaggi.


In Perl le variabili sono sempre precedute da un simbolo chiamato <b>sigillo</b>. Questi simboli sono `$` per gli scalari,
`@` per gli array e `%` per gli hash.

Uno scalare può contenere un valore singolo come un numero o una stringa. Può anche contenere un
riferimento a un'altra struttura dati come vedremo più avanti.

Il nome di uno scalare inizia sempre con un `$` (carattere dollaro) seguito da lettere, numeri e underscore.
Un nome di variabile può essere `$nome` o `$nome_lungo_e_descrittivo`. Può anche essere
`$NomeLungoEDescrittivo` che viene solitamente detto "CamelCase" ("stile a cammello", NdT),
ma la comunità Perl preferisce in genere nomi di variabili tutti minuscoli con gli underscore a separare le parole contenute nel nome.

Dato che usiamo sempre <b>strict</b>, dobbiamo sempre dichiarare le nostre variabili con <b>my</b>.
(Più avanti discuteremo anche di <b>our</b> e di altri modi, ma per ora atteniamoci alle dichiarazioni <b>my</b>.)
Possiamo assegnare immediatamente un valore come in questo esempio:

```perl
use strict;
use warnings;
use 5.010;

my $name = "Pippo";
say $name;
```

oppure dichiarare prima la variabile e poi assignarle un valore:

```perl
use strict;
use warnings;
use 5.010;

my $name;

$name = "Pippo";
say $name;
```

Quando la logica del codice lo permette, preferisco il primo approccio.

Se abbiamo dichiarato una variabile ma non le abbiamo ancora assegnato un valore essa ha
il valore speciale [undef](/undef-e-defined-in-perl) che è simile al <b>NULL</b> nei database,
ma si comporta in modo leggermente diverso.

Possiamo testare se una variabile è o non è `undef` usando la funzione `defined`:

```perl
use strict;
use warnings;
use 5.010;

my $name;

if (defined $name) {
  say 'definito';
} else {
  say 'NON definito';
}

$name = "Pippo";

if (defined $name) {
  say 'definito';
} else {
  say 'NON definito';
}

say $name;
```

Possiamo settare una variabile scalare a `undef` assignandole `undef`:

```perl
$name = undef;
```

Le variabili scalari possono contenere sia numeri che stringhe. Quindi è possibile scrivere:

```perl
use strict;
use warnings;
use 5.010;

my $x = "ciao";
say $x;

$x = 42;
say $x;
```

ed eseguirlo senza problemi.

Come si integra questo con gli operatori e l'overloading di operatori in Perl?

In generale Perl si comporta in modo opposto agli altri linguaggi. Invece di essere gli operandi ad indicare
all'operatore come deve comportarsi, è l'operatore a indicare agli operandi come devono comportarsi.

Pertanto, se ho due variabili contenenti dei numeri sarà l'operatore a decidere se devono
comportarsi effettivamente come numeri o invece come stringhe:

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = 4;
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

`+`, l'operatore di addizione numerica, somma due numeri, quindi `$y` e `$z` si comportano come numeri.

`.` concatena due stringhe, quindi `$y` e `$z` si comportano come stringhe. (In altri linguaggi potreste chiamarla una addizione di stringhe.)

`x`, l'operatore di ripetizione, ripete la stringa alla sua sinistra un numero di volte uguale al numero alla sua destra,
quindi in questo caso `$z` si comporta come una stringa w `$y` come un numero.

I risultati sarebbero gli stessi anche se entrambe le variabili fossero state create come stringhe:

```perl
use strict;
use warnings;
use 5.010;

my $z = "2";
say $z;             # 2
my $y = "4";
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

e anche se una di esse fosse stata creata come numero e l'altra come stringa:

```perl
use strict;
use warnings;
use 5.010;

my $z = 7;
say $z;             # 7
my $y = "4";
say $y;             # 4

say $z + $y;        # 11
say $z . $y;        # 74
say $z x $y;        # 7777
```

Perl converte automaticamente i numeri in stringhe e le stringhe in numeri
in base alle aspettative dell'operatore.

Si parla di <b>contesti</b> numerici e stringa.

I casi descritti sopra erano facili. Quando si converte un numero in una stringa è come se lo
si racchiudesse tra doppi apici. Quando si converte una stringa in un numero ci sono casi semplici come
quelli che abbiamo visto, in cui la stringa contiene soltanto cifre. Lo stesso vale
se c'è un punto decimale nella stringa, come in `"3.14"`.
Il problema è: che cosa succede se la stringa contiene caratteri che non fanno parte di un numero? Per es. `"3.14 e' pi"`.
Come si comporterebbe in un'operazione numerica (ovvero in un contesto numerico)?

Anche questo è semplice, ma forse ha bisogno di qualche spiegazione.

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = "3.14 e' pi";
say $y;             # 3.14 e' pi

say $z + $y;        # 5.14
say $z . $y;        # 23.14 e' pi
say $z x $y;        # 222
```

Quando una stringa si trova in un contesto numerico Perl considera la parte sinistra della stringa
e tenta di convertirla in un numero. Tutta la parte che può essere convertita in numero diventa il
valore numerico della variabile. In contesto numerico (`+`) la stringa
`"3.14 e' pi"` diventa il numero `3.14`.

In qualche modo ciò è completamente arbitrario, ma è il comportamento di perl e quindi lo accettiamo come tale.

Il codice sopra genera anche un warning sul canale standard di errore (`STDERR`):

```
Argument "3.14 e' pi" isn't numeric in addition(+) at example.pl line 10.
```

assumendo che abbiate attivato <b>use warnings</b> come vi suggerisco caldamente.
Usarlo vi aiuta ad accorgervi quando qualcosa non è esattamente come dovrebbe.
Spero che ora il risultato di `$x + $y` sia chiaro.

## Retroscena

Notate che perl non ha convertito `$y` in 3.14. Ha semplicemente usato quel valore
numerico nell'addizione.
Questo dovrebbe spiegare anche il risultato di `$z . $y`.
In quel caso perl usa il valore stringa originale.

Potreste essere sorpresi che `$z x $y` generi 222 mentre a destra c'è 3.14,
ma apparentemente perl può solo ripetere una stringa un numero intero di volte... Durante l'operazione
perl ha arrotondato automaticamente il numero a destra. (Se proprio vi piace spremervi
il cervello, potete notare che il contesto "numerico" menzionato prima consiste in
svariati sotto-contesti, uno dei quali è il contesto "intero". Quasi sempre perl fa ciò
che sembrerebbe "la cosa giusta" alla maggior parte delle persone che non programmano.)

Inoltre non viene generato il warning di conversione
"partial string to number" che abbiamo visto nel caso del `+`.

Ciò non è dovuto a differenze tra gli operatori. Se commentiamo l'addizione
il warning verrà generato per questa operazione. Il motivo dell'omissione di un secondo warning
è che quando perl genera il valore numerico della stringa `"3.14 e' pi"` lo
memorizza anche in una tasca segreta della variabile `$y`. In questo modo `$y`
contiene sia un valore stringa che un valore numerico, e usa quello appropriato in ogni
nuova operazione evitando la conversione.

Ci sono altre tre cose che vorrei discutere. Una è il comportamento di una variabile con valore
`undef`, un'altra sono i <b>warning fatali</b> e la terza è come evitare
la conversione automatica da stringa a numero.

## undef

Se una variabile contiene `undef`, ovvero "nulla" come direbbero molti, può comunque essere usata.
In contesto numerico si comporta come se avesse valore 0 mentre in contesto stringa si comporta come la stringa vuota:

```perl
use strict;
use warnings;
use 5.010;

my $z = 3;
say $z;        # 3
my $y;

say $z + $y;   # 3
say $z . $y;   # 3

if (defined $y) {
  say "definita";
} else {
  say "NO";          # NO
}
```

Con l'emissione di due warning:

```
Use of uninitialized value $y in addition (+) at example.pl line 9.

Use of uninitialized value $y in concatenation (.) or string at example.pl line 10.
```

Come vedete la variabile è ancora `undef` alla fine e quindi l'istruzione condizionale
stampa "NO".

## Warning fatali

Alcuni preferiscono che l'applicazione lanci una vera e propria
eccezione invece di un semplice warning. Se è ciò che volete, potete modificare così l'inizio dello script

```perl
use warnings FATAL => "all";
```

Con questa modifica, lo script stamperà il numero 3 e poi solleverà un'eccezione:

```
Use of uninitialized value $y in addition (+) at example.pl line 9.
```

È lo stesso messaggio del primo warning, ma adesso lo script si ferma.
(a meno che, naturalmente, l'eccezione venga catturata, ma ne parleremo un'altra volta.)

## Evitare la conversione automatica da stringa a numero

Se volete evitare la conversione automatica di una stringa quando non può essere convertita completamente,
potete controllare se la stringa ha l'aspetto di un numero quando la ricevete dal mondo esterno.

A questo scopo dobbiamo caricare il modulo [Scalar::Util](https://metacpan.org/pod/Scalar::Util),
e usare la subroutine `looks_like_number` che esso fornisce.

```perl
use strict;
use warnings FATAL => "all";
use 5.010;

use Scalar::Util qw(looks_like_number);

my $z = 3;
say $z;
my $y = "3.14";

if (looks_like_number($z) and looks_like_number($y)) {
  say $z + $y;
}

say $z . $y;

if (defined $y) {
  say "definito";
} else {
  say "NO";
}
```


## overloading di operatori

Infine, è possibile fare l'overloading degli operatori, nel qual caso
gli operandi determinano ciò che fanno gli operatori, ma per ora è meglio
rimandare questo argomento avanzato.



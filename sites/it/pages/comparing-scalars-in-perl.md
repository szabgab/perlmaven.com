---
title: "Confronto tra scalari in Perl"
timestamp: 2013-08-20T18:00:00
tags:
  - eq
  - ne
  - lt
  - gt
  - le
  - ge
  - ==
  - "!="
  - "<"
  - ">"
  - "<="
  - ">="
published: true
original: comparing-scalars-in-perl
books:
  - beginner
author: szabgab
translator: giatorta
---


Nella parte precedente del [tutorial Perl](/perl-tutorial)
abbiamo introdotto le [variabili scalari](/scalar-variables) e abbiamo visto come i numeri
e le stringhe vengano convertiti al volo gli uni negli altri. Abbiamo anche
dato un'occhiata a un'istruzione condizionale <b>if</b> ma non abbiamo ancora discusso il
confronto tra due scalari. Di questo argomento ci occupiamo ora.


Date due variabili $x e $y come facciamo a confrontarle?
I valori 1, 1.0 e 1.00 sono tutti uguali? E "1.00" ?
È più grade "pippo" o "pluto"?

## Due insiemi di operatori di confronto

Perl ha due insiemi di operatori di confronto. Come abbiamo visto per
gli operatori binari di somma (+), concatenazione (.) e ripetizione (x)
anche qui l'operatore determina come si comportano gli operandi e
come vengono confrontati.

I due insiemi di operatori sono i seguenti:

```
Numerico   Stringa         Significato
==            eq           uguale
!=            ne           non uguale
<             lt           minore di
>             gt           maggiore di
<=            le           minore o uguale
>=            ge           maggiore o uguale
```

Gli operatori a sinistra confrontano i valori come numeri mentre
gli operatori a destra (colonna centrale) confrontano i
valori in base al codice ASCII o alla localizzazione corrente.

Vediamo alcuni esempi:

```perl
use strict;
use warnings;
use 5.010;

if ( 12.0 == 12 ) {
  say "VERO";
} else {
  say "FALSO";
}
```

In questo semplice caso Perl stamperà VERO dato che l'operatore `==` confronta due
numeri e a Perl non importa se il numero è scritto come un intero o come un
numero a virgola mobile.

Un caso più interessante è il seguente confronto

```
"12.0" == 12
```

che è anch'esso VERO dato che l'operatore `==` di Perl converte la stringa in un numero.

```
 2  < 3  è VERO perché < confronta due numeri.

 2  lt 3 è anch'esso VERO dato che 2 precede 3 nella tabella dei codici ASCII

12 > 3  è ovviamente VERO

12 gt 3 restituisce FALSO
```

A prima vista potrebbe essere sorprendete per qualcuno ma, se ci pensate un momento, 
Perl confronta due stringhe carattere per carattere. Quindi confronta "1" con "3"
e, dato che sono diversi e "1" precede "3" nella tabella dei codici ASCII, Perl decide
che, come stringa, 12 è minore di 3.

Fate attenzione a confrontare due cose nel modo giusto!

```
"foo"  == "bar" sarà VERO
```

Verranno anche generati due warning se(!) li avete attivati con `use warnings`.
I warning sono dovuti al fatto che state usando due stringhe come numeri nel confronto numerico ==.
Come spiegato in una parte precedente Perl esamina le parti sinistre delle due stringhe e le converte in numeri per
quanto possibile. Dato che entrambe le stringhe iniziano con una lettera vengono convertite in 0.
0 == 0 ed è per questo che il confronto è vero.

D'altra parte, invece:

```
"foo"  eq "bar"  FALSO
```

Quindi, di nuovo: fate attenzione a confrontare due cose nel modo giusto!

Lo stesso succede quando confrontate

```
"foo"  == "" sarà VERO
```

e

```
"foo"  eq "" sarà FALSO
```


Vedere i risultati di questa tabella potrebbe esservi utile:

```
 12.0   == 12    VERO
"12.0"  == 12    VERO
"12.0"  eq 12    FALSO
  2     <   3    VERO
  2    lt   3    VERO
 12     >   3    VERO
 12    gt   3    FALSO ! (attenzione, potrebbe non essere immediatamente ovvio)
"foo"  ==  ""    VERO  ! (ricevete dei warning se usate la direttiva "warnings")
"foo"  eq  ""    FALSO
"foo"  == "bar"  VERO  ! (ricevete dei warning se usate la direttiva "warnings")
"foo"  eq "bar"  FALSO
```

Infine un esempio di trappola in cui è possibile cadere quando ricevete dell'input da un
utente e, dopo aver accuratamente rimosso il carattere di a capo dalla fine, controllate se la
stringa data è vuota.

```perl
use strict;
use warnings;
use 5.010;

print "input: ";
my $name = <STDIN>;
chomp $name;

if ( $name == "" ) {   # sbagliato! qui dovete usare eq invece di ==!
  say "VERO";
} else {
  say "FALSO";
}
```

Se eseguite questo script e inserite "abc" otterrete che è VERO,
come se perl pensasse che "abc" sia la stessa cosa della stringa vuota


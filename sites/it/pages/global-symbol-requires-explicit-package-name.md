---
title: "Global symbol requires explicit package name"
timestamp: 2013-05-11T06:01:01
tags:
  - strict
  - my
  - package
  - simbolo globale
published: true
original: global-symbol-requires-explicit-package-name
books:
  - beginner
author: szabgab
translator: giatorta
---


Il messaggio d'errore <b>Global symbol requires explicit package name</b> (in Italiano: "Il simbolo globale richiede un nome di package esplicito")
è molto comune in Perl ma, a mio parere, anche fuorviante. Almeno per i principianti.

Una interpretazione approssimativa del significato del messaggio è la seguente: "Dovete dichiarare la variabile usando <b>my</b>."


## L'esempio più semplice

```perl
use strict;
use warnings;

$x = 42;
```

E l'errore è

```
Global symbol "$x" requires explicit package name at ...
```

Anche se il messaggio d'errore è corretto,
risulta poco utile per il programmatore Perl principiante.
Lui/lei, infatti, probabilmente non sa ancora che cosa siano i package, né
che cosa posa essere più esplicito di $x.

L'errore è generato dalla direttiva <b>use strict</b>.

La spiegazione contenuta nella documentazione è la seguente:

<i>
Viene generato un errore di compilazione se accedete a una variabile che non sia stata
dichiarata con "our" o "use vars", localizzata con "my()" oppure il cui nome non sia stato qualificato.
</i>

Un principiante dovrebbe già avere l'abitudine di iniziare sempre i propri script con <b>use strict</b>,
e avrà probabilmente imparato ad usare <b>my</b> molto prima delle altre possibilità menzionate nella documentazione.

Non sono sicuro se la cosa più giusta da fare non sarebbe quella di cambiare il testo dell'errore dentro perl. Non è questo comunque lo
scopo del presente articolo. Il suo scopo è quello di aiutare i principianti a capire il significato del messaggio di errore 
in termini a loro comprensibili.

Per sbarazzarsi dal messaggio d'errore occorre scrivere:

```perl
use strict;
use warnings;

my $x = 42;
```

Ovvero, occorre <b>dichiarare la variabile con my prima di usarla.</b>.

## La cattiva strada

L'altra "soluzione" è quella di rimuovere <b>strict</b>:

```perl
#use strict;
use warnings;

$x = 23;
```

che funziona, anche se genera un warning
[Name "main::x" used only once: possible typo at ...](https://perlmaven.com/name-used-only-once-possible-typo) (in Italiano: Nome "main::x" usato una volta sola: possibile errore di battitura ...).

In ogni caso, normalmente non guidereste l'auto senza la cintura di sicurezza, vero?

## Esempio 2: scope

Un altro errore comune tra i principianti è il seguente:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
my $y = 2;
}

print $y;
```

Il messaggio che riceviamo è lo stesso di prima:

```
Global symbol "$y" requires explicit package name at ...
```

che per molte persone può essere sorprendente. Specialmente se hanno appena iniziato a programmare.
Dopo tutto, la variabile `$y` è stata dichiarata con `my`.

Anzitutto, c'è un piccolo problema visuale. Manca infatti l'indentazione di `my $y = 2;`.
Se ci fosse un'indentazione di alcuni spazi o di un tab a destra, come nel prossimo esempio,
la causa del problema potrebbe essere più evidente:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
}

print $y;
```

Il problema è che la variabile `$y` è dichiarata dentro un blocco
(delimitato dalle parentesi graffe) il che implica che essa non esiste al di fuori di quel blocco.
In particolare, il blocco rappresenta <a href="https://perlmaven.com/scope-of-variables-in-perl">lo <b>scope</b> della variabile</a>.

Il concetto di <b>scope</b> varia da un linguaggio di programmazione ad un altro.
In Perl, un blocco racchiuso tra parentesi graffe genera uno scope.
Le variabili dichiarate nel blocco con `my` non sono accessibili al di fuori del blocco.

(tra l'altro, l'istruzione `$x = 1` è stata aggiunta solo per dare un senso alla condizione che crea lo scope.
In altre parole, la condizione `if ($x) {` serve a rendere l'esempio più realistico.)

La soluzione consiste nel chiamare `print` dentro al blocco:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
    print $y;
}
```

oppure nel dichiarare la variabile al di fuori del blocco (e non all'interno!):

```perl
use strict;
use warnings;

my $x = 1;
my $y;

if ($x) {
    $y = 2;
}

print $y;
```

Quale delle due soluzioni sia giusto applicare varia da caso a caso. Quelle che abbiamo illustrato sono semplicemente le soluzioni corrette da un punto di vista sintattico.

Naturalmente, se dimenticate di rimuovere il `my` nel blocco o se `$x` è falso,
riceverete un warning [Use of uninitialized value](https://perlmaven.com/use-of-uninitialized-value).

## Le alternative

La spiegazione di ciò che fanno `our` e `use vars` o di come si possa
qualificare il nome di una variabile è lasciata ad un altro articolo.


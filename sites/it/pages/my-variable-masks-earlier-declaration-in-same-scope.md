---
title: ""my" variable masks earlier declaration in same scope"
timestamp: 2013-06-23T18:00:01
tags:
  - my
  - scope
published: true
original: my-variable-masks-earlier-declaration-in-same-scope
books:
  - beginner
author: szabgab
translator: giatorta
---


Questo warning viene generato durante la compilazione se, per errore, tentate di dichiarare
due volte la stessa variabile nello stesso scope.

```
"my" variable ... masks earlier declaration in same scope at ... line ...
```

Che senso ha e perché invece ri-dichiarare delle variabili in ogni iterazione di un ciclo funziona?

Se non posso scrivere `my $x` due volte nello stesso scope, come faccio a resettare la variabile?


Vediamo la differenza tra i seguenti casi:

## Semplice script

```perl
use strict;
use warnings;

my $x = 'this';
my $z = rand();
my $x = 'that';
print "OK\n";
```

In questo caso ricevo il seguente warning durante la compilazione:

```
"my" variable $x masks earlier declaration in same scope at ... line 7. )
```

Trattandosi di un warning, l'esecuzione dello script stampa comunque anche "OK".


## Blocco in un'istruzione condizionale

```perl
use strict;
use warnings;

my $z = 1;
if (1) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

Questo genera il seguente warning:

```
"my" variable $x masks earlier declaration in same scope at ... line 7.
```

In entrambi i casi abbiamo dichiarato `$x` due volte nello stesso scope,
per cui è stato generato un warning durante la compilazione.

Nel secondo esempio dichiariamo anche `$z` due volte, ma non viene
generato alcun warning. Ciò è dovuto al fatto che la `$z` nel blocco
è in uno [scope](https://perlmaven.com/scope-of-variables-in-perl) diverso.

## Scope di una funzione

Un po' di codice dentro una funzione:

```perl
use strict;
use warnings;

sub f {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
f(1);
f(2);
```

Anche in questo caso durante la compilazione ricevete una sola volta il warning per la variabile `$x`.
Anche se la variabile `$z` viene creata ripetutamente,
una volta per ogni chiamata alla funzione,
questo non crea problemi. La variabile `$z` non genera warning:
Perl può creare due volte la stessa variabile, siete voi che non potete farlo.
Almeno non nello stesso scope.

## Scope di un ciclo for

Stesso codice, ma in un ciclo:

```perl
use strict;
use warnings;

for (1 .. 10) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

Anche questo genera un warning per `$x` una sola volta(!) e non genera
alcun warning per `$z`.

In questo codice la stessa cosa viene ripetuta ad <b>ogni</b> iterazione:
Perl alloca la memoria per la variabile `$z` ad ogni iterazione.

## Che cosa significa "my"?

Il significato di `my $x` è quello di dire a perl, e in particolare a `strict`,
che volete usare una variabile privata <b>$x</b> nello [scope corrente](https://perlmaven.com/scope-of-variables-in-perl).
In mancanza di ciò, perl cerca una dichiarazione negli scope superiori e se
non riesce a trovarla genera un errore di compilazione
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)
Ogni ingresso in un blocco, ogni chiamata a una funzione, ogni iterazione in un loop è un nuovo mondo.

D'altra parte, se scrivete `my $x` due volte nello stesso scope significa che state cercando di dire a Perl
la stessa cosa due volte. Non è necessario e in genere indica che c'è un errore da qualche parte.

In altre parole, il warning che riceviamo è dovuto alla <b>compilazione</b> del codice e non alla sua esecuzione.
È legato alla dichiarazione della variabile da parte dello sviluppatore e non alle allocazioni di memoria
fatte da perl durante l'esecuzione.

## Come si resetta una variable?

Se non possiamo scrivere `my $x;` due volte nello stesso scope, come facciamo a resettarne il valore?

Anzitutto, se una variabile è dichiarata in uno scope, ovvero tra parentesi graffe, verrà automaticamente distrutta
non appena l'esecuzione esce dallo [scope](https://perlmaven.com/scope-of-variables-in-perl).

Se volete resettare una variabile scalare nello scope corrente, assegnatele il valore `undef`
mentre se è un [array o un hash](https://perlmaven.com/undef-on-perl-arrays-and-hashes), assegnatele una lista vuota:

```perl
$x = undef;
@a = ();
%h = ();
```

Per riassumere: "my" dice a perl che volete usare una variabile.
Quando Perl esegue il codice dove c'è la variabile "my" alloca la memoria per la variabile e il suo contenuto.
Quando Perl esegue `$x = undef;`  oppure  `@x = ();`  oppure  `undef @x;` rimuove
il contenuto della variabile.



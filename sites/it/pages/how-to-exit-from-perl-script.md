---
title: "Come uscire da uno script Perl"
timestamp: 2013-10-30T15:00:00
tags:
  - exit
  - "$?"
  - ">>"
published: true
original: how-to-exit-from-perl-script
books:
  - beginner
author: szabgab
translator: giatorta
---


Se state seguendo il [Tutorial Perl](/perl-tutorial), finora tutti gli script terminavano quando
l'esecuzione giungeva all'ultima riga di codice nel vostro file.

Ci sono però dei casi in cui volete terminare prima l'esecuzione.

Per esempio, chiedete agli utenti la loro età, e se hanno meno di 13 anni terminate lo script.


```perl
use strict;
use warnings;
use 5.010;

print "Quanti anni hai? ";
my $age = <STDIN>;
if ($age < 13) {
    print "Sei troppo giovane\n";
    exit;
}

print "Fai qualcosa ...\n";
```

Una semplice chiamata a `exit`.

## Il codice di uscita

Se avete usato la shell Unix/Linux saprete che ogni programma,
quando termina, restituisce un codice di uscita memorizzato nella variabile `$?`.
Potete fornire questo valore di uscita anche da uno script perl, passando un numero alla
funzione `exit()`.


```perl
use strict;
use warnings;
use 5.010;

exit 42;
```

Per esempio, qui impostiamo il codice di uscita a 42. (Il default è 0.)

## Successo o fallimento?

In Perl, di solito, 0 e [undef](/undef-and-defined-in-perl) rappresentano un fallimento,
mentre altri [valori "vero"](/boolean-values-in-perl) rappresentano successo.

Nel mondo della shell Unix/Linux, 0 rappresenta successo e gli altri numeri fallimento.
Tipicamente, ogni applicazione ha il proprio insieme di valori che indicano le diverse condizioni di errore.


## Controllare il codice di uscita in Linux

In un ambiente Unix/Linux potete eseguire lo script con `perl script.pl` e poi
esaminare il codice di uscita con `echo $?`.


## Controllare il codice di uscita in Perl

Se vi capita di eseguire uno script perl da un altro script perl, usando per
esempio la funzione [system](https://perlmaven.com/running-external-programs-from-perl), 
Perl ha la stessa variabile `$?` contenente il code di uscita dell'"altro programma".

Se avete il codice sopra salvato in un file script.pl e avete un altro script "executor.pl" come questo:


```perl
use strict;
use warnings;
use 5.010;

say system "perl script.pl";
say $?;
say $? >> 8;
```

L'output sarà:

```
10752
10752
42
```

La chiamata a `system` restituisce il codice di uscita, che viene anche memorizzato nella variabile
Perl `$?`. È importante notare che tale valore contiene 2 byte e l'effettivo
codice di uscita è il byte più significativo. Quindi, per ottenere il valore 42 di sopra dovete fare uno shift a destra dei
bit usando l'operatore bit-a-bit `&gt;&gt;` su 8 bit. Tutto ciò è illustrato nell'ultima
riga dell'esempio qui sopra.

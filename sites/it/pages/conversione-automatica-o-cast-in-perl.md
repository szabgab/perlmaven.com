---
title: "Conversione automatica da stringa a numero in Perl"
timestamp: 2013-07-06T13:00:00
tags:
  - is_number
  - looks_like_number
  - Scalar::Util
  - cast
  - conversione di tipo
published: true
original: automatic-value-conversion-or-casting-in-perl
books:
  - beginner
author: szabgab
translator: giatorta
---


Immaginate di scrivere nella lista della spesa

```
"2 pagnotte"
```

e di darla alla vosta dolce metà la quale in tutta risposta
vi tira contro on errore di conversione non valida di tipo.
Dopo tutto, nella lista "2" è una stringa, non un numero.

Sarebbe piuttosto frustrante, vero?


## Conversioni di tipo in Perl

In molti linguaggi di programmazione il tipo degli operandi determina il comportamento di un operatore.
Ovvero, la <i>somma</i> di due numeri è la loro addizione numerica, mentre la <i>somma</i> di due stringhe è la loro concatenazione.
Questo meccanismo è detto overloading degli operatori.

Per molti aspetti, Perl ragiona in modo opposto.

In Perl, l'operatore determina come usare gli operandi.

Quindi, se usate un'operazione numerica (ad es. l'addizione) entrambi i valori
vengono automaticamente convertiti in numeri. Se usate un'operazione stringa
(ad es. la concatenazione) entrambi i valori vengono automaticamente convertiti in stringhe.

I programmatori C probabilmente chiamerebbero <b>cast</b> queste conversioni ma nel mondo Perl
questo termine non è utilizzato. Probabilmente perché tutto avviene automaticamente.

A Perl non importa se scrivete qualcosa in forma di numero o di stringa.
Converte automaticamente tra le due possibilità in base al contesto.

La conversione `numero => stringa` è facile.
Basta immaginare di aggiungere "" intorno al valore numerico.

La conversione `stringa => numero` invece può darci un po' da pensare.
Se la stringa presenta l'aspetto di un numero, è di nuovo facile.
Il valore numerico è la stessa cosa senza i doppi apici.

Se c'è un carattere qualunque che impedisce a perl di convertire completamente la stringa in un
numero, perl usa il prefisso della stringa più lungo possibile come
valore numerico e ignora il resto.

Vediamo un paio di esempi:

```
Originale   Stringa    Numero

  42         "42"        42
  0.3        "0.3"       0.3
 "42"        "42"        42
 "0.3"       "0.3"       0.3

 "4z"        "4z"        4        (*)
 "4z3"       "4z3"       4        (*)
 "0.3y9"     "0.3y9"     0.3      (*)
 "xyz"       "xyz"       0        (*)
 ""          ""          0        (*)
 "23\n"      "23\n"      23
```

In tutti i casi dove la conversione da stringa a numero non è perfetta,
eccetto l'ultimo, perl genera un warning. Almeno se avete
attivato `use warnings` come vi ho raccomandato.

## Esempio

Ora che abbiamo visto la tabella vediamo un po' di codice:

```perl
use strict;
use warnings;

my $x = "4T";
my $y = 3;

```

La concatenazione converte entrambi i valori in stringhe:

```perl
print $x . $y;    # 4T3
```

L'addizione numerica converte entrambi i valori in numeri:

```perl
print $x + $y;  # 7
                # Argument "4T" isn't numeric in addition (+) at ...
```

## Argument isn't numeric

Ricevete questo warning quando perl tenta di convertire
una stringa in un numero e la conversione non riesce perfettamente.

Ci sono svariati altri warning ed errori comuni in Perl.
Per esempio [Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)
e [Use of uninitialized value](/use-of-uninitialized-value).

## Come si può evitare il warning?

È bello che perl vi avverta (quando glielo chiedete) se una conversione di tipo non è perfetta, ma non esiste una funzione
come <b>is_number</b> che controlli se una data stringa è davvero un numero?

Sì e no.

Perl non ha una funzione <b>is_number</b> dato che questo implicherebbe in qualche modo che gli sviluppatori Perl
sappiano che cos'è un numero. Purtroppo non esiste un accordo universale su questo punto. Ci sono sistemi
dove ".2" è accettato come numero e altri in cui non è accettato.
Ancora più spesso, non viene accettato "2.", ma ci sono sistemi dove è considerato un numero perfettamente lecito.

Ci sono perfino casi in cui 0xAB è considerato un numero. Naturalmente, esadecimale.

Quindi non abbiamo a disposizione una funzione <b>is_number</b>, ma ne abbiamo una che ha un po' meno certezze, chiamata <b>looks_like_number</b>.

Fa proprio ciò che pensate. Controlla se, secondo perl, una data stringa sembra un numero.

È fornita dal modulo [Scalar::Util](http://perldoc.perl.org/Scalar/Util.html) e
potete usarla così:

```perl
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

print "Quante pagnotte devo comprare? ";
my $loaves = <STDIN>;
chomp $loaves;

if (looks_like_number($loaves)) {
    print "Vado e torno...\n";
} else {
    print "Scusa ma non ho capito\n";
}
```


E non dimenticate di prendere anche il latte!



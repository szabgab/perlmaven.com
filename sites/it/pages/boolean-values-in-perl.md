---
title: "Valori Booleani in Perl"
timestamp: 2013-07-16T07:00:00
tags:
  - undef
  - vero
  - falso
  - booleano
published: true
original: boolean-values-in-perl
books:
  - beginner
author: szabgab
translator: giatorta
---


Perl non ha uno specifico tipo booleano, eppure
nella documentazione di Perl potete spesso leggere che una funzione restituisce un valore "Booleano".
Qualche volta la documentazione dice che una funzione restituisce vero o restituisce falso.

Dove sta dunque la verità?



Perl non ha uno specifico tipo booleano, ma ogni valore scalare - controllato con un <b>if</b>
sarà o vero o falso. Potete quindi scrivere

```perl
if ($x eq "foo") {
}
```

e potete anche scrivere

```perl
if ($x) {
}
```

il primo controlla se il contenuto della variabile <b>$x</b> è la stringa
"foo" mentre il secondo controlla se $x stessa ha valore vero o meno.

## Quali valori sono veri e falsi in Perl?

È piuttosto facile. Nella documentazione leggiamo:

<pre>
Il numero 0, le stringhe '0' e '', la lista vuota "()" e "undef"
sono tutti falsi in contesto booleano. Tutti gli altri valori sono veri.
La negazione di un valore vero con "!" o "not" restituisce un valore falso
speciale. Quando viene usato come stringa è trattato come '', ma come numero è trattato come 0.

Da perlsyn nella sezione "Truth and Falsehood".
</pre>

Quindi i seguenti valori scalari sono considerati falsi:

* undef - il valore indefinito
* 0  il numero 0, anche se lo scrivete come 000 o 0.0
* ''   la stringa vuota.
* '0'  la stringa che contiene un'unica cifra 0.

Tutti gli altri valori scalari sono veri, inclusi i seguenti:

* 1 tutti i numeri diversi da 0
* ' '   la stringa contenente uno spazio
* '00'   due o più caratteri 0 in una stringa
* "0\n"  uno 0 seguito da a capo
* 'vero'
* 'falso'   sì, anche la stringa 'falso' (o la stringa 'false') ha valore vero.

Penso che ciò sia dovuto al fatto che [Larry Wall](http://www.wall.org/~larry/),
creatore di Perl, ha in generale una visione positiva del mondo.
Probabilmente crede che ci siano pochissime cose false e cattive nel mondo.
Quasi tutte sono vere.


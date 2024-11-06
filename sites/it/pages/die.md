---
title: "What does die do?"
timestamp: 2013-12-06T21:00:00
tags:
  - die
published: true
original: die
books:
  - beginner
author: szabgab
translator: giatorta
---


Quando volete segnalare che qualcosa è andato un po' storto, chiamate la funzione [warn](/warn).

Quando volete segnalare che qualcosa è andato tremendamente storto, e volete gettare la spugna, chiamate `die`.


Chi ha letto un po' di codice Perl dovrebbe avere familiarità con `die`.
Una delle espressioni più note è la `open or die` usata per [aprire un file](https://perlmaven.com/open-and-read-from-files).

Una chiamata a `die` stampa la stringa data su [standard error (STDERR)](/stdout-stderr-and-redirection)
e poi termina il programma.

Come [warn](/warn), se la stringa che le passate <b>non</b> termina con
un carattere di a capo `\n`, perl include automaticamente il nome del file e il numero della linea dove è stata chiamata `die`.

Questo può essere utile successivamente per trovare la causa del problema.


## Lanciare eccezioni

In effetti die lancia una vera e propria eccezione, anche se la cosa può essere ignorata negli script più semplici.
In tali script probabilmente non avete del codice specializzato per catturare le eccezioni, e vi limitate
ad usare `die` al posto di chiamare [warn](/warn)
e poi [>exit](/how-to-exit-from-perl-script).


In applicazioni più grandi, quando iniziate a scrivere dei moduli, potreste invece iniziare a voler
lanciare delle eccezioni e catturarle con `eval`. Ne parleremo in
un prossimo articolo.

## Intercettare le chiamate a die

Con una tecnica un po' più avanzata, Perl fornisce un gestore di segnali per i die
proprio come fa per i `warn`. La differenza fondamentale è che il gestore di segnali che
intercetta le chiamate a die non impedisce la terminazione del vostro script. Il suo interesse è limitato
ai casi in cui l'eccezione viene già catturata (ad es. usando `eval`)
e volete intercettare i casi in cui qualcuno ha catturato l'eccezione ma non l'ha gestita adeguatamente.
Per tali casi leggete l'articolo su come [catturare le chiamate a die](https://perlmaven.com/how-to-capture-and-save-warnings-in-perl).



---
title: "Generare warning quando qualcosa va storto"
timestamp: 2013-11-18T16:00:00
tags:
  - warn
  - STDERR
published: true
original: warn
books:
  - beginner
author: szabgab
translator: giatorta
---


Quando qualcosa non va esattamente come dovrebbe nel vostro script/programma/applicazione, è buon uso avvertire
l'utente del problema. In uno script da linea di comando si può semplicemente stampare un
messaggio di warning sul [canale Standard Error](/stdout-stderr-and-redirection).


Come illustrato nell'articolo su [standard output e standard error](/stdout-stderr-and-redirection),
in Perl potete stampare un messaggio su `STDERR`

```perl
print STDERR "Piccolo problema...\n";
```

C'è però un modo standard preferibile a questo: potete semplicemente chiamare
la funzione `warn`:

```perl
warn "Piccolo problema.\n";
```

Oltre ad essere più sintetico, risulta più espressivo e, nella forma usata, ha lo stesso effetto.

In entrambi i casi lo script, dopo aver stampato il messaggio di warning, continua l'esecuzione!

Ma c'è di più.  Se omettete il carattere di a capo finale (il `\n` alla fine):

```perl
warn "Piccolo problema.";
```

l'output includerà il nome del file e il numero della linea
dove è stata chiamata la funzione `warn`:

```
Piccolo problema. at programma.pl line 5.
```

Può essere molto utile quando avete uno script che lancia molti altri script
o quando avete una applicazione di grandi dimensioni composta da molti moduli.
In particolare rende molto più facile per voi e per chi usa il vostro programma
identificare la causa del problema.

## Catturare i warning

C'è ancora di più.

Perl ha introdotto uno speciale gestore di segnali per i warning.
Ciò significa che voi o qualcun altro potete aggiungere al programma del codice per
[catturare tutti i warning](https://perlmaven.com/how-to-capture-and-save-warnings-in-perl).
È un argomento un po' troppo avanzato per ora, ma se siete interessati vi invito a dare
un'occhiata a quella pagina.

## avvertenza

Un piccolo avvertimento. Potreste imbattervi in casi in cui un warning generato dopo
un'istruzione print compare prima del contenuto stampato da print:

Questo codice:

```perl
print "prima";
warn "Piccolo problema.\n";
print STDERR "Altri problemi.\n";
print "dopo";
```

che genera questo output:

```
Piccolo problema.
Altri problemi.
primadopo
```

In cui la parola "prima" compare dopo entrambi i messaggi di warning.

Per casi simili leggete la sezione sul [buffering](/stdout-stderr-and-redirection#buffering).


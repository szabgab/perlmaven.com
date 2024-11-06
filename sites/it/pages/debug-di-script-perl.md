---
title: "Debug di script Perl"
timestamp: 2013-05-06T09:09:09
tags:
  - -d
  - Data::Dumper
  - print
  - debug
  - debugging
  - $VAR1
  - $VAR2
published: true
original: debugging-perl-scripts
books:
  - beginner
author: szabgab
translator: giatorta
---


Quando studiavo informatica all'università ho imparato molte cose su come si scrivono i programmi
ma, almeno per quanto ricordo, nessuno ci ha mai parlato del debug. Ci hanno descritto un mondo dove si creano
sempre cose nuove, ma nessuno ci ha avvertiti che avremmo speso la maggior parte del tempo tentando di capire il codice
di altri.

Quasi tutti noi preferiamo scrivere programmi, ma spendiamo
molto più tempo tentando di capire che cosa fa un pezzo di codice che noi stessi (o altri) abbiamo scritto in passato e perché
non funziona del tempo che avevamo speso a scriverlo.


## Che cos'è il debug?

Prima dell'esecuzione di un programma le cose erano in uno stato conosciuto e normale.

Dopo l'esecuzione alcune cose sono in uno stato anomalo e inatteso.

L'obiettivo è quello di trovare il punto esatto in cui qualcosa è andato storto e correggerlo.

## Che cos'è la programmazione e che cos'è un bug?

Il cuore della programmazione consiste nel cambiare un po' il mondo spostando dati qua e la tra le variabili.

Ad ogni passo di un programma modifichiamo qualche dato in una variabile del programma o qualcosa nel "mondo reale".
(Per esempio sul disco o sullo schermo.)

Mentre state scrivendo un programma, vi chiedete ad ogni passo: quale valore dovrei mettere in quale variabile?

Un bug si verifica quando pensavate che il valore X dovesse essere messo in qualche variabile, mentre in realtà ci è stato messo il valore Y.

A un certo punto, spesso quando termina l'esecuzione del programma, vi accorgete del problema perché il programma stampa un valore non corretto.

Durante l'esecuzione del programma il bug può manifestarsi con dei warning o con la terminazione anormale del programma.

## Come si fa il debug?

Il modo più ovvio di fare il debug di un programma è quello di eseguirlo controllando ad ogni passo se tutte le variabili
contengono i valori che vi aspettate. Per ottenere questo scopo potete <b>usare un debugger</b> oppure disseminare il programma di <b>istruzioni print</b> e successivamente esaminare il suo output.

Perl viene distribuito con un debugger a linea di comando molto potente. Vi invito ad imparare a usarlo,
anche se potrebbe apparire un po' ostico all'inizio. Ho preparato un video dove illustro i
[comandi base del debugger nativo di Perl](https://perlmaven.com/using-the-built-in-debugger-of-perl).

Le IDE, come [Komodo](http://www.activestate.com/),
[Eclipse](http://eclipse.org/) e
[Padre, the Perl IDE](http://padre.perlide.org/) sono
dotate di debugger grafici. Prima o poi preparerò un video anche per qualcuna delle IDE.

## Istruzioni print

Molte persone adottano l'antica strategia di inserire istruzioni print nel codice.

Per un linguaggio dove la compilazione e il link possono richiedere molto tempo le istruzioni print
non sono considerate un buon modo di fare debug.
Questo non accade in Perl, dato che anche applicazioni di grandi dimensioni vengono compilate e iniziano l'esecuzione in pochi secondi.

Quando inserite istruzioni print dovete fare attenzione a racchiudere i valori tra delimitatori. In questo modo potrete rilevare
la spaziatura all'inizio e alla fine del valore che potrebbe essere la causa del problema.
Senza delimitatori è difficile accorgersene.

I valori scalari possono essere stampati come segue:

```perl
print "<$file_name>\n";
```

Lo scopo dei caratteri di minore e maggiore è soltanto quello di rendere più facile al lettore la visione dell'effettivo contenuto della variabile:

```
<path/to/file
>
```

Se print stampa questo potete facilmente rilevare che c'è un carattere di a capo alla fine della variabile
$file_name. Probabilmente avete dimenticato di chiamare <b>chomp</b>.

## Strutture dati complesse

Nel tutorial che state leggendo non abbiamo ancora introdotto neppure gli scalari, ma permettetemi di fare un salto in avanti per parlare di come
si stampa a video il contenuto di strutture dati più complesse. Se state leggendo questo articolo
mentre seguite il tutorial Perl forse vi conviene passare subito al prossimo argomento e tornare qui in un secondo tempo.
In questo momento potrebbe essere difficile capire di che cosa parla.

ALtrimenti, continuate pure a leggere.

Per le struttura dati complesse (riferimenti, array e hash) potete usare `Data::Dumper`

```perl
use Data::Dumper qw(Dumper);

print Dumper \@an_array;
print Dumper \%a_hash;
print Dumper $a_reference;
```

Questo codice stampa un output come il seguente, che aiuta a capire che cosa contengono le vostre variabili
ma utilizza dei nomi generici di variabili come `$VAR1` e `$VAR2`.

```
$VAR1 = [
       'a',
       'b',
       'c'
     ];
$VAR1 = {
       'a' => 1,
       'b' => 2
     };
$VAR1 = {
       'c' => 3,
       'd' => 4
     };
```

Vi suggerisco di aggiungere il codice per stampare il nome delle variabili:

```perl
print '@an_array: ' . Dumper \@an_array;
```

in modo da ottenere:

```
@an_array: $VAR1 = [
        'a',
        'b',
        'c'
      ];
```

oppure:

```perl
print Data::Dumper->Dump([\@an_array, \%a_hash, $a_reference],
   [qw(an_array a_hash a_reference)]);
```

per ottenere:

```
$an_array = [
            'a',
            'b',
            'c'
          ];
$a_hash = {
          'a' => 1,
          'b' => 2
        };
$a_reference = {
               'c' => 3,
               'd' => 4
             };
```

Ci sono modi migliori per stampare strutture dati ma per ora `Data::Dumper`
è adeguato alle nostre esigenze ed ha il vantaggio di essere disponibile in ogni installazione di Perl.
Discuteremo altri metodi più avanti.


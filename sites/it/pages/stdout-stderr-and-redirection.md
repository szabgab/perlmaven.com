---
title: "Standard output, standard error e redirezione da linea di comando"
timestamp: 2013-11-12T12:00:00
tags:
  - STDOUT
  - STDERR
  - /dev/null
  - $|
  - buffering
published: true
original: stdout-stderr-and-redirection
books:
  - beginner
author: szabgab
translator: giatorta
---


Quando eseguite un programma dalla linea di comando, esso ha automaticamente a disposizione due canali di output separati.
Uno di essi è detto <b>Standard Output</b>, l'altro <b>Standard Error</b>.

Di default entrambi sono connessi allo schermo (nella shell, il terminale o finestra dei comandi)
e quindi i loro contenuti si mescolano, ma l'utente del programma può decidere di separarli
<b>redirigendo</b> uno di essi o entrambi su un file.


Lo scopo è che il normale output dell'applicazione vada sul canale Output
mentre i warning e gli errori vadano sul canale Error.

Come programmatori, dovete decidere quale output debba essere considerato parte del normale
flusso del programma, in modo da inviarlo al canale Standard Output. Il resto, ovvero
l'output anomalo, verrà inviato al canale Standard Error.

Se un utente vuole vedere solo l'output normale può redirigire il canale di errore su un file
da esaminare separatamente in un secondo momento.

## Come si stampano i messaggi d'errore?

In Perl, quando un programma inizia l'esecuzione questi due canali di output sono rappresentati da due simboli:
`STDOUT` rappresenta lo Standard Output e `STDERR` rappresenta lo Standard Error.

All'interno del programma Perl potete stampare su uno di questi canali aggiungendo
STDOUT o STDERR subito dopo la keyword `print`:

```perl
print STDOUT "Benvenuto nel nostro piccolo programma\n";
print STDERR "Impossibile aprire il file\n";
```

(notate che in questa espressione non c'è la virgola `,` dopo i simboli STDOUT e STDERR!)

Se eseguite questo script (`perl programma.pl`) vedrete sullo schermo ciò che segue:

```
Benvenuto nel nostro piccolo programma
Impossibile aprire il file
```

Il fatto che i due output siano stati inviati a due diversi canali non è visibile.

## Canale di output di default

Se volete, potete omettere il simbolo `STDOUT` dallo script qui sopra
e scrivere semplicemente:

```perl
print "Benvenuto nel nostro piccolo programma\n";
print STDERR "Impossibile aprire il file\n";
```

Quando il vostro script perl inizia l'esecuzione, STDOUT è definito come <b>canale di output di default</b>.
Ciò implica che qualunque operazione di stampa in cui non sia esplicitamente specificato un canale stamperà su STDOUT.

## Redirezione di Standard Output

(Gli esempi qui sotto assumono che usiate una shell compatibile con bash. Altre shell potrebbero comportarsi diversamente.)

Come utente, senza dover guardare il codice, potete separare i due canali:
Se eseguite `perl programma.pl > out.txt` il simbolo `>` <b>redirigerà</b>
il canale di output sul file out.txt. Pertanto, sullo schermo vedrete solo il
contenuto dello Standard Error:

```
Impossibile aprire il file
```

Se aprite il file out.txt (ad es. con Notepad, vim o qualunque altro editor di testo)
vedrete che contiene `Benvenuto nel nostro piccolo programma`.

## Redirezione di Standard Error

Se invece eseguite lo script come `perl programma.pl 2> err.txt`,
il simbolo `2>` <b>redirigerà</b> il canale di errore sul file err.txt.

Sullo schermo vedrete:

```
Benvenuto nel nostro piccolo programma
```

Se aprite il file err.txt, esso conterrà: `Impossibile aprire il file`.

## Redirezione di entrambi

Potete anche redirezionare entrambi i canali usando entrambi i simboli sulla
linea di comando.

Eseguendo lo script come `perl programma.pl > out.txt 2> err.txt`, lo
schermo resterà vuoto. Il contenuto stampato sul canale standard output
si troverà nel file out.txt e il contenuto stampato
sul canale di standard error si troverà nel file err.txt.


Negli esempi qui sopra, i nomi di file out.txt e err.txt erano completamente arbitrari.
Potete usare nomi qualunque.

## /dev/null

Sui sistemi Unix/Linux esiste un file speciale con pathname `/dev/null`.
Si comporta come un buco nero. Qualunque cosa stampiate su tale file
scomparirà senza lasciar tracce. Viene usato principalmente quando un utente vuole
liberarsi dell'output regolare o dei messaggi di errore di un programma esistente.

Per esempio, potreste avere un'applicazione che non potete modificare e
che butta fuori quintali di messaggi sul canale di standard error.
Se non volete vederli sullo schermo potete
redirigerli su un file. Ma se lo fate, il vostro disco potrebbe riempirsi velocemente.
Allora potete redirigire lo standard error su /dev/null e il sistema
operativo si occuperà di liberarvi di tutta quella "spazzatura".

`perl programma.pl 2> /dev/null`

## nul su MS Windows

La controparte di `/dev/null` su MS Windows è semplicemente `nul`

`perl programma.pl > nul` redirige lo standard output sul "buco nero",
e `perl programma.pl 2> nul` fa lo stesso con lo standard error.

## Supporto Unix/Linux/Windows?

La stampa separata su STDOUT e STDERR da Perl funziona su ogni
sistema operativo, ma la redirezione potrebbe non funzionare. Dipende
dal sistema operativo e, più specificamente, 
dalla shell (linea comando).

Ciò che ho illustrato qui sopra dovrebbe funzionare su tutti i sistemi Unix/Linux e su MS Windows.
Ricordate che `/dev/null` è disponibile solo sui sistemi Unix/Linux.

<h2 id="buffering">Ordine dell'output (buffering)</h2>

E ora un piccolo avvertimento:

Con questo codice:

```perl
print "prima";
print STDERR "Piccolo problema.\n";
print "dopo";
```

L'output potrebbe essere:

```
Piccolo problema.
primadopo
```

Notate che sia "prima" che "dopo" compaiono sullo schermo <b>dopo</b> il messaggio d'errore.
Anche se ci aspettavamo che "prima" comparisse, be'... prima del messaggio d'errore.

La ragione è che, di default, Perl fa il buffering dell'output su STDOUT e non
su STDERR. Per disattivare il buffering usate la "bacchetta magica" `$|`:

```perl
$| = 1;

print "prima";
print STDERR "Piccolo problema.\n";
print "dopo";
```

```
primaPiccolo problema.
dopo
```

Aggiungere un carattere di a capo alla stringa da stampare su STDOUT di solito ha lo stesso effetto:

```perl
print "prima\n";
print STDERR "Piccolo problema.\n";
print "dopo";
```

E anche l'output è migliore:

```
prima
Piccolo problema.
dopo
```





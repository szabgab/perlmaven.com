---
title: "Installare Perl e iniziare a usarlo "
timestamp: 2013-04-09T09:01:01
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
published: true
original: installing-perl-and-getting-started
books:
  - beginner
author: szabgab
translator: giatorta
---


Questa è la prima parte del [tutorial Perl](/perl-tutorial).

In questa parte imparerete a installare Perl su Microsoft Windows e ad iniziare a
usarlo su Windows, Linux e sul Mac.

Riceverete istruzioni su come configurare il vostro ambiente di sviluppo, ovvero (in parole povere):
quale editor o IDE usare per scrivere in Perl?

Vedremo anche il classico esempio "Hello World".


## Windows

Su Windows useremo [DWIM Perl](http://dwimperl.com/), un package
che contiene il compilatore/interprete Perl, [Padre, la IDE Perl](http://padre.perlide.org/)
e svariate estensioni da CPAN.

Per prima cosa andate sul sito di [DWIM Perl](http://dwimperl.com/)
e seguite il link per scaricare <b>DWIM Perl per Windows</b>.

Scaricate il file exe e installatelo sul vostro sistema, dopo esservi
assicurati di non avere altre installazioni di Perl.

Non è escluso che DWIM Perl possa convivere con altre installazioni, ma sarebbero necessarie ulteriori spiegazioni.
Per il momento fate in modo di avere un'unica versione di Perl installata sul vostro sistema.

## Linux

La maggior parte delle distribuzioni Linux attuali contengono una versione recente di Perl.
Per il momento useremo quella versioe di Perl. Come editor
potete installare Padre - molte distribuzioni Linux lo mettono a disposizione attraverso il loro
sistema ufficiale di gestione dei package. In alternativa potete usare un qualunque editor di testo.
Se conoscete vim o Emacs, usate quello che preferite tra i due. Altrimenti
Gedit può essere una buona scelta per la sua semplicità.

## Apple

Credo che anche i Mac abbiano Perl pre-installato o che sia possibile installarlo facilmente con
gli strumenti standard di installazione.

## Editor e IDE

Anche se preferibile, non è necessario che usiate la IDE Padre per scrivere del codice Perl.
In seguito elencherò un paio di [editor e IDE](https://perlmaven.com/perl-editor) che
potete usare per programmare in Perl. Anche se scegliete un altro editor,
raccomando agli utenti Windows di installare comunque il package DWIM Perl menzionato sopra.

Contiene molte estensioni di Perl e vi farà risparmiare molto tempo nel seguito di questo tutorial.

## Video

Se preferite, potete anche vedere il video
[Hello world with Perl](http://www.youtube.com/watch?v=c3qzmJsR2H0)
che ho caricato su YouTube. In tal caso potreste essere interessati anche a dare uno
sguardo al video [Beginner Perl Maven video course](https://perlmaven.com/beginner-perl-maven-video-course).

## Primo programma

Il vostro primo programma ha il seguente aspetto:

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

Vediamolo insieme passo a passo.

## Hello world

Dopo aver installato DWIM Perl potete selezionare
"Start -> All programs -> DWIM Perl -> Padre" per aprire l'editor
con un file vuoto.

Scrivete

```perl
print "Hello World\n";
```

Come potete vedere, le istruzioni in perl terminano con un punto e virgola `;`.
Il simbolo `\n` è usato per denotare un a capo.
Le stringhe sono delimitate con doppi-apici `"`.
La funzione `print` stampa sullo schermo.
Quando questo programma viene eseguito, perl stampa il testo seguito da un a capo.

Salvate il file come hello.pl e poi eseguitelo selezionando "Run -> Run Script"
Vedrete apparire una nuova finestra con l'output.

Ecco fatto, avete appena creato il vostro primo script perl.

Ora miglioriamolo un po'.

## Perl da linea di comando per chi non usa Padre

Se non usate Padre o una delle altre [IDE](https://perlmaven.com/perl-editor)
non potete eseguire il vostro script da dentro l'editor stesso.
Almeno non di default. Dovete quindi aprire una shell
(o cmd in Windows), spostarvi nella directory dove avete salvato il file hello.pl
e scrivere:

`perl hello.pl`

In questo modo potete eseguire il vostro script da linea di comando.

## say() al posto di print()

Miglioriamo un po' il nostro script Perl lungo una riga:

Anzitutto dichiariamo qual è la minima versione di Perl che vogliamo usare:

```perl
use 5.010;
print "Hello World\n";
```

Dopo aver fatto questa modifica, potete eseguire di nuovo lo script selezionando
"Run -> Run Script" oppure premendo <b>F5</b>.
Lo script verrà salvato automaticamente prima di essere eseguito.

In generale è una buona pratica specificare la minima versione di perl richiesta dal vostro codice.

In questo caso aggiunge anche alcune nuove funzionalità al perl, tra cui la funzione `say`.
`say` è equivalente a `print` ma è più breve e
aggiunge automaticamente un carattere di a capo alla fine.

Potete modificare il vostro codice così:

```perl
use 5.010;
say "Hello World";
```

Abbiamo sostituito `print` con `say` e rimosso il `\n` dalla fine della stringa.

L'installazione che state usando è probabilmente la version 5.12.3 o 5.14.
Quasi tutte le distribuzioni Linux attuali contengono la versione 5.10 o una successiva.

Purtroppo ci sono ancora installazioni che usano versioni precedenti di perl.
In questi casi non è possibile usare la funzione `say()` e potrebbe essere necessario fare degli aggiustamenti
agli esempi che verranno presentati più avanti. Quando userò funzionalità che richiedono la versione 5.10
lo indicherò esplicitamente.

## Rete di salvataggio

Raccomando inoltre che, in ogni vostro script, facciate alcune ulteriori modifiche al comportamento di Perl. A questo scopo aggiungiamo due direttive (anche dette pragma), che sono molto simili a delle opzioni di compilazione
in altri linguaggi:

```perl
use 5.010;
use strict;
use warnings;

say "Hello World";
```

In questo caso la parola chiave `use` dice a perl di caricare e attivare ciascuna direttiva.

`strict` e `warnings` vi aiuteranno a intercettare alcuni bug comuni
nel vostro codice o addirittura, qualche volta, a evitare del tutto di introdurli.
Sono molto utili.

## Input Utente

Miglioriamo ora il nostro esempio chiedendo all'utente il suo nome
e includendolo nella risposta.

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
say "Hello $name, how are you?";
```

`$name` è detta variabile scalare.

Le variabili vengono dichiarate con la parola chiave <b>my</b>.
(in realtà, è una delle restrizioni imposte da `strict`.)

Le variabili scalari iniziano sempre con un carattere `$`.
La lettura di una linea dalla tastiera è effettuata da &lt;STDIN&gt;.

Scrivete il codice riportato sopra ed eseguitelo premendo F5.

Vi verrà chiesto il vostro nome. Scrivetelo e premete ENTER per far sapere a perl
che avete finito.

Noterete che l'output è un po' sbagliato: la virgola dopo
il nome compare a capo. La ragione è che il tasto ENTER che avete premuto dopo aver scritto il vostro nome
è stato memorizzato nella variabile `$name`.

## Liberarsi degli a capo

```perl
use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
chomp $name;
say "Hello $name, how are you?";
```

È un compito così comune in Perl che esiste una funzione speciale `chomp`
per rimuovere i caratteri finali di a capo dalle stringhe.

## Conclusioni

Aggiungete <b>sempre</b> le direttive `use strict;` e `use warnings;`
in testa a ogni script che create. Vi consiglio anche caldamente di aggiungere `use 5.010;`.

## Esercizi

Vi avevo promesso degli esercizi.

Provate il seguente script:

```perl
use strict;
use warnings;
use 5.010;

say "Hello ";
say "World";
```

Non ha stampato tutto su una unica linea. Perché? Come si può correggere?

## Esercizio 2

Scrivete uno script che chieda all'utente due numeri, uno dopo l'altro,
e stampi la somma dei due numeri.

## E poi?

La prossima parte del tutorial riguarda
[editor, IDE e ambiente di sviluppo Perl](/editor-perl).  

---
title: "Documentazione base di Perl e documentazione dei moduli CPAN"
timestamp: 2013-04-19T14:27:01
tags:
  - perldoc
  - documentation
  - POD
  - CPAN
published: true
original: core-perl-documentation-cpan-module-documentation
books:
  - beginner
author: szabgab
translator: giatorta
---


Perl è fornito di molta documentazione, ma
occorre un po' di pratica prima di abituarsi ad usarla. In questa parte del
[tutorial Perl](/perl-tutorial) vi spiegherò come
orientarvi nei meandri della documentazione.


## perldoc sul web

Il modo più semplice di accedere alla documentazione base di perl
è quello di visitare il sito [perldoc](http://perldoc.perl.org/).

Contiene la versione HTML della documentazione del linguaggio Perl
e dei moduli distribuiti con Perl secondo il rilascio dei Perl 5 Porters.

Non contiene documentazione per i moduli CPAN.
C'è però qualche sovrapposizione, dato che alcuni moduli disponibili
su CPAN sono anche includi nella distribuzione standard di Perl.
(Tali moduli sono detti <b>dual-lifed</b>, ovvero con una "doppia vita")

Potete usare il campo di ricerca nell'angolo in alto a destra. Per esempio potete
scrivere `split` per otterrete la documentazione di `split`.

Purtroppo il motore di ricerca non è in grado di trovare la documentazione di `while`, né di
`$_` o di `@_`. Per accedervi
è necessario navigare la documentazione.

La pagina più rilevante potrebbe essere [perlvar](http://perldoc.perl.org/perlvar.html),
dove troverete informazioni su variabili come `$_` e `@_`.

[perlsyn](http://perldoc.perl.org/perlsyn.html) spiega la sintassi di Perl
inclusa quella del [ciclo while](https://perlmaven.com/while-loop).

## perldoc da linea di comando

La stessa documentazione è inclusa anche nella distribuzione di Perl, ma non
tutte le distribuzioni Linux la installano di default. Talvolta la si trova
in un package separato. Per esempio in Debian e Ubuntu c'è il package <b>perl-doc</b>.
Dovete installarlo con `sudo aptitude install perl-doc`
prima di poter usare il comando `perldoc`.

Una volta installato, scrivendo `perldoc perl` sulla linea di comando
otterrete una breve spiegazione e una lista dei capitoli della documentazione di Perl.
Potete uscire premendo il tasto `q` e scrivere il nome di uno dei capitoli.
Per esempio: `perldoc perlsyn`.

Funziona sia su Linux che su Windows anche se il paginatore di Windows è davvero scadente
e non posso raccomandarvelo. Linux utilizza il lettore standard di pagine man con cui dovreste già
avere una certa familiarità.

## Documentazione dei moduli CPAN

Ogni modulo CPAN è corredato da documentazione ed esempi.
La quantità e qualità di tale documentazione varia in modo significativo
da autore ad autore, e anche uno stesso autore può avere
alcuni moduli ben documentati e altri molto mal documentati.

Dopo aver installato un modulo Module::Name,
potete accedere alla sua documentazione scrivendo `perldoc Module::Name`.

C'è però un modo più comodo, che non richiede neanche di
avere il modulo installato. Ci sono molte interfacce
web a CPAN. Le più importanti sono [Meta CPAN](http://metacpan.org/)
e [search CPAN](http://search.cpan.org/).

Sono tutte basate sulla stessa documentazione, ma permettono
di accedervi in modi leggermente diversi.


## Ricerca per keyword su Perl Maven

Recentemente è stata aggiunta a questo sito una ricerca per keyword nella barra di menu in alto.
Gradualmente potrete trovare spiegazioni per una parte sempre più ampia di perl.
A un certo punto saranno aggiunte anche una parte della documentazione base di perl e la documentazione dei
moduli CPAN più importanti.

Se pensate che manchi qualcosa, create un commento qui sotto
specificando le keyword che vi interessano, e avrete ottime probabilità che
la vostra richiesta sia soddisfatta.


---
title: "POD - Plain Old Documentation"
timestamp: 2013-04-23T22:22:22
tags:
  - POD
  - perldoc
  - =head1
  - =cut
  - =pod
  - =head2
  - documentazione
  - pod2html
  - pod2pdf
published: true
original: pod-plain-old-documentation-of-perl
books:
  - beginner
author: szabgab
translator: giatorta
---


In genere ai programmatori non piace scrivere documentazione. In parte, questo è dovuto
al fatto che i programmi sono semplici file di testo mentre in molti casi la documentazione
deve essere scritta utilizzando un word processor.

Ciò richiede di imparare ad usare il word processor e di dedicare un sacco di energie
alla forma del documento invece di concentrarsi sul suo contenuto.

In Perl le cose stanno diversamente. Potete infatti
scrivere la documentazione dei vostri moduli direttamente nel codice sorgente e
usare un tool esterno per formattarla in modo che abbia un aspetto gradevole.


In questo episodio del [tutorial Perl](/perl-tutorial)
ci occuperemo di <b>POD - Plain Old Documentation</b>, ovvero il
linguaggio di mark-up usato dagli sviluppatori perl.

Un semplice pezzo di codice perl contenente del POD è il seguente:

```perl
#!/usr/bin/perl
use strict;
use warnings;

=pod

=head1 DESCRIZIONE

Questo script puo' avere 2 parametri. Il nome o indirizzo di una macchina
e un comando. Esegue il comando sulla macchina specificata e stampa
l'output a video.

=cut

print "Codice ... \n";
```

Se lo salvate come `script.pl` e lo eseguite con `perl script.pl`,
perl ignorerà tutto il testo contenuto tra le linee `=pod` e `=cut`.
Eseguirà quindi solo il codice vero e proprio.

Invece, se scrivete `perldoc script.pl`, il comando <b>perldoc</b>
ignorerà il codice e leggerà le linee tra `=pod` e `=cut`,
 formattandole secondo certe regole e visualizzandole sullo schermo.

Tali regole dipendono dal vostro sistema operativo e sono esattamente le
stesse che si applicano alla
[documentazione standard di Perl](/documentazione-base-perl-documentazione-moduli-cpan).

Il vantaggio di avere il POD incorporato nel codice è che il vostro codice non può essere distribuito
accidentalmente senza documentazione, dato che essa si trova all'interno dei moduli e degli script.
Inoltre potete sfruttare i tool e le infrastrutture che la comunità Open Source di Perl ha
creato. Anche per farne semplicemente un uso personale.

## Troppo semplice?

L'assunzione di base è che se si rimuovono il maggior numero di ostacoli alla scrittura
di documentazione ci saranno più persone disposte a scriverla. Invece di dover imparare
ad usare un word processor per creare dei documenti di aspetto gradevole, dovete soltanto
scrivere il testo con alcuni simboli extra e otterrete dei documenti con un aspetto
ragionevole. (I documenti su [Meta CPAN](http://metacpan.org/)
sono esempi di POD ben formattato.)

## Il linguaggio di markup

La descrizione dettagliata del [linguaggio di markup POD](http://perldoc.perl.org/perlpod.html)
si ottiene scrivendo [perldoc perlpod](http://perldoc.perl.org/perlpod.html) ed
è molto semplice.

Ci sono alcuni tag come `=head1` e `=head2`
per contrassegnare titoli "molto importanti" e "un po' meno importanti".
Ci sono i tag `=over` per l'indentazione e `=item`
per creare elenchi puntati, e alcuni altri.

C'è `=cut` per contrassegnare la fine di una sezione POD e
`=pod` per l'inizio. Anche se il tag iniziale non è obbligatorio.

Qualunque stringa che inizia con un simbolo `=` nel primo carattere della riga viene
interpretata come markup POD e da inizio a una sezione POD che verrà chiusa con `=cut`

POD permette anche di specificare dei link usando la notazione L&lt;un-link>.

Il testo che si trova all'esterno dei tag di markup viene visualizzato come testo semplice.

Il testo che non inizia al primo carattere della riga viene trattato come verbatim,
ovvero viene visualizzato esattamente come l'avete scritto: le linee lunghe rimangono
lunghe e le linee corrte rimangono corte. È particolarmente utile per gli esempi di codice.

Un punto importante da ricordare è che POD richiede che ci siano delle linee vuote prima e dopo i tag.
So

```perl
=head1 Titolo
=head2 Sottotitolo
Del Testo
=cut
```

non produce il risultato che potreste aspettarvi.

## L'aspetto

Dato che POD è un linguaggio di mark-up non definisce di per sé come le cose debbano essere visualizzate.
Se usate un `=head1` state indicando che qualcosa è importante, `=head2` indica qualcosa di meno importante.

Il tool usato per visualizzare il POD userà generalmente dei caratteri più grandi per il
testo di un head1 che per quello di un head2 e quest'ultimo a sua volta sarà visualizzato con caratteri più grandi del testo
semplice. Il controllo è nelle mani del tool di visualizazione.

Il comando `perldoc` incluso nella distribuzione di perl visualizza il POD come una pagina di man. È piuttosto utile su Linux.
Non altrettanto su Windows.

Il modulo [Pod::Html](https://metacpan.org/pod/Pod::Html) fornisce un altro tool da linea di comando chiamato
`pod2html`. Con esso potete convertire un POD in un documento HTML da visualizzare nel browser.

Ci sono poi altri tool che permettono di generare file pdf o mobi dai POD.

## Chi sono i lettori?

Dopo aver visto la tecnologia, consideriamo chi sono i lettori.

I commenti (quelli che iniziano con un simbolo # ) sono spiegazioni per
i programmatori che fanno manutenzione. Persone che devono aggiungere funzioni
o risolvere bug.

La documentazione scritta in POD è per gli utenti. Persone che non
dovrebbero guardare il codice sorgente. Per un'applicazione essi sono
chiamati utenti finali (in Inglese "end users"). Ovvero chiunque.

Per i moduli Perl, gli utenti sono altri programmatori Perl che vogliono
scrivere applicazioni o altri moduli. ANche in questo caso non dovrebbero
aver bisogno di guardare il vostro codice sorgente. DOvrebbero poter usare
il vostro modulo leggendo soltanto la sua documentazione con il
comando `perldoc`.


## Conclusioni

Scrivere della documentazione e darle un aspetto gradevole non è poi così difficile in Perl.

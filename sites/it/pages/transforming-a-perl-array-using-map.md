---
title: "Trasformare un array con map"
timestamp: 2013-04-25T10:45:56
tags:
  - map
  - transform
  - list
  - array
published: true
original: transforming-a-perl-array-using-map
books:
  - advanced
author: szabgab
translator: grubert65
---


La funzione `map` fornisce un modo semplice per trasformare una
lista di valori in un'altra lista di valori. Di solito questa trasformazione ritorna lo stesso 
numero di valori, anche se è sempre possibile generare una lista con un numero di valodi diverso.


Abbiamo visto che [la funzione grep di Perl](https://perlmaven.com/filtering-values-with-perl-grep) è una generalizzazione del
medesimo comando UNIX. La funzione seleziona alcuni o tutti (o nessuno!) degli elementi dalla 
lista originale, e li ritorna intatti.

La funzione `map`, invece, è utile quando si vogliono cambiare 
i valori della lista originale.

La sintassi è simile. Basta passare alla funzione un blocco di codice ed una lista di valori: un array
o qualche altra espressione che ritorni una lista di valori.
Per ogni elemento della lista originale, il valore è copiato nella variabile `$_`,
[la variabile predefinita di Perl](https://perlmaven.com/the-default-variable-of-perl), ed il blocco
è eseguito. I valori risultanti sono passati alla lista risultante.

## Uso di map per trasformazioni semplici

```perl
my @numbers = (1..5);
print "@numbers\n";       # 1 2 3 4 5
my @doubles = map {$_ * 2} @numbers;
print "@doubles\n";       # 2 4 6 8 10
```

## Costruire tabelle di look-up veloci

Se abbiamo una lista di valori può capitare, durante l'esecuzione del codice, 
di voler controllare se un valore è compreso nella lista. Possiamo usare
[grep](https://perlmaven.com/filtering-values-with-perl-grep) ogni volta, per cercare se il 
valore è nella lista. Possiamo anche usare la funzione [any](https://perlmaven.com/filtering-values-with-perl-grep)
del package [List::MoreUtils](http://metacpan.org/modules/List::MoreUtils),
ma può essere più leggibile e veloce usare una variabile hash per costruire una veloce tabella di look-up.

Possiamo creare una variabile hash una volta sola, dove per chiavi usiamo i valori della lista,
ed i corrispondenti valori sono qualunque cosa che valorizzi a true (quindi 1, "1", ma anche "52" o "Perl rocks!").
Possiamo usare questa variabile hash al posto della funzione `grep`.

```perl
use Data::Dumper qw(Dumper);

my @names = qw(Foo Bar Baz);
my %is_invited = map {$_ => 1} @names;

my $visitor = <STDIN>;
chomp $visitor;

if ($is_invited{$visitor}) {
   print "The visitor $visitor was invited\n";
}

print Dumper \%is_invited;
```

Questo è l'output della chiamata `Dumper` :

```perl
$VAR1 = {
          'Bar' => 1,
          'Baz' => 1,
          'Foo' => 1
        };
```

Come anticipato, il valore che assegnamo agli elementi dell'hash non è importante,
deve semplicemente essere valutato a true in una espressione.

Questa soluzione è interessante solo si accede spesso alla tabella di look-up e per 
un grande set di valori (l'esatto significato di "grande" potrebbe dipendere dal vostro
sistema).
Altrimenti `any` o anche `grep` andranno bene lo stesso.

Come potete vedere in questo esempio, per ogni elemento nell'array originale,
`map` ritorna 2 valori. Il valore originale e 1.

Il codice seguente:

```perl
my @names = qw(Foo Bar Baz);
my @invited = map {$_ => 1} @names;
print "@invited\n"
```

stamperà:

```
Foo 1 Bar 1 Baz 1
```

## La freccia "grassa"

Nel caso ve lo state chiedendo il simbolo `=>` è chiamato la <b>fat arrow</b> or <b>fat comma</b>. Praticamente 
si comporta come una virgola regolare `,` con una eccezione che non è rilevante nel nostro caso. (Per ogni dettaglio
sul suo uso leggetevi l'articolo [Perl hashes](https://perlmaven.com/perl-hashes).)


## Espressioni complesse in map

Potete dare in pasto a map istruzioni più complesse:

```perl
my @names = qw(Foo Bar Baz);
my @invited = map { $_ =~ /^F/ ? ($_ => 1) : () } @names;
print "@invited\n"
```

stamperà:

```
Foo 1
```

Nel blocco abbiamo un operatore ternario che ritorna o una coppia
di valori come prima o una lista vuota. A quanto pare ammettiamo solo
le persone il cui nome inizia con "F".

```perl
$_ =~ /^F/ ? ($_ => 1) : ()
```

## perldoc

Per informazioni ulteriori ed un paio di casi strani,
date una occhiata a [perldoc -f map](http://perldoc.perl.org/functions/map.html).


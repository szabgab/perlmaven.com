---
title: "Bareword in Perl"
timestamp: 2013-05-25T00:00:00
tags:
  - bareword
  - strict
published: true
original: barewords-in-perl
books:
  - beginner
author: szabgab
translator: giatorta
---


`use strict` ha 3 parti. Una di esse, nota anche come `use strict "subs"`,
disabilita gli usi inappropriati delle <b>bareword</b>, identificatori senza sigilli o altra punteggiatura sintatticamente significativa.

Che cosa vuol dire?


Senza questa restrizione il codice seguente funzionerebbe e stamperebbe "hello".

```perl
my $x = hello;
print "$x\n";    # hello
```

È abbastanza curioso, dato che siamo abituati a racchiudere le stringhe tra caratteri di quotatura,
ma per default Perl permette di usare <b>bareword</b> - parole senza quotatura - come se fossero stringhe.

Come abbiamo detto, il codice qui sopra stamperebbe "hello".

Almeno fino a che qualcuno non aggiunge una procedura "hello" all'inizio del
vostro script:

```perl
sub hello {
  return "zzz";
}

my $x = hello;
print "$x\n";    # zzz
```

Ebbene sì. In questa versione, perl vede la procedura hello(), la chiama e assegna
il valore restituito ad $x.

Poi, se qualcuno sposta la procedura alla fine del vostro file,
dopo l'assegnamento, improvvisamente perl non vede più la procedura
quando fa l'assegnamento e siamo da capo, con il valore "hello" in $x.

Non credo che vogliate mettervi in questo tipo di pasticcio per sbaglio. Né per qualunque altro motivo.
Se aggiungete `use strict` al vostro codice, perl non ammette più la presenza della
bareword <b>hello</b>, e vi aiuta a evitare questa confusione.

```perl
use strict;

my $x = hello;
print "$x\n";
```

Questo codice da il seguente errore:

```
Bareword "hello" not allowed while "strict subs" in use at script.pl line 3.
Execution of script.pl aborted due to compilation errors.
```

## Usi leciti delle bareword

Ci sono alcuni posti in cui le bareword possono essere usate anche quando `use strict "subs"`
è attiva.

Anzitutto, i nomi delle procedure che definiamo non sono effettivamente altro che bareword.
E sono certamente un'ottima cosa da avere.

Inoltre, quando ci riferiamo a un elemento di un hash possiamo usare una bareword tra parentesi graffe
e le parole a sinistra dell'operatore "fat arrow" => possono essere lasciate senza quotatura:

```perl
use strict;
use warnings;

my %h = ( name => 'Foo' );

print $h{name}, "\n";
```

Nel codice qui sopra, entrambe le occorrenze di "name" sono bareword,
ma sono ammesse anche se use strict è attiva.



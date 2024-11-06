---
title: "Stringhe in Perl: quotate, interpolate e con escape"
timestamp: 2013-07-26T20:00:00
tags:
  - stringhe
  - '
  - "
  - \
  - carattere di escape
  - interpolazione
  - quotatura
  - caratteri incorporati
  - q
  - qq
published: true
original: quoted-interpolated-and-escaped-strings-in-perl
books:
  - beginner
author: szabgab
translator: giatorta
---


Capire come funzionano le stringhe è importante in ogni linguaggio di programmazione, ma in Perl esse sono
parte dell'essenza del linguaggio. Specialmente se tenete presente che uno degli "acronimi a posteriori" di Perl
è <b>Practical Extraction and Reporting Language</b> ("Linguaggio Pratico per Estrazione e Report"), e per fare questo avete bisogno di molte stringhe.


Le stringhe possono essere racchiuse tra apici singoli `'` o doppi `"` e in base a questo il loro comportamento varia leggermente.

## Stringhe a quotatura singola

Se racchiudete dei caratteri tra apici singoli `'`, quasi tutti,
fatta eccezione per l'apice stesso `'`,
vengono interpretati esattamente come sono scritti nel code.

```perl
my $name = 'Pippo';
print 'Ciao $name, come stai?\n';
```

L'output sarà:

```
Ciao $name, come stai?\n
```

## Stringhe a quotatura doppia

Le stringhe racchiuse tra doppi apici `"` forniscono l'interpolazione
(altre variabili incorporate nella stringa vengono sostituite con il loro contenuto)
e sostituiscono inoltre le sequenze speciali di escape come `\n` e
`\t` rispettivamente con effettivo carattere di a capo e un effettivo tab.

```perl
my $name = 'Pippo';
my $time  = "oggi";
print "Ciao $name,\ncome stai $time?\n";
```

L'output sarà

```
Ciao Pippo,
come stai oggi?

```

Notate che c'è un `\n` subito dopo la virgola nella stringa e un altro alla fine della stringa.

Per stringhe semplici come 'Pippo' e "oggi" che non contengono i caratteri `$`, `@` e `\`
non è importante come vengono quotate.

Le due linee seguenti hanno lo stesso effetto:

```perl
$name = 'Pippo';
$name = "Pippo";
```


## Indirizzi di E-mail

Dato che `@` viene interpolato nelle stringhe a quotatura doppia, scrivere degli indirizzi di e-mail
richiede un po' di attenzione.

Tra apici singoli `@` non viene interpolato.

Tra doppi apici il codice qui sotto genera un errore:
[Global symbol "@pluto" requires explicit package name at ... line ...](/global-symbol-requires-explicit-package-name)
e un warning:
<b>Possible unintended interpolation of @pluto in string at ... line ...</b>

Quest'ultimo ("Possibile interpolazione involontaria di @pluto nella stringa ...") fornisce forse un indizio migliore su quale sia il vero problema.

```perl
use strict;
use warnings;
my $broken_email  = "pippo@pluto.com";
```

Questo codice, invece, avendo racchiuso l'indirizzo e-mail tra apici singoli, funziona.

```perl
use strict;
use warnings;
my $good_email  = 'pippo@pluto.com';
```

E se avete bisogno di interpolare qualche variabile scalare ma volete includere dei caratteri chiocciola `@` nella stringa?

```perl
use strict;
use warnings;
my $name = 'pippo';
my $good_email  = "$name\@pluto.com";

print $good_email; # pippo@pluto.com
```

Potete sempre fare l'<b>escape</b> dei caratteri speciali, in questo caso la chiocciola `@`, usando il cosiddetto <b>carattere di escape</b>
ovvero il carattere back-slash `\`.

## Usare il carattere dollaro $ nelle stringhe a quotatura doppia

In modo simile, se volete usare un carattere `$` in una stringa che per altri motivi è racchiusa tra doppi apici, potete farne l'escape:

```perl
use strict;
use warnings;
my $name = 'pippo';
print "\$name = $name\n";
```

Stampa:

```
$name = pippo
```

## Escape del carattere di escape

In alcuni casi, anche se poco frequenti, potreste voler includere un carattere back-slash in una stringa.
Se inserite un back-slash `\` in una stringa a doppia quotatura,
Perl penserà che vogliate fare l'escape del carattere seguente e metterà in campo le sue magie.

Niente paura. Potete dire a Perl di starsene buono facendo l'escape del carattere di escape:

Dovete semplicemente metterci davanti un altro back-slash:

```perl
use strict;
use warnings;
my $name = 'pippo';
print "\\$name\n";
```

```
\pippo
```

Capisco che questo fare l'escape del carattere di escape possa sembrare un po' strano, ma in linea di massima funziona così anche in tutti gli altri linguaggi.


Se volete capire bene tutta questa faccenda degli escape, provate qualcosa come:

```perl
print "\\\\n\n\\n\n";
```

guardate che cosa stampa:

```
\\n
\n
```

e provate a darvi una spiegazione.

## Escape dei doppi apici

Abbiamo visto come sia possibile includere delle variabili scalari in stringhe con quotatura doppia e come sia invece possibile fare l'escape del sigillo `$`.

Abbiamo visto come usare il carattere di escape `\` e come fare l'escape dell'escape.

E se ora voleste stampare un doppio apice in una stringa a quotatura doppia?


Questo errore contiene un errore di sintassi:

```perl
use strict;
use warnings;
my $name = 'pippo';
print "Il "nome" e' "$name"\n";
```

quando Perl vede il doppio apice prima della parola "nome" pensa che esso delimiti la fine della stringa
e protesta per la presenza della [bareword](/bareword-in-perl) <b>nome</b>.

Come forse avete già indovinato, dobbiamo fare l'escape del carattere `"`:

```perl
use strict;
use warnings;
my $name = 'pippo';
print "Il \"nome\" e' \"$name\"\n";
```

Questo codice stampa:

```
Il "nome" e' "pippo"
```

Funziona, ma non è molto leggibile.


## qq, l'operatore double-q

In questi casi potete usare l'operatore `qq` detto anche operatore double-q:

```perl
use strict;
use warnings;
my $name = 'pippo';
print qq(Il "nome" e' "$name"\n);
```

Per l'occhio inesperto, qq() può sembrare una chiamata di funzione ma non è così. `qq` è un operatore
e vedremo tra un momento che cos'altro può fare; ma prima cerchiamo di spiegarne l'uso fatto qui sopra.

Abbiamo sostituito i doppi apici `"` che racchiudevano la stringa con le parentesi dell'operatore
`qq`. In questo modo i doppi apici non rappresentano più nulla di speciale all'interno della stringa e possiamo evitare di farne l'escape.
Grazie a ciò otteniamo un codice molto più leggibile.
Lo definirei persino bello, se non temessi gli strali dei programmatori Python.

E se ora voleste includere delle parentesi nella vostra stringa?

```perl
use strict;
use warnings;
my $name = 'pippo';
print qq(Il (nome) e' "$name"\n);
```

Nessun problema. Almeno fino a quando le parentesi sono bilanciate
(ovvero, c'è un ugual numero di parentesi aperte `(` e chiuse `)`, e inoltre
ogni parentesi aperta viene prima della corrispondente parentesi chiusa) Perl le
accetta.

Lo so. Ora volete creare un problema mettendo una parentesi chiusa prima di una aperta:

```perl
use strict;
use warnings;
my $name = 'pippo';
print qq(Il )nome( e' "$name"\n);
```

In effetti, perl genererà un errore di sintassi protestando che "nome" è una [bareword](/bareword-in-perl).
Perl non può arrivare a capire tutto da solo, giusto?

Naturalmente potreste fare l'escape delle parentesi nella stringa `\)` e `\(`, ma siamo stati già una volta in quella trappola.
No grazie!

Deve esserci una soluzione migliore!

Vi ricordate che ho detto che `qq` è un operatore e non una funzione? Quindi può permetterci qualche trucco, giusto?

E se sostituissimo le parentesi tonde intorno alla nostra stringa con delle parentesi graffe? `{}`:

```perl
use strict;
use warnings;
my $name = 'pippo';
print qq{Il )nome( e' "$name"\n};
```

Funziona e stampa ciò che ci aspettiamo:

```
Il )nome( e' "pippo"
```

(anche se non ho la minima idea del perché dovrei voler stampare una frase come questa...)

Ed ecco che [il tipo nella seconda fila](http://perl.plover.com/yak/presentation/samples/slide027.html) alza la mano
e vi chiede che cosa succederebbe se voleste sia le parentesi tonde che quelle graffe nella vostra stringa, <b>e</b> voleste che non fossero bilanciate?

Come in questo codice, giusto?

```perl
use strict;
use warnings;
my $name = 'pippo';
print qq[Il )nome} e' "$name"\n];
```

che stampa:

```
Il )nome} e' "pippo"
```


... deve pur esserci un uso anche per le parentesi quadre, o no?


## q, l'operatore single-q

Analogamente a `qq` esiste anche un operatore `q`.
Anch'esso vi permette di scegliere i delimitatori della vostra stringa, ma si comporta
come gli apici singoli `'`: <b>NON</b> interpola le variabili.

```perl
use strict;
use warnings;
print q[Il )nome} e' "$name"\n];
```

stampa:

```
Il )nome} e' "$name"\n
```



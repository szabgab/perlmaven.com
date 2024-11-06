---
title: "Use of uninitialized value"
timestamp: 2013-08-04T21:45:56
tags:
  - undef
  - uninitialized value
  - $|
  - warnings
  - buffering
published: true
original: use-of-uninitialized-value
books:
  - beginner
author: szabgab
translator: mca
---


Das ist eine der meistverbreiteten Warnungen, die Dir beim Ausführen von Perl-Code begegenen wird.

Es ist eine Warnung, die die Programmausführung nicht beeinträchtigt und nur dann generiert
wird, wenn Warnungen eingeschaltet wurden. Was auch empfohlen ist.

Der gängiste Weg Warnungen einzuschalten ist die Anweisung `use warnings;` am
Anfang des Skripts oder Moduls einzufügen.


Der ältere Weg ist das Hinzufügen der `-w`-Option an die She-Bang-Zeile. Das
sieht normalerweise als erste Zeile im Skript so aus:

`#!/usr/bin/perl -w`

Es gibt bestimmte Unterschiede. Aber nachdem es nun `use warnings` rund 12 Jahre
gibt, gibt es keinen Grund, dies nicht zu verwenden. Anders ausgedrückt:

Benutze immer: `use warnings;`!

Lass uns zurückkehren zu der eigentlichen Warnung, die ich erklären wollte.

## Eine schnelle Erklärung

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.
```

Das bedeutet, die Variable `$x` hat keinen Wert (der Wert ist der spezielle Wert `undef`).
Entweder sie hatte nie einen Wert oder zu irgendeinem Punkt wurde  `undef` zugewiesen.

Du solltest die Stellen identifizieren, an denen die Variable zuletzt Werte zugewiesen
bekommen hat. Oder Du solltest herausfinden, warum der Codestrang nie ausgeführt wurde.

## Ein einfaches Beispiel

Das nachfolgende Beispiel wird eine solche Warnung generieren:

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
```

Perl ist sehr nett. Es sagt uns, welche Datei auf welcher Zeile die Warnung verursacht.

## Nur eine Warnung

Wie schon gesagt, es nur eine Warnung. Sollte das Skript nach der `say`-Anweisung mehr
Anweisungen haben, würden diese ausgeführt.

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
$x = 42;
say $x;
```

Das würde folgendes ausgeben:

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.

42
```

## Verwirrende Ausgabereihenfolge

Gib jedoch acht: Wenn Dein Code print-Anweisungen vor der Stelle hat,
die die Warnung auslöst, wie im nachfolgenden Beispiel:

```perl
use warnings;
use strict;
use 5.010;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

ist die Ausgabe möglicherweise verwirrend.

```
Use of uninitialized value $x in say at perl_warning_1.pl line 7.
OK
42
```

Das Ergebnis 'OK' der `print`-Anweisung erscheint <b>nach</b>
der Warnung, obwohl sie <b>vor</b> der Codestelle liegt, die die
Warnung verursacht.

Diese Eigenart ist das Ergebnis des `IO-Bufferings`.
Im Standard puffert Perl STDOUT, den Standard-Ausgabe-Kanal,
während es STDERR, den Standard-Fehler-Kanal, nicht puffert.

Also, während das Wort 'OK' darauf wartet, dass der Ausgabekanal
geleert (geflusht) wird, hat die Warnmeldung den Bildschirm
schon erreicht.

## Puffern abschalten

Um genau das zu vermeiden, kannst Du das Puffern von STDOUT abschalten.

Das kann durch folgenen Code zu Beginn des Skripts erfolgen:
`$| = 1;`


```perl
use warnings;
use strict;
use 5.010;

$| = 1;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

```
OKUse of uninitialized value $x in say at perl_warning_1.pl line 7.
42
```

(Die Warnung ist auf der gleichen Zeile wie das <b>OK</b>, weil wir keine neue Zeile <h1>\n</h1> nach dem OK ausgegeben haben.)

## Der ungewollte Scope

```perl
use warnings;
use strict;
use 5.010;

my $x;
my $y = 1;

if ($y) {
  my $x = 42;
}
say $x;
```

Dieser Code produziert ebenfalls `Use of uninitialized value $x in say at perl_warning_1.pl line 11.`

Ich habe es fertiggebracht, diesen Fehler merfach zu machen. Unbedacht habe ich `my $x`
innerhalb eine Blocks verwendet, so dass ich eine zusätzliche Variable $x erzeugt habe,
dieser 42 zuwies und dann die Variable am Ende des Blocks aus dem Scope gehen ließ.
(Das  $y = 1 ist nur ein Platzhalter für ein wenig realen Codes und einer realen Bedingung.
Es ist nur dazu da, den Code ein wenig realistischer erscheinen zu lassen.)

Es gibt natürlich Fälle, in denen es sinnvoll ist, eine Variable innerhalb eines Blocks zu deklarieren.
Wenn ich das aus versehen mache, dann ist es ein Fehler, der nur sehr schmerzlich zu finden ist.

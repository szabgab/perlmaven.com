---
title: "Scalar found where operator expected"
timestamp: 2013-08-05T01:05:06
tags:
  - syntax error
  - scalar found
  - operator expected
published: true
original: scalar-found-where-operator-expected
books:
  - beginner
author: szabgab
translator: mca
---


Das ist wirklich eine weit verbreitete Fehlermeldung, die ich sehe. Eine, die - so scheint es mir -
ein wenig schwer zu verstehen ist.

Tatsache ist, dass Leute an <b>numerische Operatoren</b> und <b>Zeichenketten-Operatoren</b>
denken, aber nicht an das Komma `,` als Operator. Für diese ist die Terminologie
der Fehlermeldung ein wenig verwirrend.

Lasst uns ein paar Beispiele ansehen:


## Fehlendes Komma

Der Code sieht folgendermaßen aus:

```perl
use strict;
use warnings;

print 42 "\n";
my $name = "Foo";
```

und die Fehlermeldung ist:

```
String found where operator expected at ex.pl line 4, near "42 "\n""
      (Missing operator before  "\n"?)
syntax error at ex.pl line 4, near "42 "\n""
Execution of ex.pl aborted due to compilation errors.
```

Es wird ganz klar angegeben, auf welcher Zeile das Problem ist. Ich sehen schon vor mir,
wie viele Leute gleich zum Editor greifen, um den Fehler zu beheben, obwohl sie
die Fehlermeldung nicht gelesen haben. Sie werden eine Änderung durchführen in der
Hoffnung, dass dies den Fehler beheben wird, um danach eine andere Fehlermeldung
zu erhalten.

In diesem Fall bestand der Fehler darin, dass wir vergessen haben ein Komma `,` nach
der Nummer 42 einzufügen. Die korrekte Anweisungszeile sollte so aussehen: `print 42, "\n";`


## String found where operator expected

Im nachfolgenden Code haben wir den Zeichenkettenverbindungs-Operator  `.` vergessen, womit wir
die gleiche Fehlermeldung bekommen:

```perl
use strict;
use warnings;

my $name = "Foo"  "Bar";
```

```
String found where operator expected at ex.pl line 4, near ""Foo"  "Bar""
      (Missing operator before   "Bar"?)
syntax error at ex.pl line 54, near ""Foo"  "Bar""
Execution of ex.pl aborted due to compilation errors.
```

Der eigentlich gewünschte Code sieht so aus: `my $name = "Foo" . "Bar";`.

## Number found where operator expected

```perl
use strict;
use warnings;

my $x = 23;
my $z =  $x 19;
```

Verursacht folgende Fehlermeldung:

```
Number found where operator expected at ex.pl line 5, near "$x 19"
  (Missing operator before 19?)
syntax error at ex.pl line 5, near "$x 19"
Execution of ex.pl aborted due to compilation errors.
```

Diesem Code fehlt vielleicht ein Additionsoperator `+` oder einen Multiplikationsoperator
`*`, obwohl es auch der Wiederholungsoperator `x` sein könnte.

## Syntax-Fehler bei einem vergessenen Komma

Ein fehlendes Komma wird nicht immer als fehlender Operator erkannt.
Z.B. dieser Code:

```perl
use strict;
use warnings;

my %h = (
  foo => 23
  bar => 19
);
```

verursacht die folgende Fehlermeldung: <b>syntax error at ... line ..., near "bar"</b>
ohne weitere Details zu nennen.

Das Einfügen eines Kommas nach der Zahl 23 behebt den Fehler.

```perl
my %h = (
  foo => 23,
  bar => 19
);
```

Ich bevorzuge es sogar, ein Komma nach jedem Hash-Paar einzufügen, also im obigen Beispiel auch nach
der Nummer 19.

```perl
my %h = (
  foo => 23,
  bar => 19,
);
```

Diese Angewohnheit hilft mir, diese Art von Fehlern in den meisten Fällen zu
vermeiden.


## Scalar found where operator expected at

```perl
use strict;
use warnings;

my $x = 23;
my $y = 19;

my $z =  $x $y;
```

```
Scalar found where operator expected at ... line 7, near "$x $y"
    (Missing operator before $y?)
syntax error at ... line 7, near "$x $y"
Execution of ... aborted due to compilation errors.
```

Ein weiteres Mal könnte zwischen $x und $y sowohl ein numerischer wie auch
ein Zeichenketten-Operator sein.

## Array found where operator expected

```perl
use strict;
use warnings;

my @x = (23);
my $z =  3 @x;
```

## Welchen anderen Fällen begegnest Du häufiger?

Hast Du andere interessante Fälle, in denen wir diese Art von Fehlermeldung
erhalten?

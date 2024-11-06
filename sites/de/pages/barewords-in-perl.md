---
title: "Barewords in Perl"
timestamp: 2013-08-05T10:44:56
tags:
  - bareword
  - strict
published: true
original: barewords-in-perl
books:
  - beginner
author: szabgab
translator: mca
---


`use strict` hat drei Teile. Einer davon, der auch `use strict "subs"` genannt wird,
unterbindet das unerlaubte Verwenden von <b>barewords</b>.

Was bedeutet das?


Ohne diese Einschränkung würde Code wie der nachfolgende funktionieren und ein "hello" ausgeben.

```perl
my $x = hello;
print "$x\n";    # hello
```

Das wirkt ein wenig befremdlich, nachdem wir gewohnt sind, Zeichenketten
in Anführungszeichen zu setzen. Aber Perl erlaubt es standardmäßig,
dass sich sog. <b>barewords</b> - Wörter ohne Anführungszeichen - wie
Zeichenketten verhalten.

Der obige Code würde "hello" ausgeben.

Zumindest solange, bis jemand die Funktion mit den Namen "hello" am Anfang des
Skripts einfügen würde.

```perl
sub hello {
  return "zzz";
}

my $x = hello;
print "$x\n";    # zzz
```

Ja, in dieser Version erkennt Perl die hello()-Funktion, ruft diese auf und
weist der Variablen $x den Rückgabewert zu.

Würde hingegen jemand die Funktion ans Ende der Datei und somit an eine Stelle 
nach der Zuweisung verschieben, würde Perl die Funktion zum Zeitpunkt der 
Zuweisung nicht sehen und der Variablen $x 'hello' zuweisen.

Nein, Du möchtest sicherlich nicht zufällig in ein solches Durcheinander geraten.
Sobald Du `use strict` in Deinem Code hast, wird Perl das sog.
bareword <b>hello</b> nicht erlauben. Und somit solch ein Durcheinander vermeiden.

```perl
use strict;

my $x = hello;
print "$x\n";
```

Gibt folgende Fehlermeldung aus:

```
Bareword "hello" not allowed while "strict subs" in use at script.pl line 3.
Execution of script.pl aborted due to compilation errors.
```

## Sinnvoller Einsatz von barewords

Es gibt andere Stellen, an denen barewords verwendet werden können, obwohl `use strict "subs"`
im Einsatz ist.

Zuallererst sind die Namen von Funktionen, die wir angelegt haben, nur barewords.
Und das ist gut so.

Ebenfalls können wir  barewords beim Zufriff auf Hash-Werte verwenden, wenn sie in geschweiften
Kalmmen stehen. Zusätzlch können Wörter, die links von einem sog. Fat-Arrow (=>) stehen,
ohne Anführungszeichen verwendet werden.

```perl
use strict;
use warnings;

my %h = ( name => 'Foo' );

print $h{name}, "\n";
```

In both cases in the above code "name" is a bareword,
but these are allowed even when use strict is in effect.

In beiden Fällen im obigen Code ist  "name" ein bareword,
welches erlaubt ist, selbst wenn  `use strict` im
Einsatz ist.

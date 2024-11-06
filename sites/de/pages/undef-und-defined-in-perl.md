---
title: "undef, der initiale Wert und die defined-Funktion in Perl"
timestamp: 2013-08-05T23:15:56
tags:
  - undef
  - defined
published: true
original: undef-and-defined-in-perl
books:
  - beginner
author: szabgab
translator: mca
---


In einigen Programmiersprachen gibt es einen expliziten Weg, um zu sagen: "Dieses Feld hat keinen Wert".
In <b>SQL</b>, <b>PHP</b> und <b>Java</b> ist es `NULL`. In <b>Python</b> ist es `None`.
In <b>Ruby</b> wird es `Nil` genannt.

In Perl wird dieser Wert `undef` genannt.

Lass uns einige Details ansehen.


## Woher erhälst Du den Wert undef?

Wenn Du einen skalaren Wert deklarierst und keinen Wert zuweist, wird der inhalt der wohldefinierte Wert `undef` sein.

```perl
my $x;
```

Einige Funktionen geben `undef` zurück, um einen Fehler anzuzeigen.
Andere geben  `undef` zurück, wenn sie sonst nichts sinnvolles
zurückgeben können.

```perl
my $x = do_something();
```

Du kannst die Funktion `undef()` benutzen, um den Inhalt einer Variablen auf den Wert `undef` zurückzusetzen.

```perl
# some code
undef $x;
```

Du kannst sogar den Rückgabewert der `undef()`-Funktion verwenden, um eine Variable auf `undef` zu setzen: 

```perl
$x = undef;
```

Die Klammern nach dem Funktionsnamen sind optional und deshalb habe ich sie in diesem
Beispiel weggelassen.

Wie Du sehen kannst, gibt es verschiedene Wege, um einer Variablen den Wert <b>undef</b> zuzuweisen.
Die Frage ist, was passiert, wenn man eine solche Variable benutzt?

Davor lass uns erst etwas anderes ansehen:

## Wie prüft man, ob eine Variable den Wert undef hat?

Die Funktion `defined()` gibt den Wert [true](/boolesche-werte-in-perl) 
zurück, wenn der übergebene Wert <b>nicht undef</b> ist. Sie wird [false](/boolesche-werte-in-perl)
zurückgeben, wenn der Wert <b>undef</b> ist.

Du kannst dies so benutzen:

```perl
use strict;
use warnings;
use 5.010;

my $x;

# einger Code der eventuell $x setzt

if (defined $x) {
    say '$x is defined';
} else {
    say '$x is undef';
}
```


## Was ist der tatsächliche Wert von undef?

Während <b>undef</b> das Fehlen eines Werts anzeigt, ist er dennoch benutzbar.
Perl stellt zwei nutzbare Standardwerte zur Verfügung, die anstelle von undef genutzt werden können.

Wenn Du eine Variable, die undef ist, in einer numerischen Operation verwendest, dann wird 0 angenommen.

Wenn Du den Wert in einer Zeichenkettenoperation anwendest, dann wird die leere Zeichenkette angenommen.

Sch Dir das nachfolgende Beispiel an:

```perl
use strict;
use warnings;
use 5.010;

my $x;
say $x + 4, ;  # 4
say 'Foo' . $x . 'Bar' ;  # FooBar

$x++;
say $x; # 1
```

Im obigen Beispiel agiert die Variable $x, die standardmäßig undef ist, in der Addition (+) als 0.
Sie agiert als leere Zeichenkette in der Zeichenketten-Verknüpfung (.) und nochmals als 0 im
Kontext des Autoinkrement-Operators.

Das geht nicht ohne Warnungen einher, wenn Du Warnmeldungen mit der Anweisung `use warnings`
eingeschaltet hast ([Was immer empfohlen wird](/installation-und-ein-anfang-mit-perl)).
In diesem Fall würdest Du zweimal [use of uninitialized value](/use-of-uninitialized-value)
für die ersten beiden Operationen erhalten, aber nicht für die Auto-Inkrement-Operation.

```
Use of uninitialized value $x in addition (+) at ... line 6.
Use of uninitialized value $x in concatenation (.) or string at ... line 7.
```

Ich gehe davon aus, dass Du die Meldung für die Auto-Inkrement-Operation nicht bekommst, weil Perl
nachsichtig ist. Später wirst Du sehen, dass dies sehr praktisch ist an Stellen, wo Du Dinge
zählen willst.

Du kannst die Warnungen natürlich vermeiden, wenn Du die Variable auf den richtigen Wert initialisierst
(0 oder die leere Zeichenkette, abhängig davon, was es sein müsste). Du kannst aber auch Warnungen selektiv 
abschalten. Wir werden dies in einem eigenen Artikel klären.

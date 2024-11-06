---
title: "Name 'main::x' used only once: possible typo at ..."
timestamp: 2013-08-05T09:31:10
tags:
  - warnings
  - strict
  - eventueller Schreibfehler
published: true
original: name-used-only-once-possible-typo
books:
  - beginner
author: szabgab
translator: mca
---


Wenn Du diese Warnung in einem Perl-Skript siehst, hast Du große Probleme.


## Zuweisung zu einer Variablen

Einer Variablen etwas zuweisen und dann diese nie zu verwenden oder
eine Variable zu verwenden, ohne jemals einen Wert zugewiesen zu haben,
ist sehr selten richtig in einem Perl-Skript.

Vielleicht der einzige "legitime" Einsatz ist der Fall, in dem Du
eine Variable falsch schreibst, und Du deshalb diese nur einmal verwendest.

Hier ist Beispielcode, in dem wir nur eine <b>Wertzuweisung vornehmen</b>.

```perl
use warnings;

$x = 42;
```

Das wird eine Warnung, wie diese ausgeben:

```
Name "main::x" used only once: possible typo at ...
```

Dieser Teil "main::" und das nichtvorhandensein von '$' mag für Dich 
etwas verwirrend sein. Der Teil "main::" ist da, weil standardmäßig
jede Variable zum Namensraum 'main' gehört. Zusätzlich können eine
ganze Reihe von Dingen  "main::x" genannt werden und nur eines davon
hat ein '$' am Anfang. Keine Angst, wenn sich das etwas verwirrend
anhört. Es ist tatsächlich verwirrend, habe Du wirst hoffentlich
nicht alzulange damit zu tun haben.

## Einen Wert nur abfragen

Wenn es bei Dir zu einem <b>use a variable only once</b> kommt

```perl
use warnings;

print $x;
```

dann wirst du eventuell zwei Warnungen erhalten.

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

Eine davon, werden wir jetzt erläutern, die andere im Artikel
[Use of uninitialized value](/use-of-uninitialized-value).


## Worin besteht der Schreibfehler?

Wirst Du eventuell fragen.

Stell Dir vor, irgendjemand verwendet eine Variable mit dem Namen `$l1`.
Später willst Du die Variable wiederverwenden und Du schreibst `$ll`.
Abhängig vom verwendeten Font sehen beide Namen sehr ähnlich aus.

Oder vielleicht wurde ein Variable `$color` genannt, aber Du hast
einen britisch englischen Hintergrund, weswegen Du automatisch `$colour`
schreibst, wenn es um Fraben geht.

Oder eine Variable wurde `$number_of_misstakes` genannt und Du bemerkst
den Fehler in der originalen Variable nicht, weswegen Du `$number_of_mistakes`
schreibst.

Du hast nun eine Vorstellung.

Wenn Du Glück hast, dann machst Du den Fehler genau einmal. Wenn Du nicht soviel
Glück hast, benutzt Du die falsche Schreibweise zweimal und die Warnung erscheint
nicht. Unabhängig davon, wenn Du eine Variable zweimal verwendest, wirst Du einen
guten Grund dafür haben.

Also, wie kann Du das vermeiden?

Erstens, vermeide Variablennamen mit nicht eindeutigen Buchstaben und sei
sehr vorsichtigm wenn Du Variablennamen schreibst.

Wenn Du es wirklich lösen willst, verwende einfach <b>use strict</b>!

## use strict

Wie Du in den obigen Beispielen sehen kannst, habe ich 'use strict' nicht verwendet.
Wenn ich es verwendet hätte, hätte ich anstelle der Warnung über einen möglichen
Schreibfehler diesen Kompilierungsfehler erhalten:
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)

Dies wäre auch dann geschehen, wenn Du die falsch geschriebene Variable mehr als
einmal verwendet hättest.

Dann gibt es natürlich Leute, die ganz schnell ein "my" vor die Variable schreiben
würden. Du bist hoffentlich keiner von diesen? Du würdest über das Problem nachdenken und
den richtigen Variablennamen finden.

Am häufigsten sieht man diese Warnung, wenn man "use strict" nicht verwendet.

Aber dann hast Du eh größere Probleme.


## Andere Fälle während "use strict" aktiv ist

Wie GlitchMr und ein anonymer Kommentator dargelegt haben, gibt es noch einige andere Fälle:

Dieser Code kann die Warnung auch hevorrufen

```perl
use strict;
use warnings;

$main::x = 23;
```

Die Warnung ist: <b>Name "main::x" used only once: possible typo ...</b>

Zumindest hier wird klar, woher das 'main' kommt, bzw. woher im nächsten Beispiel
der 'Mister' herkommt. Im nächsten Beispiel ider der Paketname 'Mister'.

```perl
use strict;
use warnings;

$Mister::x = 23;
```

Die Warnung ist <b>Name "Mister::x" used only once: possible typo ...</b>.

Das nächste Beispiel erzeugt ebenfalls die Warnung, diesmal sogar zweimal:

```perl
use strict;
use warnings;

use List::Util qw/reduce/;
print reduce { $a * $b } 1..6;
```

```
Name "main::a" used only once: possible typo at ...
Name "main::b" used only once: possible typo at ...
```

Das passiert, weil `$a` und `$b` Spezialvariablen
in der eingebauten Funktion 'sort' sind, die daher nicht
deklariert werden. Genutzt werden sie tatsächlich nur einmal.
(Tatsächlich ist mir nicht klar, warum das die Warnungen generiert,
während der gleiche Code, der 'sort' verwendet, keine Warnung 
ausgibt. Aber die [Perl Monks](http://www.perlmonks.org/?node_id=1021888)
wissen es vielleicht.

---
title: "Global symbol requires explicit package name"
timestamp: 2013-08-05T08:40:56
tags:
  - strict
  - my
  - package
  - global symbol
published: true
original: global-symbol-requires-explicit-package-name
books:
  - beginner
author: szabgab
translator: mca
---


 <b>Global symbol requires explicit package name</b> ist eine gängige,
und m.E.n. sehr irreführende Fehlermeldung in Perl. Zumindest für Anfänger.

Die schnelle Übersetzung wäre: "Du musst die Variable mit <b>my</b> deklarieren."


## Das einfachste Beispiel

```perl
use strict;
use warnings;

$x = 42;
```

Und die Fehlermeldung ist:

```
Global symbol "$x" requires explicit package name at ...
```

Obwohl die Fehlermledung richtig ist, ist sie für
Perl-Anfänger wenig hilfreich. Sie haben vielleicht noch
nicht gelernt, was "Packages" sind. Noch weniger wissen
sie, was expliziter sein sollte, als ein $x.

Diese Fehlermeldung wird von  <b>use strict</b> ausgelöst.

Die Erklärung in der Dokumentation ist diese:

<i>
Dies löst einen Compile-Time-Fehler aus, wenn auf eine Variable zugegriffen wird,
die zuvor nicht mit "our" oder "use vars" deklariert, oder via "my()" lokalisiert
oder vollständig qulifiziert wurde.
</i>

Ein Anfänger wird hoffentlich jedes Skript mit <b>use strict</b> beginnen und
über <b>my</b> vor allen anderen bestehenden Möglichkeiten lernen.

Ich weiß nicht, ob die aktuelle Fehlerbeschreibung geändert werden kann oder geändert werden sollte.
Das ist nicht der Inhalt dieses Artikels. Der Sinn besteht darin, Anfängern in ihrer eigenen
Sprache verstehen zu lassen, was diese Fehlermeldung bedeutet.

Um die obige Fehlermeldung zu unterdrücken, musst Du folgendes schreiben:

```perl
use strict;
use warnings;

my $x = 42;
```

Das bedeutet: Man muss eine <b>Variable deklarieren bevor sie verwendet wird.</b>

## Die schlechte Lösung

Die andere "Lösung" wäre, <b>strict</b> zu löschen:

```perl
#use strict;
use warnings;

$x = 23;
```

Das würde funktionieren, aber der Code würde die Warnung [Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo)
ausgeben.

Unabhängig davon, normalerweise würdest Du ein Auto nicht ohne Sicherheitsgurt fahren. Oder doch?

## Beispiel 2: scope

Ein anderer Fall, den ich oft von Anfängern sehe, ist dieser:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
my $y = 2;
}

print $y;
```

Die Fehlermeldung, die wir bekommen, ist die gleiche wie oben:

```
Global symbol "$y" requires explicit package name at ...
```

Das ist für viele Leute überrachend. Vor allem, wenn sie gerade zu programmieren begonnen haben.
Und das, obwohl sie `$y` mit `my` deklariert haben.

Zuerst einmal gibt es hier ein visuelles Problem. Die Einrückung der Zeile `my $y = 2;` ist falsch.
Wenn die Zeile mit ein paar Leerzeichen oder einem Tabulatorzeichen - wie im nächsten Beispiel gezeigt - eingerückt worden wäre,
wäre die Ursache des Fehlers deutlicher geworden.

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
}

print $y;
```

Das Problem ist, dass die Variable `$y` innerhalb eines Blocks (innerhalb zweier
geschwungener Klammern) deklariert wurde, was dazu führt, dass sie außerhalb des Blocks
nicht existiert. Das wird als der <a href="https://perlmaven.com/scope-of-variables-in-perl"><b>Scope</b> einer Variable</a> bezeichnet.

Das Grundprinzip des <b>Scopes</b> ist von Programmiersprache zu Programmiersprache verschieden.
In Perl wird ein Scope durch einen Block innerhalb geschweifter Klammern gebildet.
Was mit `my` innerhalb eines Blocks deklariert wird, ist außerhalb nicht erreichbar.

(Übrigens: Die Zeile `$x = 1` ist hier nur, um eine legitim aussehende Bedingung zu schaffen.
Mit anderen Worten: `if ($x) {` ist nur da, um das Beispiel echt aussehen zu lassen.)

Die Lösung ist entweder die `print`-Anweisung innerhalb des Blocks zu plazieren:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
    print $y;
}
```

oder die Variable außerhalb des Blocks zu deklarieren.

```perl
use strict;
use warnings;

my $x = 1;
my $y;

if ($x) {
    $y = 2;
}

print $y;
```

Welchen Weg Du einschlagen wirst, ist von der tatsächlichen Aufgabe abhängig. Das hier sind nur die
syntaktisch richtigen Lösungen.

Desweiteren, wenn wir vergessen `my` innerhalb des Blocks zu löschen oder wenn `$x`
'false' ist, dann erhalten wir eine [Use of uninitialized value](/use-of-uninitialized-value)-Warnung.

## Die anderen Möglichkeiten

Die Erklärung für `our` und `use vars`, oder auch wie
eine Varaible vollständig qulifiziert werden kann, ist für einen anderen Artikel vorgesehen.

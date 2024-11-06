---
title: "Unknown warnings category"
timestamp: 2013-08-05T10:45:56
tags:
  - ;
  - warnings
  - unknown warnings
published: true
original: unknown-warnings-category
books:
  - beginner
author: szabgab
translator: mca
---


Ich denke, dass es sich hierbei um keine häufig auftretende Fehlermeldung in Perl handelt.
Zumindest kann ich mich nicht erinnern, das jemals zuvor gesehen zu haben.
Aber kürzlich strauchelte ich darüber in einem meiner Perl-Übungsklassen.


## Unknown warnings category '1'

Die vollständige Fehlermeldung hat folgendermaßen ausgesehen:

```
Unknown warnings category '1' at hello_world.pl line 4
BEGIN failed--compilation aborted at hello_world.pl line 4.
Hello World
```

Das war sehr beunruhigend, vor allem, weil der Code wirklich einfach war.

```
use strict;
use warnings

print "Hello World";
```

I stared at the code quite a lot and have not seen any problem with it.
As you can also see, it already printed the "Hello World" string.

Ich habe den Code angestarrt und kein Problem darin erkennen können.
Wie Du auch sehen kannst, hat es sogar die Zeichenkette "Hello World"
ausgegeben.

Ich habe mich täuschen lassen und es dauerte ein Weile, bis
ich bemerkte, was Du viellicht schon längst bemerkt hast:

Das Problem ist das fehlende Semikolon nach der Anweisung `use warnings`.
Perl führt die print-Anweisung aus, gibt damit die Zeichenkette aus und
gibt den Wert 1 zurück, der anzeigt, dass die print-Anweisung korrekt
ausgeführt wurde.

Perl geht davon aus, dass ich `use warnings 1` geschrieben habe.

Es gibt wirklich viele Warnungskategorien, aber keine davon wurde "1" genannt.

## Unknown warnings category 'Foo'

Das ist ein weiteres Beispiel für das gleiche Problem.

Die Fehlermeldung sieht exemplarisch folgendermaßen aus:

```
Unknown warnings category 'Foo' at hello.pl line 4
BEGIN failed--compilation aborted at hello.pl line 4.
```

und der Beispiel-Code zeigt, wie Zeichenketten-Interpolation funktioniert.
Es handelt sich hierbei um das zweite Beispiel, dass ich nach dem
"Hello World" lehre.

```perl
use strict;
use warnings

my $name = "Foo";
print "Hi $name\n";
```

## Fehlendes Semikolon

Natürlich sind das alles nur Spezialfälle vom generischen
Problem, dass das Semikolon vergessen wurde. Perl kann es
nur bei der nächsten Anweisung  erkennen.

Es ist grundsätzlich ratsam, sich auch die Zeile vor derjenigen
anzusehen, die in der Fehlrmeldung genannt wurde. Vielleicht
ist es nur ein vergessenes Semikolon.

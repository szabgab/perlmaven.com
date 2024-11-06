---
title: "Automatische Zeichenkette-zu-Nummer-Konvertierung oder Casting in Perl"
timestamp: 2013-08-06T08:45:56
tags:
  - is_number
  - looks_like_number
  - Scalar::Util
  - Casting
  - Typ-Konvertierung
published: true
original: automatic-value-conversion-or-casting-in-perl
books:
  - beginner
author: szabgab
translator: mca
---


Stelle Dir vor, Du schreibst eine Einkaufliste wie diese

```
"2 Laib Brot"
```

und gibst diese an Deinen Lebensgefährten weiter, der
Dir sofort einen "Unzulässige-Typ-Konvertierungsfehler"
ins Gesicht schmettert. Im Grund ist "2" eine Zeichenkette
und keine Nummer.

Das wäre frustrierend, oder?


## Typ-Konvertierungen in Perl

In den meisten Programmiersprachen bestimmt der Typ der Operanden wie sich ein Operator
verhält. D.h. das <i>Addieren</i> zweier Zahlen führt eine numerische Addition aus, während das
<i>Addieren</i> zweier Zeichenketten diese beiden zusammenfügt. Diese Eigenschaft nennt
man Operator-Überladen.

Perl arbeitet meistens genau anders herum.

In Perl bestimmt der Operator, wie die Operanden benutzt werden.

Das bedeutet, wenn Du eine numerische Operation benutzt (z.B. die Addition), dann
werden beide Operaden automatisch in Nummern umgewandelt. Wenn Du hingegen eine
Zeichenketten-Operation (z.B. Zusammenfügen) benutzt, dann werden beide Werte
automatisch in Zeichenketten umgewandelt.


C-Programmierer würden diese Konvertierung wahrscheinlich <b>Casting</b> nennen,
aber diese Bezeichnung wird in der Perl-Welt nicht benutzt. Vielleicht deshalb,
weil das ganze automatisch passiert. (Anmerkung des Übersetzers: Casting
ist ein gängiger Begriff in der Informatik und bedeutet
[Typumwandlung](http://de.wikipedia.org/wiki/Typumwandlung).)

Perl macht es nichts aus, ob Du etwas wie eine Zahl oder eine Zeichenkette
schreibst. Es konvertiert zwischen den beiden Darstellungen automatisch
basierend auf dem Kontext.

Die Konvertierung von `Nummer => Zeichenkette` ist einfach.
Man muss sich nur vorstellen, das Anführungszeichen um den Zahlenwert
geschrieben werden müssen.

Die Konvertierung von `Zeichenkette => Nummer` lässt Dich vielleicht
ein wenig nachdenken. Wenn eine Zeichenkette für Perl wie eine Nummer aussieht,
dann ist es einfach. Der numerische Wert ist genau das gleiche. Einfach ohne
Anführungszeichen.

Wenn jedoch irgendein Zeichen enthalten ist, das Perl davon abhält die vollständige
Zeichenkette in eine Nummer zu verwandeln, wird Perl versuchen, von der linke Seite 
kommend so viel wie möglich in eine Zahl zu verwandeln, und den Rest verwerfen.

Lass mich eine Reihe von Beispielen zeigen:

```
Original  Als Zeichen-  Als Nummer
              kette

  42         "42"        42
  0.3        "0.3"       0.3
 "42"        "42"        42
 "0.3"       "0.3"       0.3

 "4z"        "4z"        4        (*)
 "4z3"       "4z3"       4        (*)
 "0.3y9"     "0.3y9"     0.3      (*)
 "xyz"       "xyz"       0        (*)
 ""          ""          0        (*)
 "23\n"      "23\n"      23
```

In allen Fällen, in der die Konvertierung nicht perfekt ist, wird Perl eine
Warnung ausgeben außer im letzten Fall. Natürlich nur unter der Annahme, dass
Du - wie empfohlen - `use warnings;` benutzt hast.

## Beispiel

Nun, nachdem Du die Tabelle gesehen hast, seh es Dir im Code an:

```perl
use strict;
use warnings;

my $x = "4T";
my $y = 3;

```

Zeichenketten-Verknüpfung konvertiert beide Werte zu einer Zeichenkette:

```perl
print $x . $y;    # 4T3
```

Numerische Addition konvertiert beide Werte in eine Nummer:

```perl
print $x + $y;  # 7
                # Argument "4T" isn't numeric in addition (+) at ...
```

## Argument isn't numeric

Das ist die Fehlermeldung, die Du erhälst, wenn es Perl
nicht gelingt, eine Zeichenkette vollständig in eine Zahl
zu konvertiern.

Es gibt eine Reihe von gängigen Warnungen und Fehler in Perl.
Zum Beispiel [Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)
und [Use of uninitialized value](/use-of-uninitialized-value).

## Wie können die Warnungen vermieden werden?

Es ist schön, dass Perl Dich warnt (wenn gewünscht), wenn die Typ-Konvertierung nicht vollständig durchgeführt werden konnte.
Aber gibt es denn nicht eine Funktion, wie  <b>is_number</b>, die überprüft, ob eine Zeichenkette wirklich eine Nummer ist?

Ja und Nein.

Perl hat keine <b>is_number</b>-Funktion, da dies eine Art Eingeständnis der Perl-Entwickler wäre, dass diese
wüssten, was eine Nummer ist. Leider kann sich der Rest der Welt nicht exakt darauf einigen. Es gibt Systeme,
in denen ist ".2" eine akzeptierte Zahl, aber auch andere, in der diese Repräsentation nicht erlaubt ist.
Noch gängiger ist, dass "2." nicht akzeptiert wird, aber in auch dort gibt es Systeme, wo diese Zeichenkette als Zahl zulässig ist.

Es gibt sogar Stellen, an denen 0xAB als Zahl interpretiert wird. Eine hexadezimale Zahl.

Es gibt keine <b>is_number</b>-Funktion, aber es gibt eine weniger verbindliche Funktion, die <b>looks_like_number</b> heißt.

Es ist exakt das, was Du glaubst. Sie prüft, ob die übergebene Zeichenkette für Perl wie eine Zahl aussieht.

Sie wird durch das Modul [Scalar::Util](http://perldoc.perl.org/Scalar/Util.html) bereitgestellt
und kann wie folgend benutzt werden:

```perl
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

print "Wie viele laib Brot soll ich kaufen? ";
my $loaves = <STDIN>;
chomp $loaves;

if (looks_like_number($loaves)) {
    print "Ok, mach ich...\n";
} else {
    print "Entschuldige, wie bitte?\n";
}
```

Aber bitte vergiss auch die Milch nicht.

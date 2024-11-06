---
title: "Boolesche Werte in Perl"
timestamp: 2013-08-05T22:43:00
tags:
  - undef
  - true
  - false
  - boolean
published: true
original: boolean-values-in-perl
books:
  - beginner
author: szabgab
translator: mca
---


Perl hat keinen ausgewiesenen booleschen Typ und trotzdem kann man in 
der Dokumentation Funktionen finden, die einen booleschen Wert zurückgeben.
Manchmal wird auch geschrieben, dass eine Funktion 'true' (wahr) und 'false' (falsch)
zurückgibt.

Also, wie sieht's in Wirklichkeit aus?


Perl hat keinen ausgewisenen booleschen Typ, aber jeder skalare Wert kann, wenn mit
<b>if</b> geprüft, entweder wahr oder falsch sein. Somit kannst Du das hier schreiben:

```perl
if ($x eq "foo") {
}
```

und Du kannst genauso das schreiben

```perl
if ($x) {
}
```

Im ersten Fall wird geprüft, ob der Inhalt der Variable <b>$x</b> dem Wert "foo"
entspricht, im zweiten, ob $x selbst 'wahr' oder 'falsch' ist.

## Welche Werte sind in Perl 'wahr' oder 'falsch'?

Es ist ziemlich einfach. Lasst mich die Dokumentation zitieren:
(Anmerkung des Übersetzers: Was in diesem Fall die Übersetzung des
Zitats ist.)

<pre>
Die Zahl 0, die Zeichenkette '0' und '', die leere Liste "()" und "undef"
sind alle 'falsch' in einem booleschen Kontext. Alle anderen Werte sind 
'wahr'. Die Negierung eines wahren Wertes mit "!" oder "not" gibt einen
speziellen Falsch-Wert zurück. Als Zeichenkette evaluiert wird '' zurückgegeben,
als Nummer interpretiert hingegen 0.

In perlsyn unter "Truth and Falsehood".
</pre>

Damit werden die folgenden Skalare als 'falsch' angesehen.

* undef, der undefinierte Wert
* 0, die Nummer 0, auch wenn Du sie als 000 oder 0.0 schreibst
* '', die leere Zeichenkette
* '0', die Zeichenkette, die eine einzelne 0 enthält.

Alle anderen Wert, einschließlich der nachfolgenden sind 'wahr':

* 1,  jede Nicht-Null-Zahl
* ' ', die Zeichenkette mit genau einem Leerzeichen als Inhalt
* '00', die Zeichenkette, die zwei Nullen enthält
* "0\n", eine Null gefolgt von einem Neuezeile-Zeichen
* 'true', die Zeichenkette mit Inhalt 'true'
* 'false', ja ja, selbst die Zeichenkette mit dem Inhalt 'false' ist 'wahr'.

Ich glaube es liegt daran, dass [Larry Wall](http://www.wall.org/~larry/),
der Erfinder von Perl, grundsätzlich eine positive Sicht der Dinge hat.
Er glaubt vielleicht, dass es wenige schlechte, 'falsche' Dinge in der Welt gibt.
Die meisten Dinge sind 'wahr'.

---
title: "Valores booleanos en Perl"
timestamp: 2013-09-01T12:03:56
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
translator: davidegx
---


Perl no tiene ningún tipo especial para los valores booleanos, sin embargo
en la documentación de Perl puedes ver muchas veces que una función devuelve
un valor "Booleano".
Otras veces la documentación dice que una función devuelve verdadero o falso.

¿Que es verdadero?



Perl no tiene un tipo booleano, sin embargo cualquier valor escalar será verdadero
o falso cuando se usa <b>if</b>. Puedes escribir

```perl
if ($x eq "foo") {
}
```

y también

```perl
if ($x) {
}
```

el primer ejemplo comprobará si el contenido de la variable <b>$x</b> es igual a la cadena "foo"
mientras que el segundo comprobará si $x es verdadero o falso.

## ¿Que valores son verdadero? ¿Cuales falso?

Es bastante sencillo. Según la documentación:

<pre>
El número 0, las cadenas '0' y '', la lista vacía "()", y "undef"
son todos falsos en un contexto booleano. Todos los demás valores
son verdaderos.
La negación de un valor verdadero usando "!" o "not" devuelve un valor
falso especial. Cuando es evaluado como una cadena es tratado como '', como
número es tratado como 0.

Extraído de "Truth and Falsehood" dentro de perlsyn.
</pre>

Por lo tanto los siguientes valores escalares son considerados falsos:

* undef - el valor indefinido
* 0  el número 0, independientemente de si lo escribes como 000 o 0.0
* ''   la cadena vacía.
* '0'  la cadena que contiene un solo 0.

El resto de valores escalares son verdaderos, incluyendo los siguientes:

* 1  cualquier número que no sea 0
* ' '   la cadena con un espacio en ella
* '00'   dos o más ceros en una cadena
* "0\n"  un cero seguido de una nueva línea
* 'true'
* 'false'   si, incluso la cadena 'false' se evalúa como verdadero.

Creo que esto es porque [Larry Wall](http://www.wall.org/~larry/),
el creador de Perl, tiene una visión positiva del mundo.
Probablemente piensa que hay pocas cosas malas y falsas en el mundo.
La mayoría de las cosas son ciertas.


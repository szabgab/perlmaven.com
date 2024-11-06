---
title: "Ordenando arrays en Perl"
timestamp: 2014-10-23T10:05:56
tags:
  - sort
  - $a
  - $b
  - cmp
  - <=>
published: true
original: sorting-arrays-in-perl
books:
  - beginner
author: szabgab
translator: davidegx
---


En este articulo veremos como podemos <b>ordenar arrays de strings o números en Perl</b>.

Perl incluye la función `sort` que sirve para ordenar un array. En su forma más sencilla
le das un array y devuelve los elementos de ese array ordenados. `@sorted = sort @original`.


## Ordenar en ASCII

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Data::Dumper qw(Dumper);

my @words = qw(foo bar zorg moo);

say Dumper \@words;

my @sorted_words = sort @words;

say Dumper \@sorted_words;
```

El ejemplo anterior mostrará

```perl
$VAR1 = [
        'foo',
        'bar',
        'zorg',
        'moo'
      ];

$VAR1 = [
        'bar',
        'foo',
        'moo',
        'zorg'
      ];
```

En primer lugar tenemos el contenido del array antes de ordenarlo, después el contenido en orden.

Este es el caso más simple, pero no es lo que queremos siempre.
Por ejemplo, ¿que pasa si algunas de las palabras empiezan con letras mayúsculas?


```perl
my @words = qw(foo bar Zorg moo);
```

El contenido en `@sorted_words` será:

```perl
$VAR1 = [
        'Zorg',
        'bar',
        'foo',
        'moo'
      ];
```

Como ves, la palabra que empieza con una letra mayúscula aparece primero.
Esto es porque `sort` ordena por defecto usando la tabla ASCII, ahí todas
las letras mayúsculas aparecen antes que las minúsculas.

## Funciones de comparación

`sort` funciona en Perl de la siguiente manera: recorre los elementos del array
y en cada turno pone el primer elemento en la variable `$a` y el segundo en la
variable `$b`. Entonces llama a la <b>función de comparación</b>. Esta función
devolverá 1 si el contenido de `$a` debería estar a la izquierda, -1 si el contenido
de `$b` debería estar a la izquierda, o 0 si no importa porque los dos valores son
iguales.

Por defecto no ves esta función de comparación y <b>sort</b> compara los valores usando
la tabla ASCII, se puede escribir de forma explicita:

```perl
sort { $a cmp $b } @words;
```

Este código dará exactamente el mismo resultado que el código: `sort @words`.

Puedes ver que, por defecto, se usa `cmp` como función de comparación.
Lo que hace cmp es comparar los valores de ambos lados como strings, devuelve 1
si el argumento de la izquierda es "menor que" el de la derecha, devuelve -1 si
el argumento de la izquierda es "mayor que" el de la derecha, y devuelve 0 si son
iguales.

## Usando un orden alfabético

Si quieres usar un orden alfabético, ignorando mayúsculas y minúsculas, puedes hacerlo
así:

```perl
my @sorted_words = sort { lc($a) cmp lc($b) } @words;
```

Usamos `lc` que devuelve la versión en minúsculas (lower case) del valor pasado
como parámetro.
Después `cmp` compara estas versiones en minúsculas y decide donde colocar los
strings originales.

El contenido en `@sorted_words` será:

```perl
$VAR1 = [
        'bar',
        'foo',
        'moo',
        'Zorg'
      ];
```

## Ordenando números en Perl

Si rellenamos un array con números y lo ordenamos usando el orden por
defecto, el resultando no será el que probablemente estamos esperando.

```perl
my @numbers = (14, 3, 12, 2, 23);
my @sorted_numbers = sort @numbers;
say Dumper \@sorted_numbers;
```


```perl
$VAR1 = [
        12,
        14,
        2,
        23,
        3
      ];
```

Por supuesto si lo piensas no es tan sorprendente. Cuando la función de comparación
ve 12 y 3, los compara como strings. Por lo tanto, comparará el
primer carácter de cada string, "1" y "3". Como "1" esta antes que "3" en la tabla ASCII,
el string "12" vendrá antes que el string "3".

Perl no adivina mágicamente que quieres ordenar estos valores como números.

De todas formas no hay problema, podemos escribir una función que compare los dos valores como
números.
Para ello usamos el operador <lt><=></li> (también llamado [spaceship operator (en)](http://en.wikipedia.org/wiki/Spaceship_operator))
que comparará sus dos parámetros como números y devolverá 1, -1 o 0.

```perl
my @sorted_numbers = sort { $a <=> $b } @numbers;
```

Devolverá el contenido ordenado así:

```perl
$VAR1 = [
        2,
        3,
        12,
        14,
        23
      ];
```

Puedes ver algunos ejemplos más en [ordenando strings mixtos (en)](https://perlmaven.com/sorting-mixed-strings).


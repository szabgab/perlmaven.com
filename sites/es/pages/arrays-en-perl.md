---
title: "Arrays en Perl"
timestamp: 2013-08-08T18:55:02
tags:
  - array
  - arrays
  - length
  - size
  - foreach
  - "Data::Dumper"
  - scalar
  - push
  - pop
  - shift
published: true
original: perl-arrays
books:
  - beginner
author: szabgab
translator: davidegx
---


En este episodio de [Perl Tutorial](/perl-tutorial) echaremos un vistazo a los <b>arrays en Perl</b>.
Esto es un pequeño resumen de como funcionan los arrays en Perl. Veremos explicaciones más detalladas en el futuro.

Los nombres de variables que contienen arrays en Perl empiezan con el carácter `@`.

Debido a nuestra insistencia del uso de `strict` tendrás que declarar estas variables usando `my`
antes del primer uso.


Recuerda que todos los ejemplos asumen que tu código comienza con

```perl
use strict;
use warnings;
use 5.010;
```

Declarar un array:

```perl
my @names;
```

Declarar y asignar valores:

```perl
my @names = ("Foo", "Bar", "Baz");
```


## Comprobar el contenido de un array

```perl
use Data::Dumper qw(Dumper);

my @names = ("Foo", "Bar", "Baz");
say Dumper \@names;
```

La salida será:

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz'
      ];
```

## El bucle foreach y los arrays en perl

```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $n (@names) {
  say $n;
}
```

Mostrará

```
Foo
Bar
Baz
```

## Accediendo a un elemento de un array

```perl
my @names = ("Foo", "Bar", "Baz");
say $names[0];
```

Ten en cuenta que al acceder a un solo elemento de un array la `@` inicial cambia a `$`.
Puede parecer confuso, pero si piensas en ello es bastante obvio el porqué.

`@` indica plural y `$` indica singular. Al acceder a un solo elemento
de un array se comporta simplemente como una variable escalar normal.

## Indices en un array

Los indices en un array empiezan por 0. El indice superior es siempre la variable
`$#name_of_the_array`. Por tanto

```perl
my @names = ("Foo", "Bar", "Baz");
say $#names;
```

Mostrará 2 porque los indices son 0, 1 y 2.

## Tamaño de un array

En Perl no existe ninguna función especial para obtener el tamaño de un array,
pero hay varias formas de obtener su valor. Una es usar el indice
superior y sumarle 1. En el caso anterior, `$#names+1` es el <b>tamaño</b> del
array.

Además la función `scalar` también puede usarse para obtener el tamaño:

```perl
my @names = ("Foo", "Bar", "Baz");
say scalar @names;
```

Mostrará 3.

La función scalar realiza una especie de conversión que, entre otras cosas, convierte un
array a escalar. Debido a una decisión arbitraria a la par que inteligente, esta 
conversión devuelve el tamaño del array.

## Iterar sobre los indices de un array

Hay casos en los que recorrer los valores de un array no es suficiente ya que
podemos necesitar tanto el valor con el indice de ese valor.
En ese caso necesitamos iterar sobre los indices y obtener los valores a partir
de ellos:

```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $i (0 .. $#names) {
  say "$i - $names[$i]";
}
```

mostrará:

```
0 - Foo
1 - Bar
2 - Baz
```

## Añadir un elemento a un array

La función `push` añade un nuevo valor al final de un array:

```perl
my @names = ("Foo", "Bar", "Baz");
push @names, 'Moo';

say Dumper \@names;
```

El resultado será:

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz',
        'Moo'
      ];
```


## Extraer elementos de un array

La función `pop` extrae el último elemento de un array:

```perl
my @names = ("Foo", "Bar", "Baz");
my $last_value = pop @names;
say "Last: $last_value";
say Dumper \@names;
```

El resultado será:

```
Last: Baz
$VAR1 = [
        'Foo',
        'Bar',
      ];
```

## Añadir un elemento al principio de un array
La función `unshift` añadirá un elemento al principio del
array y moverá el resto hacia la derecha.

```perl
my @names = ("Foo", "Bar", "Baz");
unshift @names, "Moo";

say Dumper(\@names);
```

Mostrará:

```
$VAR1 = [
        'Moo',
        'Foo',
        'Bar',
        'Baz'
      ];
```

## Extraer el primer elemento de un array

La función `shift` extraerá el primer elemento del array
y moverá el resto hacia la izquierda.

```perl
my @names = ("Foo", "Bar", "Baz");

my $first_value = shift @names;
say "First: $first_value";
say Dumper \@names;
```

El resultado será:

```
First: Foo
$VAR1 = [
        'Bar',
        'Baz',
      ];
```


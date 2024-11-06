---
title: "Contexto escalar y lista en Perl, el tamaño de un array"
timestamp: 2013-08-05T20:07:56
tags:
  - scalar
  - list
  - array
  - size
  - length
  - context
  - Perl
published: true
original: scalar-and-list-context-in-perl
books:
  - beginner
author: szabgab
translator: davidegx
---


En este capítulo de [Perl tutorial](/perl-tutorial) analizaremos la <b>sensibilidad al contexto</b> en Perl.

Tanto en Inglés como en Español, y en la mayoría de idiomas, las palabras pueden tener múltiples significados.
Por ejemplo, en Inglés la palabra "left":

I left the building. # Salí del edificio

I turned left at the building. # Gire a la izquierda en el edificio

O en Español la palabra "banco":

Fui al banco a sacar dinero.

Me senté en el banco del parque.

Sabemos el significado correcto gracias al resto de palabras alrededor.
Es lo que llamamos contexto.

Perl 5 funciona de forma parecida. Las palabras, llamadas a funciones y otras expresiones tienen
diferentes significados dependiendo del contexto. Esto hace más difícil aprender el lenguaje pero también lo dota
de más expresividad.


Hay dos contextos principales en Perl: ESCALAR y LISTA.

## Array in LIST context

Veamos un ejemplo:

```perl
my @words = ('Foo', 'Bar', 'Baz');
my @names = @words;
```

Después de la asignación anterior `@names` contiene una copia de los valores que estaban en `@words`;

La asignación de un array en otro array copia el contenido de dicho array.

## Array en contexto ESCALAR

```perl
my @words = ('Foo', 'Bar', 'Baz');
my $people =  @words;
```

Esta vez asignamos el array `@words` a la variable `$people`, que es una variable escalar.

Otros lenguajes se comportan de forma diferente, pero en Perl esta
asignación pone en $people <b>el número de elementos del array</b>.

Esto es arbitrario, y en el caso anterior quizás no es útil, pero en muchos otros casos este 
comportamiento es muy conveniente.

## Contextos ESCALAR y LISTA

En contexto escalar se espera recibir un valor único mientras que en contexto lista se
esperan múltiples valores.
En el contexto de lista el número de valores puede ser 0, 1, 2 o cualquier otro número.


## El contexto de la sentencia if

Observa este ejemplo:

```perl
my @words = ('Foo', 'Bar', 'Baz');

if (@words) {
   say "Hay algunas palabras en el array";
}
```

Dentro de la condición de la sentencia `if` se espera
exactamente un valor. Por lo tanto es un contexto escalar.

Sabemos que el valor de un array en contexto ESCALAR es el número
de elementos que contiene. También sabemos que es cero ([FALSO](/valores-booleanos-en-perl))
cuando el array esta vacío, y un número positivo ([VERDADERO](/valores-booleanos-en-perl)),
cuando el array tiene uno o más valores.

Debido a la decisión arbitraria anterior, el código`if (@words)`
comprueba si hay algún elemento en el array y devuelve falso si el array esta vacío.

Al revés, la expresión `if (! @words)` será verdadera
si el array esta vacío.

## Contextos ESCALAR y LISTA

En el [episodio previo](/el-anno-19100) vimos como `localtime()`
se comporta en contexto ESCALAR y en contexto LISTA, ahora vemos como se comporta un array en ambos contextos.

No hay una regla general sobre el contexto por lo que es necesario aprenderse los diferentes casos,
no obstante suelen ser bastante obvios. En cualquier caso, cuando consultes la documentación de una función en
[perldoc](/documentacion-nucleo-perl-modulos-cpan),
encontrarás una explicación de su comportamiento en cada caso.
Al menos en los casos en los que los contextos ESCALAR y LISTA proporcionen diferentes resultados.

Veremos algunos ejemplos más de expresiones en Perl y que tipo de contexto crean.

## Creando contexto ESCALAR

Ya hemos visto que independientemente de lo que asignes a una variable escalar ese valor estará en contexto ESCALAR.
Escribámoslo de la siguiente forma:

```
$x = SCALAR;
```

Debido a que cada elemento de un array también es escalar, su asignación también crea contexto ESCALAR:

```
$word[3] = SCALAR;
```

La concatenación espera dos cadenas a cada lado por lo que crea contexto ESCALAR en ambos lados:

```
"string" . SCALAR;
```

y también

```
SCALAR . "string"
```

Por lo que

```perl
my @words = ('Foo', 'Bar', 'Baz');
say "Number of elements: " . @words;
say "It is now " . localtime();
```

mostrará:

```
Number of elements: 3
It is now Thu Feb 30 14:15:53 1998
```

Los operadores numéricos normalmente esperan dos números, dos escalares, a cada lado.
Por lo tanto dichos operadores crean contexto ESCALAR en cada lado:

```
5 + SCALAR;

SCALAR + 5;
```

## Creando contexto LISTA

Hay otras construcciones que crean contexto LISTA:

La asignación a un array es una de ellas:

```
@x = LIST;
```

Otra es la asignación a una lista:

```
($x, $y) = LIST;
```

Incluso si esa lista tiene un solo elemento:

```
($x) =  LIST;
```

Esto nos lleva a un asunto importante que puede confundir fácilmente:

## ¿Cuando son los paréntesis significativos?

```perl
use strict;
use warnings;
use 5.010;

my @words = ('Foo', 'Bar', 'Baz');

my ($x) = @words;
my $y   = @words;

say $x;
say $y;
```

la salida será:

```
Foo
3
```

Este es uno de los pocos casos donde los paréntesis son muy importantes.

En la primera asignación `my ($x) = @words;` asignamos
a una <b>lista</b> de variable(s) escalares.
Esto crea contexto LISTA en el lado derecho. Lo que implica que los <b>valores</b>
del array fueron copiados a la lista del lado izquierdo. Debido a que solo había
una variable escalar, solo el primer elemento del array fue copiado.

En la segunda asignación `my $y   = @words;` asignamos <b>directamente</b> a
una variable escalar. Esto crea contexto ESCALAR en el lado derecho. Un array en
contexto ESCALAR devuelve el número de elementos en él.

Esto será muy importante cuando eches un vistazo a 
[pasando parámetros a funciones](https://perlmaven.com/subroutines-and-functions-in-perl)

## Forzando contexto ESCALAR

Tanto `print()` como `say()` crean contexto LISTA para sus parámetros.
¿Que ocurre si quieres mostrar el número de elementos en un array?
Y si quieres mostrar correctamente formateada la fecha devuelta por `localtime()`?

Probemos esto:

```perl
use strict;
use warnings;
use 5.010;

my @words = ('Foo', 'Bar', 'Baz');

say @words;
say localtime();
```

La salida es:

```
FooBarBaz
3542071011113100
```
La primera línea es más o menos clara, son los valores del array juntos.

La segunda es confusa. NO es el mismo resultado que el resultado de la función `time()</h1>,
como se podría pensar. Son los 9 números devueltos por la función `localtime()` en
contexto LISTA. Si no te suena, echa un vistazo al capitulo acerca
[del año 19100](/el-anno-19100).

La solución es usar la función `scalar()` que creará contexto ESCALAR para sus parámetros.
De hecho ese es el único propósito de la función `scalar()`.

```perl
say scalar @words;
say scalar localtime();
```

Y la salida será

```
3
Mon Nov  7 21:02:41 2011
```

## Dimensión de un array en Perl

In a nutshell, if you would like to get the size of an array in Perl you can use
En pocas palabras, si quieres el tamaño de un array en Perl puedes usar
la función `scalar()` para forzar contexto ESCALAR y obtener su tamaño.

## La forma difícil

Algunas veces puedes encontrar código como este:

```perl
0 + @words;
```

Básicamente es un truco para conseguir el tamaño de un array. El operador ` + `
crea contexto ESCALAR en ambos lados. Un array devolverá su tamaño en contexto ESCALAR.
Añadiéndole 0 no cambia el número por lo que la expresión anterior devolverá el tamaño del array.

Recomiendo usar la función `scalar`, es una forma ligeramente más larga pero mucho
más clara de obtener el tamaño de un array.




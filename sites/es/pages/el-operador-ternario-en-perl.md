---
title: "El operador ternario en Perl"
timestamp: 2014-02-17T13:45:56
tags:
  - "?:"
published: true
original: the-ternary-operator-in-perl
books:
  - beginner
author: szabgab
translator: davidegx
---


El operador ternario es probablemente uno de los operadores más tristes en el mundo. El resto de los operadores tienen
nombres como suma, negación unaria, negación binaria, pero este es nombrado solo por su sintaxis.

Como en la mayoría de lenguajes de programación es el único operador con 3 parámetros, mucha gente no conoce su nombre real.
Cuando fue creado se llamó [operador condicional ](http://en.wikipedia.org/wiki/%3F:).


## Operadores unarios, binarios y ternarios

Un operador unario tiene un solo operando (-3).

Un operador binario tiene dos operandos (2-3) o (4+5).

Un operador ternario tiene tres operandos.

## El operador condicional

En Perl 5, como en la mayoría de lenguajes de programación, el <b>operador condicional</b> tiene 3 partes separadas por `?` y `:`.

La primera parte, antes de `?` es la condición. Es evaluada en contexto booleano.
Si es [verdadera](/valores-booleanos-en-perl), la segunda parte, entre `?` y `:`
será evaluada y ese será el resultado de la expresión.
En caso contrarío la tercera parte será evaluada y ese será el valor de la expresión.

En general es similar a:

```
CONDICION ? EVALUAR_SI_CONDICION_ES_VERDADERO : EVALUAR_SI_CONDICION_ES_FALSO
```

Que básicamente es lo mismo que

```
if (CONDICION ) {
CONDITION
    EVALUAR_SI_CONDICION_ES_VERDADERO;
} else {
    EVALUAR_SI_CONDICION_ES_FALSO;
}
```

## Ejemplos

Veamos algunos ejemplos:

```perl
use strict;
use warnings;
use 5.010;

my $file = shift;

say $file ? $file : "archivo no proporcionado"; 
```

Si `$file` es verdadero (el usuario proporciono el nombre del fichero en la línea de comandos), mostrará el nombre en la línea de comandos.
En caso contrario mostrará "archivo no proporcionado".

```perl
my $x = rand();
my $y = rand();

my $smaller = $x < $y ? $x : $y;
say $smaller
```

En este ejemplo el valor más pequeño es almacenado en `$smaller`.

## Estableciendo un limite

Por ejemplo si nuestro código recibe algún valor por una función llamada `get_value()`, pero queremos
estar seguro de que no excede un limite determinado:

```perl
my $MAX_LIMIT = 10;

my $value = get_value();
$value = $value <= $MAX_LIMIT ? $value : $MAX_LIMIT;
```

También podríamos escribir esto de otra forma:

```perl
$value = $MAX_LIMIT if $value > $MAX_LIMIT;
```



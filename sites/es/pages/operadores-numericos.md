---
title: "Operadores numéricos"
timestamp: 2015-03-05T21:30:01
tags:
  - "+"
  - "-"
  - "*"
  - "/"
  - "%"
  - "++"
  - "--"
  - "+="
  - "*="
  - "-="
  - "/="
  - "%="
published: true
original: numerical-operators
books:
  - beginner
author: szabgab
translator: davidegx
---


Como la mayoría de lenguajes de programación, Perl tiene los operadores numéricos básicos:
`+` para la suma, `-` para la resta, `*` para la multiplicación, `/` para la división:


```perl
use strict;
use warnings;
use 5.010;

say 2 + 3;   # 5
say 2 * 3;   # 6
say 9 - 5;   # 4
say 8 / 2;   # 4

say 8 / 3;   # 2.66666666666667
```

Perl usa automáticamente números en [coma flotante](https://es.wikipedia.org/wiki/Coma_flotante) cuando es necesario, por lo que al dividir
8 entre 3 obtenemos un valor en coma flotante.

El operador modulo `%` devuelve el [resto](https://es.wikipedia.org/wiki/Resto) de la división entera:

```perl
use strict;
use warnings;
use 5.010;

say 9 % 2;   # 1
say 9 % 5;   # 4
```

Estos mismos operadores numéricos también se pueden usar sobre [variables escalares (en)](https://perlmaven.com/scalar-variables):

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
my $y = 3;

say $x + $y;  # 5
say $x / $y;  # 0.666666666666667
```

## Asignaciones compuestas

La expresión `$x += 3;` es la versión abreviada de `$x = $x + 3;`, ambas producen
exactamente el mismo resultado:

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
say $x; # 2

$x = $x + 3;
say $x; # 5

my $y = 2;
say $y;  # 2
$y += 3;
say $y;  # 5
```

En general, `VARIABLE OP= EXPRESION` es lo mismo que
`VARIABLE = VARIABLE OP EXPRESION`, normalmente es más fácil de leer y menos proclive a errores (No tenemos que repetir el nombre de la VARIABLE)
Este tipo de asignación compuesta se puede utilizar con cualquier operador binario:

`+=`, `*=`, `-=`, `/=`, incluso `%=`


## Auto incremento y auto decremento

Perl también proporciona los operadores `++` y `--` para auto incremento y auto decremento. Estos operadores incrementan y decrementan respectivamente el valor de una variable escalar por 1.

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
say $x; # 2
$x++;
say $x; # 3

$x--;
say $x; # 2
```

Tanto las versiones postfijas `$x++` y `$x--`, como las versiones prefijas
`++$x` y `--$x` están disponibles y funcionan de la misma manera que en
otros lenguajes de programación.
En caso de que no las conozcas, no es el mejor momento para explorarlas a fondo.

Cuando se usan dentro de una expresión más grande es cuando usar operadores prefijos o postfijos realmente importa. En
la mayoría de los casos es mejor evitar esas expresiones, pueden provocar dolores de cabeza fácilmente.
Tendremos un articulo explicando los corto circuitos en expresiones booleanas y los problemas
con auto incrementos.

Adicionalmente, el operador de auto incremento también funciona con strings como se
explica en [string operators (en)](https://perlmaven.com//string-operators).



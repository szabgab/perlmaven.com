---
title: "Operadores para strings: concatenación (.) y repetición (x)"
timestamp: 2015-04-06T11:30:01
tags:
  - x
  - .
  - ++
published: true
original: string-operators
books:
  - beginner
author: szabgab
translator: davidegx
---


Además de los [operadores numéricos](/operadores-numericos), Perl tiene dos operadores
pensados especialmente para cadenas de texto.
Uno de ellos es `.` para concatenar, el otro es `x` (x minúscula) para repetición.


```perl
use strict;
use warnings;
use 5.010;

my $x = 'Hola';
my $y = 'Mundo';

my $z = $x . ' ' . $y;
say $z;
```

Ejecutando el código anterior obtendrás:

```
Hola Mundo
```

El operador `.` simplemente concatena el texto de las dos variables
y el espacio creando un nuevo string.

En el caso anterior no necesitamos usar la concatenación con `.`, usando
la [interpolación de variables escalares](/strings-entrecomillados-interpolados-y-escapados-en-perl)
dentro de strings podemos escribir:

```perl
my $z = "$x $y";
```

y obtendríamos el mismo resultado.

## Cuando la interpolación no funciona

Hay muchos casos donde la concatenación no se puede remplazar con interpolación. Por ejemplo:

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
my $y = 3;

my $z = '2 + 3 da ' . ($x + $y);

say $z;
```

Mostrará:

```
2 + 3 da 5
```

Por otro lado, si usamos interpolación en lugar de concatenación:

```perl
my $z = "2 + 3 da ($x + $y)";
```

Obtendremos:

```
2 + 3 da (2 + 3)
```

## x, el operador de repetición

El operador `x` espera un string como operador en el lado izquierdo y un número en el lado
derecho.
Devolverá el texto del lado izquierdo repetido tantas veces como indica el valor del lado derecho.

```perl
use strict;
use warnings;
use 5.010;

my $y = 'Jar ';

my $z = $y x 2;
say $z;

say $y x 2 . 'Binks';
```

devuelve:

```
Jar Jar 
Jar Jar Binks
```

Este operador no se usa a menudo, pero puede ser útil en algunos casos.
Por ejemplo, si quieres añadir una línea del mismo tamaño que el título de un informe:

```perl
use strict;
use warnings;
use 5.010;


print "Por favor introduce el titulo: ";
my $title = <STDIN>;
chomp $title;

say $title;
say '-' x length $title;
```

Aquí la línea mostrada bajo el título es exactamente del mismo tamaño (en número de caracteres)
que el título.

```
$ perl informe.pl 
Por favor introduce el titulo: hola
hola
-----

$ perl informe.pl 
Por favor introduce el titulo: hola mundo
hola mundo
-----------
```

## ++ en un string

Aunque se podría esperar que el operador de auto-incremento (`++`) funcionase
[solo con números](/operadores-numericos), también funciona con strings en Perl.

Si Perl encuentra un string en lugar de un número seleccionará el último carácter y lo
incrementa usando la las letras minúsculas y mayúsculas de la tabla [ASCII](https://es.wikipedia.org/wiki/ASCII).
Si un string termina con la letra 'y' y la incrementamos cambiará a 'z'. Si termina con 'z'
y la incrementamos de nuevo cambiará a la letra 'a' y el carácter a su izquierda será
incrementado también.

```perl
use strict;
use warnings;
use 5.010;

my $x = "ay";
say $x;
$x++;
say $x;


$x++;
say $x;

$x++;
say $x;

$x--;
say $x;
```

El resultado será:

```
ay
az
ba
bb
-1
```

Como puedes ver, el operador `--` no funciona con strings.


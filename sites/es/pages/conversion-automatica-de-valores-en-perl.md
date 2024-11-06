---
title: "Conversión automática de texto a número en Perl"
timestamp: 2014-10-25T10:45:56
tags:
  - is_number
  - looks_like_number
  - Scalar::Util
  - casting
  - type conversion
published: true
original: automatic-value-conversion-or-casting-in-perl
books:
  - beginner
author: szabgab
translator: davidegx
---


Imagina que escribes la lista de la compra

```
"2 barras de pan"
```

se la das a tu media naranja y recibes como respuesta
"conversión de tipo no valida".
Después de todo en la lista "2" es un string, no un número.

Sería frustrante, ¿cierto?


## Conversión de tipos de datos en Perl

En la mayoría de los lenguajes de programación el tipo de los operandos define como un operador se comporta.
Por ejemplo, <i>sumando</i> dos números realizan una suma numérica, mientras que <i>sumando</i> dos strings
realizan una concatenación de ambas.
Esta característica se llama sobrecarga de operadores.

Perl funciona mayormente de la manera opuesta.

En Perl es el operador el que define como los operandos son usados.

Esto quiere decir que si realizas una operación numérica (suma por ejemplo) ambos
valores serán automáticamente convertidos a números. Si usas operadores para strings
(como concatenar) ambos valores serán automáticamente convertidos a strings.

Los programadores C probablemente llaman a este tipo de conversiones <b>casting</b>,
este termino no se usa normalmente en el mundo Perl. Probablemente porque todo
esto es automático.

A Perl no le importa si escribes algo como string o como número.
Convierte de uno a otro automáticamente en base al contexto.

La conversión `número => string` es fácil.
Simplemente imaginamos que " aparece antes y después del valor numérico.

La conversión `string => número` puede ser un poco más difícil.
Si el string es simplemente un número entonces es fácil.
El valor numérico será lo mismo, eliminando las comillas.

Si hay caracteres que no permiten a perl convertir de forma completa el string
a número, perl usará todo lo que sean caracteres numéricos en la parte izquierda
y descartara el resto.

Veamos algunos ejemplos:

```
Original   Como string   Como número

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

En todos los casos donde la conversión de string a número no es perfecta, 
perl mostrará un warning. Asumiendo que hayas
usado `use warnings` como se recomienda.

## Ejemplo

Veamos ahora algunos ejemplos con código:

```perl
use strict;
use warnings;

my $x = "4T";
my $y = 3;

```

La concatenación convierte ambos valores a strings:

```perl
print $x . $y;    # 4T3
```

La suma numerica convierte ambos valores a números:

```perl
print $x + $y;  # 7
                # Argument "4T" isn't numeric in addition (+) at ...
```

## Argument isn't numeric

Perl te informa mediante este [warning (en)](https://perlmaven.com/argument-isnt-numeric-in-numeric)
que esta intentando convertir un string a número y la conversión no es perfecta.

Hay otra serie de errores y warnings comunes en Perl.
Por ejemplo [Global symbol requires explicit package name (en)](https://perlmaven.com/global-symbol-requires-explicit-package-name)
y [Use of uninitialized value (en)](https://perlmaven.com/use-of-uninitialized-value).

## ¿Como evitar el warning?

Esta bien que perl te avise (si se lo pediste) cuando una conversión de tipos no ha sido perfecta, ¿pero no hay una
función como <b>is_number</b> que comprueba si un string dado es un número?

Si y no.

Perl no tiene una función <b>is_number</b> porque supondría que sabemos que es exactamente un número.
Desafortunadamente el mundo no esta de acuerdo en que es exactamente un número. Hay sistemas
donde ".2" es aceptado como número, pero en otros sistemas no lo es. Más común es que "2." no sea aceptado como
número, pero hay sistemas donde es perfectamente aceptable.

Hay incluso sitios donde 0xAB es considerado un número. Representando un número hexadecimal.

Así que no hay ninguna función <b>is_number</b>, pero si que hay una función un poco menos atrevida llamada
<b>looks_like_number</b> (parece un número).

Esta función hace exactamente lo que indica su nombre, comprueba si el string recibido parece un número a los ojos de perl.

Esta incluida en el modulo [Scalar::Util](http://perldoc.perl.org/Scalar/Util.html) y
la puedes usar así:

```perl
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

print "Cuantas barras de pan debería comprar? ";
my $loaves = <STDIN>;
chomp $loaves;

if (looks_like_number($loaves)) {
    print "Estoy en ello...\n";
} else {
    print "Que?, no te he entendido\n";
}
```

¡No te olvides de traer leche también!



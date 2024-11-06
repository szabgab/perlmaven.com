---
title: "undef, el valor por defecto y la función defined en Perl"
timestamp: 2014-11-10T20:53:56
tags:
  - undef
  - defined
published: true
original: undef-and-defined-in-perl
books:
  - beginner
author: szabgab
translator: davidegx
---


En algunos lenguajes hay una forma especial de indicar "esta variable no tiene un valor".
En <b>SQL</b>, <b>PHP</b> y <b>Java</b> este valor es `NULL`. En <b>Python</b>, `None`.
En <b>Ruby</b> se llama `Nil`.

En Perl este valor se llama `undef`.

Veamos algunos detalles.


## ¿Como se obtiene undef?

Cuando declaras una variable escalar sin asignarle ningún valor el contenido será el valor `undef`.

```perl
my $x;
```

Algunas funciones devuelven `undef` para indicar un error mientras que otras
simplemente retornan undef porque no tienen nada importante que devolver.

```perl
my $x = hacer_algo();
```

Puedes usar la función `undef()` para restablecer el valor de la variable a `undef`:

```perl
# algo de codigo
undef $x;
```

También puedes usar el valor devuelto por la función `undef()` para asignar `undef` a una
variable:

```perl
$x = undef;
```

Los paréntesis después del nombre de la función son opcionales y no los he incluido en el ejemplo.

Como puedes ver hay un diversas maneras de obtener <b>undef</b> en una variable escalar.
La cuestión es, ¿que ocurre si usamos esa variable?

Sin embargo, antes veremos:

## ¿Como comprobar si una variable vale undef?

La función `defined()` devolverá [verdadero](/valores-booleanos-en-perl) si
el valor proporcionado <b>no es undef</b>. Devolverá [falso](/valores-booleanos-en-perl)
si el valor proporcionado es <b>undef</b>.

Se puede usar así:

```perl
use strict;
use warnings;
use 5.010;

my $x;

# algun codigo que puede asignar un valor a $x

if (defined $x) {
    say '$x esta definido';
} else {
    say '$x es undef';
}
```


## ¿Cual es el valor real de undef?

Aunque <b>undef</b> indica la ausencia de un valor, es todavía usable.
Perl proporciona un par de valores por defecto asociados a undef.

Si usas una variable que contiene undef en una operación numérica, actuará como si fuese 0.

Si la usas en una operación de strings, actuará como la cadena vacía.


Observa el siguiente ejemplo:

```perl
use strict;
use warnings;
use 5.010;

my $x;
say $x + 4, ;  # 4
say 'Foo' . $x . 'Bar' ;  # FooBar

$x++;
say $x; # 1
```

En este ejemplo la variable $x, que vale undef por defecto, se comporta como 0 en la suma (+).
En la concatenación (.) se comporta como la cadena vacía y de nuevo como 0 en la operación de
auto-incremento (++).

No será perfecto. Si has habilitado los warnings con la sentencia `use warnings`
([lo cual siempre se recomienda](/instalacion-y-primeros-pasos-con-perl))
recibiras dos [use of uninitialized value (en)](https://perlmaven.com/use-of-uninitialized-value)
warnings por las dos primeras operaciones, pero no por el auto-incremento:

```
Use of uninitialized value $x in addition (+) at ... line 6.
Use of uninitialized value $x in concatenation (.) or string at ... line 7.
```

Creo que no recibes la advertencia para la operación de incremento porque perl lo perdona. Después veremos
que es bastante conveniente en sitios donde quieres contar cosas.

Puedes evitar los warnings inicializando la variable con el valor correcto (0 o la cadena vacía,
dependiendo de lo que corresponda), o deshabilitando los warnings selectivamente.
Lo trataremos en una articulo separando.

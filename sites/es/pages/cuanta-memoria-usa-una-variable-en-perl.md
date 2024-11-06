---
title: "Cuanta memoria usa una variable en Perl ?"
timestamp: 2014-09-13T10:50:01
tags:
  - memory
  - Devel::Size
published: true
original: how-much-memory-do-perl-variables-use
author: szabgab
translator: danimera
---

Hay casos en que sería muy importante saber cuánto usa cada variable en Perl.
Para esto el módulo [ Devel::Size](https://metacpan.org/pod/Devel::Size) ofrece dos funciones.
Tanto en `size` como `total_size` aceptan una referencia a una variable o una estructura de datos.
La diferencia entre ellos es que en las estructuras de datos complejas (aka. arrays y hashes), `size`
sólo devuelve la memoria utilizada por la estructura, no por los datos. 

Hay que señalar algunas diferencias entre la memoria que Perl solicita, a lo que Devel::Size informe,
y lo que en realidad ha asignado el sistema operativo. Si está interesado, hay una buena explicación
en la [ documentación de Devel::Size](https://metacpan.org/pod/Devel::Size)

El siguiente script intenta mostrar algunos valores básicos:

```perl
use strict;
use warnings;
use 5.010;

use Devel::Size qw(size total_size);

my $x;
my @y;
my %z;

say '                           size  total_size';
both('SCALAR', \$x);        #    24    24
both('ARRAY',  \@y);        #    64    64
both('HASH',   \%z);        #   120   120
both('CODE', sub {} );      #  8452  8452
say '';

both('SCALAR', \$x);        #  24    24
$x = 'x';
both('SCALAR-1', \$x);      #  56    56
$x = 'x' x 15;
both('SCALAR-15', \$x);     #  56    56
$x = 'x' x 16;
both('SCALAR-16', \$x);     #  72    72
$x = 'x' x 31;
both('SCALAR-31', \$x);     #  72    72
$x = 'x' x 32;
both('SCALAR-32', \$x);     #  88    88
$x = '';
both('SCALAR=""', \$x);     #  88    88
$x = undef;
both('SCALAR=undef', \$x);  #  88    88
undef $x;
both('undef SCALAR', \$x);  #  40    40
say '';

both('ARRAY',  \@y);               #    64    64
@y = ('x');
both('ARRAY-1', \@y);              #    96   152
@y = ('x' x 15);
both('ARRAY-15', \@y);             #    96   152
@y = ('x' x 16);
both('ARRAY-16', \@y);             #    96   168
@y = ('x' x 31);
both('ARRAY-31', \@y);             #    96   168
@y = ('x' x 32);
both('ARRAY-32', \@y);             #    96   184
@y = ('x') x 2;
both('ARRAY-1-1', \@y);            #    96   208
@y = ('x') x 4;
both('ARRAY-1-1-1-1', \@y);        #    96   320
@y = ('x') x 5;
both('ARRAY-1-1-1-1-1', \@y);      #   104   384
@y = ('x') x 6;
both('ARRAY-1-1-1-1-1-1', \@y);    #   112   448
@y = ('x') x 7;
both('ARRAY-1-1-1-1-1-1-1', \@y);  #   128   520
@y = ();
both('ARRAY = ()', \@y);           #   128   128
undef @y;
both('undef ARRAY', \@y);          #    64    64
say('');

both('HASH',   \%z);                       #  120   120
%z = ('x' => undef);
both('HASH x => undef',   \%z);            #  179   203
%z = ('x' => "x");
both('HASH x => "x"',   \%z);              #  179   235
%z = ('x' x 10 => "x" x 20);
both('HASH "x" x 10 => "x" x 20',   \%z);  #  188   260
for my $c (qw(a b c d e f g h i)) {
    $z{$c x 10} = $c x 20;
}
both('HASH 10 * 10 + 10 * 20',   \%z);     #  864  1584
%z = ();
both('HASH=()',   \%z);                    #  184   184
undef %z;
both('undef HASH',   \%z);                 #  120   120
my $o = bless \%z,'Some::Very::Long::Class::Name::That::Probably::Noone::Uses';
both('blessed HASH', $o);                  #  120   120
say('');

both('CODE', sub {}  );                   #  8516  8516
both('CODE2', sub { my $w }  );           #  8612  8612
both('CODE3', sub { my $w = 'a' }  );     #  8820  8820

sub both {
    my ($name, $ref) = @_;
    printf "%-25s %5d %5d\n", $name, size($ref), total_size($ref);
}
```

## El ambiente

Estos resultados fueron generados sobre 64 bit OSX, ejecutando perl 5.18.2 usando Devel::Size 0.79.
(Obtuve el mismo resultado cuando ejecuté el escript sobre 5.18.1, excepto que los valores
para el CODE'references fueron de 8 bytes mas pequeños).



## Algunas observaciones

El tamaño del código-referencias parece enorme. Me pregunto si estos números son correctos.

Extrañamente `bless` no cambia el tamaño de la referencia. O por lo menos, no se divulga.

Se asigna memoria en trozos de 16 bytes para cadens. Por lo tanto es la memoria utilizada por una larga cadena de caracteres 1
el mismo que utiliza por una larga cadena de 15 caracteres.

Ni ajustar la cadena a la cadena vacía (`$x = '';`),
ni asignar undef a él (`$x = undef;`) reduce el uso de la memoria.
Tuve que llamar `undef $x;` por eso. Incluso entonces volvió sólo a 40, en lugar de la original 24.

En matrices, cada elemento utiliza 8 bytes + memoria asignada para el contenedor escalar + los datos.

Ajuste `@y = ();` eliminar la asignación de memoria de la fecha
(o por lo menos `total_size` no se muestra nada más)
Llamando `undef @y;` también libera la memoria asignada a la estructura.

En hashes es aún más complejo. No intento describirlo.
La documentación de Devel::Size tiene alguna explicación.


## El resultado actual se observa algo como esto

```
                          size    total_size
SCALAR                       24    24
ARRAY                        64    64
HASH                        120   120
CODE                       8452  8452

SCALAR                       24    24
SCALAR-1                     56    56
SCALAR-15                    56    56
SCALAR-16                    72    72
SCALAR-31                    72    72
SCALAR-32                    88    88
SCALAR=""                    88    88
SCALAR=undef                 88    88
undef SCALAR                 40    40

ARRAY                        64    64
ARRAY-1                      96   152
ARRAY-15                     96   152
ARRAY-16                     96   168
ARRAY-31                     96   168
ARRAY-32                     96   184
ARRAY-1-1                    96   208
ARRAY-1-1-1-1                96   320
ARRAY-1-1-1-1-1             104   384
ARRAY-1-1-1-1-1-1           112   448
ARRAY-1-1-1-1-1-1-1         128   520
ARRAY = ()                  128   128
undef ARRAY                  64    64

HASH                        120   120
HASH x => undef             179   203
HASH x => "x"               179   235
HASH "x" x 10 => "x" x 20   188   260
HASH 10 * 10 + 10 * 20      864  1584
HASH=()                     184   184
undef HASH                  120   120
blessed HASH                120   120

CODE                       8516  8516
CODE2                      8612  8612
CODE3                      8820  8820
```



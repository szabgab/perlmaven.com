---
title: "Cuanta memoria utiliza una aplicacion de Perl ?"
timestamp: 2014-08-29T19:45:01
tags:
  - Memory::Usage
  - Linux
published: true
original: how-much-memory-does-the-perl-application-use
books:
  - cook_book
author: szabgab
translator: danimera
---


El otro dia tuve una queja que mi Perl script utilizaba mucha memoria. Asi que necesite una manera de verificar esto y monitorizarlo.
Encontré [Memory::Usage](https://metacpan.org/pod/Memory::Usage) en CPAN.
Aunque solo funciona in <b>Linux</b> (ni en BSD o Mac OSX), pero fue muy util ahi. 


El uso basico de este modulo es algo asi:

```perl
use strict;
use warnings;

use Memory::Usage;

my $mu = Memory::Usage->new();
$mu->record('starting work');

# my real code

$mu->record('after creating variable');

$mu->dump();
```

Despues de crear el objeto <h1>Memory::Usage</h1>, cada llamada a <h1>record</h1> sera
guardada el actual estado de uso de memoria en el actual proceso. (Basado en el id de proceso,
procesos bifurificados no se mediran separadamente.)

El llamado del metodo <h1>dump</h1> imprimirá el dato guardado.

Cada fila representa el dato obtenido en la llamada del <h1>record</h1>. Al final de cada fila
nosotros podemos ver el texto pasado al metodo <h1>record</h1> en cada punto.
La columna en parentesis muestra los cambios de cada comparada al registro previo.

La primera fila representa la linea base, despues compila todo el script y carga cada modulo con una sentencia <h1>use</h1>

La segunda fila despues de que "mi codigo real" fue ejecudato.

```
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  18688 ( 18688)   2384 (  2384)   1756 (  1756)   1500 (  1500)    916 (   916) starting work
     0  18688 (     0)   2384 (     0)   1756 (     0)   1500 (     0)    916 (     0) after creating variable
```

Nosotros podriamos adicionar mas llamadas al `record` en varios lugares de nuestra aplicacion
para ver cual posicion nosotros podriamos ver un aumento repentino de memoria.

En nuestro caso todas las diferencia fueron 0. Obviamente, no tenemos ningun codigo entre
los dos llamado de `record`


## Memoria asignada

Vamos a intentar correr de nuevo, esta vez crearemos una cadena entre los dos llamados, entonces
reemplazaremos "Mi codigo real" con

```perl
my $x = " " x 1024;
```

Despues te correr el escript, el resultado es exactamente el mismo. La diferencia sigue siendo 0.
Aparentemente perl tiene alguna memoria asignada para un futuro llamado, entonces crear una
cadena con 1.024 bytes no requere una futura asignacion de memoria desde el sistema.

```perl
my $x = " " x 1024;
$x .= $x for 1..6;
say length $x;
```

```
65536
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  18688 ( 18688)   2384 (  2384)   1756 (  1756)   1500 (  1500)    916 (   916) starting work
     0  18840 (   152)   2512 (   128)   1832 (    76)   1500 (     0)   1068 (   152) after creating variable
```

El codigo anterior creada una cadena de 65.536 caracteres (64K). (Ese es el primer numero en la salida)
Entonces nosotros podemos ver como un cambio repentino de memoria. Los valores en el reporte son en kb.



vsz = <b>virtual memory size</b>,
rss = <b>resident set size</b>,
shared = <b>shared memory size</b>,
code = <b>text (aka code or exe) size</b>,
data = <b>data and stack size</b>

## Mas memoria asignada

4 Mb:

```perl
my $x = " " x 1024;
$x .= $x for 1..12;
say length $x;
```

```
4194304
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  18688 ( 18688)   2384 (  2384)   1756 (  1756)   1500 (  1500)    916 (   916) starting work
     0  22876 (  4188)   6500 (  4116)   1836 (    80)   1500 (     0)   5104 (  4188) after creating variable
```

Si incrementamos el dato a <h1>1..21</h1> esto crea una cadena con
2.147.483.648 (o 2Gb) caracteres. El resultado se observa como esto:

```
2147483648
  time      vsz (    diff)     rss (    diff) shared (  diff)  code (  diff)     data (    diff)
     0    18688 (   18688)    2384 (    2384)   1752 (  1752)  1500 (  1500)      916 (     916) starting work
     2  2115932 ( 2097244) 2099528 ( 2097144)   1836 (    84)  1500 (     0)  2098160 ( 2097244) after creating variable
```

En este ejemplo vemos el cambio del tiempo. Creando una cadena de 2Gb toma 2 segundos para el script


## Guardando el resultado

Imprimir el resultado en pantalla (on STDERR) con <h1>dump</h1>, puede ser util en una sesion
interactiva, pero si te gustara guardar esta informacion en segunda capa tu puedes usar
el metodo <h1>report</h1> que retorna un reporte como cadena. Entonces puedes guardarlo en un fichero.


`dump` es implementado como `print STDERR $mu->report();`

Si desea crear informes afinado aún más finos, puede llamar al método `state`
para buscar los números individuales. Por ejemplo:


```perl
$mu->dump();
my $s = $mu->state;

use Data::Dumper;
print Dumper $s;
```

Creado el siguiente reporte :

```
  time    vsz (  diff)    rss (  diff) shared (  diff)   code (  diff)   data (  diff)
     0  22092 ( 22092)   3704 (  3704)   1928 (  1928)   1500 (  1500)   2236 (  2236) starting work
     0  22092 (     0)   3704 (     0)   1928 (     0)   1500 (     0)   2236 (     0) after creating variable
$VAR1 = bless( [
                 [
                   1386844853,
                   'starting work',
                   22092,
                   3704,
                   1928,
                   1500,
                   2236
                 ],
                 [
                   1386844853,
                   'after creating variable',
                   22092,
                   3704,
                   1928,
                   1500,
                   2236
                 ]
               ], 'Memory::Usage' );
```

Arriba puedes ver el reporte generado por el metodo `dump`. Abajo puedes ver el raw data.
you can see the raw data. Para más detalles, véase
[Memory::Usage](https://metacpan.org/pod/Memory::Usage).

## Test::Memory::Usage

Comprobar que el código no utiliza mucha memoria extra es útil, pero no lo harás después de cada cambio.
Si pudieras agregar este chequeo a pruebas automáticas aunque...


[Test::Memory::Usage](https://metacpan.org/pod/Test::Memory::Usage) es un contenedor
[Memory::Usage](https://metacpan.org/pod/Memory::Usage) que tu puedes utilizar 
seguro de que tu módulo de no comenzará a utilizar mucha memoria más adelante. En Linux, por lo menos.



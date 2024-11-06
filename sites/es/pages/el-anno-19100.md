---
title: "El año 19100"
timestamp: 2013-08-03T12:45:00
tags:
  - time
  - localtime
  - gmtime
  - Time::HiRes
  - DateTime
published: true
original: the-year-19100
books:
  - beginner
author: szabgab
translator: davidegx
---


Esta parte de [Perl Tutorial](/perl-tutorial) explica <b>la fecha en Perl</b>.

Perl tiene incluida la función `time()` que devuelve un número de 10 dígitos
que representa el número de segundos transcurridos desde el 1 de enero de 1970.


```perl
$t = time();         # devuelve un numero como: 1021924103
```

Puedes usar este número como una marca de tiempo, por ejemplo para calcular el tiempo transcurrido.
Usando `time()` puedes guardar el número de segundos en un punto y después
llamar a `time()` de nuevo. Comparando el resultado de las dos llamadas:

```perl
my $t = time();
# lots of code
say 'Tiempo transcurrido: ', (time() - $t);
```

## localtime

La función `localtime()` puede recibir como parámetro
el resultado de la llamada a `time()>`, el número de 10 dígitos, y convertirlo
en algo más legible.

```perl
my $then = localtime($t);  # devuelve un texto del estilo  Thu Feb 30 14:15:53 1998
```

De hecho no hacen falta parámetros. Si se llama directamente sin parámetros usará
el valor devuelto por `time()`:

```perl
my $now = localtime();    # devuelve el texto correspondiente a la fecha actual
```

Puedes almacenar diferentes marcas de tiempo generadas por `time()` y después
usarlas para calcular tiempos transcurridos, o convertirlas a algún formato más
legible para el usuario como vimos anteriormente.

## EL otro localtime

¿Que sucede si realizamos la misma llamada a `localtime($t)` pero esta vez
asignamos el resultado a un array? ¿Esperarias obtener la misma cadena que antes
como primer elemento del array?

```perl
my @then = localtime($t);
```

El contenido del array será:

```
53 15 14 30 1 98 4 61 0
```

¿Que son estos extraños números? Si miras detenidamente, te daras cuenta
de que el primer valor corresponde a los segundos, seguido de los minutos, horas y otros
números representando el mismo punto en el tiempo. La lista completa de valores es la siguiente:

```perl
my ($sec ,$min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
```
```
$sec   - segundos (0-59)
$min   - minutos (0-59)
$hour  - horas  (0-23)
$mday  - día del mes (1-31)
$mon   - mes (0-11) - 0 es Enero, 11 es Diciembre.
$year  - Año-1900
$wday  - día de la semana (0-6), 0 corresponde al Domingo y el 1 al Lunes
$yday  - día del año (0-364 o 0-365 para años bisiestos)
$isdst - 'horario de verano activado' verdadero si el horario de verano esta activado en tu ordenador.
```

Ten en cuenta que el mes 0 representa a Enero y el 11 a Diciembre.
En el día de la semana 0 es Domingo mientras que 6 es Sabado.

Por otro lado el campo representando al día del mes varía de 1 a 28, 30 o 31 dependiendo del mes.

El campo más problemático de todos puede ser el año que puede conducir fácilmente al bug del año 2000:

## El bug del año 2000

Cuando en 1998 algunos programadores veian que `$year` era 98 y querían mostrar 1998
escribieron `"19$year"`. Funcionó entonces y también funciono en 1999, pero llego
el año 2000 y `$year` se convirtio en 100 (2000 - 1900) . El texto formateado se convirtio en <b>19100</b>.

De ahí proviene el año 19100 y así se creo el infame
<b>bug del año 2000</b>.

Si hubieran leido la documentación deberían haber escrito:

```
1900 + $year
```

que es la forma correcta de obtener el número correspondiente a nuestra fecha en el
[calendario gregoriano](http://es.wikipedia.org/wiki/Calendario_gregoriano).
El calendario más usado en el mundo.

## gmtime

Perl también dispone de la función `gmtime()` que hace lo mismo que `localtime()`,
pero siempre devuelve la hora de [Greenwich](http://es.wikipedia.org/wiki/Greenwich),
un barrio de Londres. ($isdst es siempre 0 en este caso.)

## ¿Como funciona realmente la hora?

Normalmente el reloj hardware de tu ordenador debería corresponder con la hora GMT
([tiempo medio de Greenwich](http://es.wikipedia.org/wiki/GMT))
(o [UTC](http://es.wikipedia.org/wiki/Coordinated_Universal_Time) que es más o menos lo mismo).

Tu sistema operativo (Windows, Linux, Mac OSX, Unix, etc.) debería saber la zona horaria que has
configurado, y si es horario de verano o no. `localtime()` usa estos valores
mientras que `gmtime()` simplemente usa el valor devuelto por el reloj hardware.

## Hora de alta precisión

La función `time()` devuelve la fecha actual en segundos. Por lo que no puede
medir periodos inferiores a un segundo. Si necesitas más precisión hay un modulo
llamado [Time::HiRes](https://metacpan.org/pod/Time::HiRes) que puede
sustituir el uso de `time()`.

```perl
use strict;
use warnings;
use 5.010;

use Time::HiRes qw(time);

say time;
```

Y la salida será:

```
1021924103.58673
```

## DateTime

Las funciones anteriores proporcionan información básica sobre la hora y la fecha,
probablemente es mejor usar el modulo [DateTime](https://metacpan.org/pod/DateTime) para cualquier necesidad no trivial.

Lo veremos más adelante.

## Conciencia del contexto

Todo lo anterior es importante, pero hay algo vital que hemos
saltado al ver la función `localtime()`.

Si observas el ejemplo de `localtime()`, verás que `localtime()`
de alguna manera sabe si el valor devuelto será asignado a una variable escalar o a un array y
devuelve un valor legible o la representación de 9 dígitos dependiendo del caso.

Esta es una característica general de Perl 5. Una característica muy importante, y aprenderemos
mucho más sobre ella. Lo importante es entender que en muchas situaciones Perl es <b>sensible al contexto</b>.




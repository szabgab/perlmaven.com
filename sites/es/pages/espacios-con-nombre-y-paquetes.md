---
title: "Espacios con nombre y paquetes en Perl"
timestamp: 2017-10-07T12:00:11
tags:
  - package
types:
  - screencast
published: true
author: szabgab
books:
  - advanced
translator: nselem
original: namespaces-and-packages
---




Previamente estudiamos [los problemas con las librerías estilo Perl 4](/the-problem-with-libraries). veamos una mejor solución
utilizando los espacios-con-nombre de Perl 5.


<slidecast file="advanced-perl/libraries-and-modules/namespaces" youtube="VdtJqpD2ARA" />

Otros lenguajes también utilizan espacios con nombre. En Perl 5, para cambiar de espacio con nombre utilizamos la palabra reservada
`package`. (Para una mayor esplicación sobre espacios con nombre, paquetes, módulos etc. te recomendamos leer [este artículo](/packages-modules-and-namespace-in-perl).)

Nosotros cambiamos a un espacio con nombre al escribir `package` seguido del nombre del espacio deseado. Por ejemplo
`Calc` en nuestro ejemplo anterior. Los espacios con nombre usualmente empiezan con una letra mayúscula seguida de minúsculas, aunque esto una convención, no es algo obligatorio en Perl.

En este script hemos puesto `use strict;` y `use warnings;` porque ya entramos al nuevo milenio.

Asi que tenemos `package Calc;` lo que significa que de ahora en adelante, el codigo que escribamos en el espacio con nombre Calc hasta que llamemos a `package` otra vez con algun otro espacio con nombre. Cargamos `use strict;` y `use warnings`
otra vez, an cuando no lo necesitamos ahi, pero stamos planeando mover el cdifo del paquete a otro archivo y ahi lo queremos como parte del código. Después agregamos funciones. (OK, en este ejemplo hay una sola función que llamamos `add`, bpero no dejes que estas minucias te distraigan. Tu puedes poner cualquier número de funciones en el espacio nombrado.)

Después, regresamos al pauete principal escribiendo `package main;`.

Esto algo de no que habamos hablad porque no había necesidad, pero cuando empiezas a escribir un script de perl es reamente dentro de un espacio llamado `main`. En la mayoría de los casos no tenemos nada que hacer con el, pero ahora es útil, de manera que podemos regresar al espacio con nombre del script main.El nombre es probablemente una reminiscencia del lenguaje de programación C donde se tiene que declarar una funcin main si se quiere tener algo corriendo.

Nota, se llama `main` solo minúsculas.

Asúi pues, despues de la declaración del paquete `package main;` estamos otra vez en el espacio nombrado main.Si ahora tratamos de llamar la función `add` usando `add(3, 4)`, tendremos una excepción y el script morirá con
<b>Undefined subroutine &main::add called  at namespaces.pl line 20.</b>.

Esto es porque no tenemos una función `add` en el espacio con nombre main. En lugar de eso tenemos que escribir el nombre completo de la función, incluyendo el espacio con nombre separado por doble signo de dos puntos:
`Calc::add(3, 4)`

<b>namespaces.pl</b>:

```perl
#!/usr/bin/perl
use strict;
use warnings;

package Calc;
use strict;
use warnings;

sub add {
    my $total = 0;
    $total += $_ for (@_);
    return $total;
}


package main;

print Calc::add(3, 4), "\n";
```

Así es como creamos un `package` y así es como creamos espacios con nombre en Perl 5.

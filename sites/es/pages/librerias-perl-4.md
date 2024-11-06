---
title: "librerias Perl 4"
timestamp: 2017-02-03T23:00:11
tags:
  - require
books:
  - advanced
types:
  - screencast
published: true
author: szabgab
original: perl4-libraries
translator: nselem
---


Vamos a hablar sobre libreras y módulos en Perl.

En este capítulo explicaremos cómo funcionan las libreras en Perl. Esto es algo de la época de Perl 4.


<slidecast file="advanced-perl/libraries-and-modules/perl4-libraries" youtube="ehcarfOHgEg" />

## Falta de reutilización de código

Mientras escribes más y más código en perl, prroducirás más y más scripts y en algunos de ellos 
tendrás funciones que hacen los mismo. Tal vez lo resuelves copiando la función que escribiste antes en un script
pero necesitas en el otro.I Si continuas en esa dirección tendrás toneladas de código, y una gran parte de 
la base del código serán pedazos o incluso funciones enteras de código copiado de un lado a otro.

El principal problema es el mantenimiento, si tu quieres hacer un cambio en una función ya sea por un nuevo
requerimiento o porque encontraste un error, tendrás que recorrer todos tus scrips, localizar copias de esa función
y arreglar el problema en todos esos lugares. Va a ser desagradable, y pronto se te escaparán algunos scripts
y el mismo error que ya arreglaste en un script aparecerá unas semanas más tarde en uno que olvidaste revisar.

El problema es la falta de reutilización de código.

En Perl 4 la solución era crear librerías.

Primero vamos a aprender cómo usar librerías. No porque sea una forma recomendada de trabajar, sino porque
aún hay muchas sitios donde se sigue usando y es importante para ti entender qué está pasando, 
y hasta tal vez cambiar el código hacia técnicas más modernas.

En este ejemplo tenemos dos archivos. Ambos con la extensión.pl.

<b>library.pl</b> es el archivo que contiene las funciones en común así como las variables.

```perl
$base = 10;

sub add {
    validate_parameters(@_);

    my $total = 0;
    $total += $_ for (@_);
    return $total;
}

sub multiply {
}

sub validate_parameters {
    die 'Not all of them are numbers'
        if  grep {/\D/} @_;
    return 1;
}

1;
```

<b>perl4_app.pl</b> es la aplicación "application", o el "script" que correrá. Usa las funciones del script de arriba.

```perl
#!/usr/bin/perl

require "examples/modules/library.pl";

print add(19, 23);
print "\n";
print "$base\n";
```


El script (<b>perl4_app.pl</b>) comienza con la linea [sh-bang](/hashbang). No contiene `use strict;` no tampoco utiliza `use warnings;`. 
Recuerda, este es código de estilo Perl 4. Estas [redes de seguridad](/installing-perl-and-getting-started)
no estuvieron disponibles hasta Perl 5.

Así pues cargamos la librería con la instrucción `require` incluyendo la ruta absoluta (o relativa) al archivo de la librería.

Y ahora podemos usar las funciones declaradas en la libería, incluso podemos usar las variables declaradas en la librería.

Crear la librería fue fácil. Fue sólo un script común en Perl con la extensión .pl que de hecho significa "perl library".
En ese archivo no debemos usar tampoco `use strict;` o `use warnings;`.

Incluso en este archivo no tenemos la linea sh-bang, porque no es un archivo que vayas a correr directamente.

Se tienen valores asignados a variables globales (no declaradas con `my`) y subrutinas (funciones) definidas. La función `multiply` 
la definimos sólo para recordarnos que existen otras funciones además de la función `add`.
También está la función `validate_parameters` que únicamente es usada por la función `add` 
nunca será llamada por un usuario de esta librería. Por ello, la función `validate_parameters` es una función interna.
 El archivo termina con `1;` que es un valor [true](/boolean-values-in-perl). Toda librería y módulo de Perl
 necesitan regresar un valor verdadero.
 
 Si olvidas el valor `1;` al final del archivo y corres el script `perl4_app.pl`, tendrás un error parecido a este:
 ```
 library.pl did not return a true value
 ```

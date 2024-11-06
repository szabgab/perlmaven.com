---
title: "Depurando scripts Perl"
timestamp: 2014-03-05T19:45:57
tags:
  - -d
  - Data::Dumper
  - print
  - debug
  - debugging
  - $VAR1
  - $VAR2
published: true
original: debugging-perl-scripts
books:
  - beginner
author: szabgab
translator: davidegx
---


Cuando estudié ciencias de la computación en la universidad aprendimos mucho sobre como escribir programas,
pero nadie nos hablo sobre depuración. Escuchamos acerca del maravilloso mundo de crear
nuevas cosas, pero nadie nos dijo que la mayoría del tiempo la pasaremos intentando entender el código
hecho por otras personas.

Preferimos escribir nuevo código, sin embargo pasamos mucho más tiempo intentando entender el código ya escrito
y porqué se comporta de forma errónea que el que empleamos originalmente.


## ¿Que es la depuración?

Antes de ejecutar un programa todo estaba en estado conocido y correcto.

Después de ejecutarlo pasa algo inesperado, se produce un estado erróneo.

La tarea es averiguar en que punto algo fue mal y corregirlo.

## ¿Que es programar y que es un bug?

Básicamente programar es cambiar el mundo un poco moviendo datos contenidos en variables.

En cada paso cambiamos los datos contenidos en alguna variable del programa, o algo en el "mundo real". (Por ejemplo en el disco o en la pantalla.)

Cuando escribes un programa piensas en cada paso: que valor debería ser movido a que variable.

Un bug es un caso en el que pensaste que pusiste un valor X en alguna variable cuando en realidad Y fue lo que se uso.

En algún momento, normalmente al final del programa, puedes ver que el programa mostró un valor incorrecto.

Durante la ejecución del programa se puede manifestar en la aparición de warnings o la terminación inesperada del programa.

## ¿Como depurar?

La forma más directa de depurar un programa es ejecutarlo, y en cada paso comprobar que todas las variables
tienen los valores esperados. Puedes hacer esto <b>usando un debugger</b> o puedes incluir <b>sentencias print</b> en el
programa y examinar la salida posteriormente.

Perl viene con un potente debugger en línea de comandos. Recomiendo aprenderlo aunque puede intimidar
un poco al principio. He preparado un vídeo mostrando los 
[comandos básicos del debugger integrado en Perl (en)](https://perlmaven.com/using-the-built-in-debugger-of-perl).

IDEs, como [Komodo](http://www.activestate.com/),
[Eclipse](http://eclipse.org/) y 
[Padre](http://padre.perlide.org/) vienen con un debugger gráfico. En el futuro también haré un vídeo sobre ellos.

## Sentencias print

Mucha gente usa la vieja estrategia de usar sentencias print en el código.

En un lenguaje donde el tiempo de compilación pude ser grande incluir sentencias print
para depurar el código es considerado una mala forma de hacerlo.
No es así en Perl, incluso aplicaciones grandes compilan y empiezan a ejecutar en unos pocos segundos.

Al añadir sentencias print hay que tener cuidado de añadir delimitadores alrededor de las variables. De esta
forma se verá si hay espacios al inicio o final de un valor que pueden causar problemas.
Estos casos son difíciles de ver si no se añaden ningún delimitador:

Los valores escalares pueden ser mostrados así:

```perl
print "<$file_name>\n";
```

En este ejemplo los signos de menor y mayor que simplemente sirven para hacer más fácil
leer el contenido exacto de la variable:

```
<path/to/file
>
```

Si algo parecido a lo anterior aparece en la pantalla te darás cuenta rápidamente del retorno de carro
extra al final de la variable $file_name. Probablemente olvidaste llamar a la función <b>chomp</b>.

## Estructuras de datos complejas

Todavía no hemos aprendido variables escalares, pero daré un salto hacía adelante para
mostrar como mostrar el contenido de estructuras de datos complejas. Si estas leyendo
esto como parte del tutorial de Perl quizás quieras saltar a la siguiente entrada y volver más tarde.

En caso contrario, continua leyendo.

Para estructuras de datos complejas (referencias, arrays y hashes) puedes usar `Data::Dumper`

```perl
use Data::Dumper qw(Dumper);

print Dumper \@an_array;
print Dumper \%a_hash;
print Dumper $a_reference;
```

Esto mostrará algo como:

```
$VAR1 = [
       'a',
       'b',
       'c'
     ];
$VAR1 = {
       'a' => 1,
       'b' => 2
     };
$VAR1 = {
       'c' => 3,
       'd' => 4
     };
```

Que ayuda a entender el contenido de las variables, pero solo muestra un nombre
de variable genérico como `$VAR1` o `$VAR2` 

Recomiendo añadir algo más de código y mostrar el nombre de la variable como:

```perl
print '@an_array: ' . Dumper \@an_array;
```

que mostrará:

```
@an_array: $VAR1 = [
        'a',
        'b',
        'c'
      ];
```

o así:

```perl
print Data::Dumper->Dump([\@an_array, \%a_hash, $a_reference],
   [qw(an_array a_hash a_reference)]);
```

que devolverá:

```
$an_array = [
            'a',
            'b',
            'c'
          ];
$a_hash = {
          'a' => 1,
          'b' => 2
        };
$a_reference = {
               'c' => 3,
               'd' => 4
             };
```

Hay otras formas más elegantes de mostrar estructuras de datos pero de momento
`Data::Dumper` es suficientemente bueno para lo que necesitamos y esta disponible
en todas las distribuciones de Perl.
Veremos otros métodos más adelante.


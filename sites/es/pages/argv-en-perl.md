---
title: "@ARGV en Perl"
timestamp: 2013-12-05T20:11:10
tags:
  - "@ARGV"
  - "$ARGV[]"
  - $0
  - shift
  - argc
published: true
original: argv-in-perl
books:
  - beginner
author: szabgab
translator: davidegx
---


Si escribes un script Perl, por ejemplo <b>programming.pl</b>,
los usuarios pueden ejecutar el script en la línea de comandos usando <b>perl programming.pl</b>.

También pueden pasar parámetros como <b>perl programming.pl -a --machine remote /etc</b>.
No hay nada que impida a los usuarios hacerlo, el script descartará esos valores.
La cuestión es como puedes saber que parámetros fueron enviados al script.


## La línea de comandos

Perl proporciona automáticamente un array llamado `@ARGV`, que contiene todos los valores enviados desde
la línea de comandos.
No tienes que declarar esta variable, incluso si usas `use strict`.

Esta variable siempre existe y contiene los valores pasados desde la línea de comandos de forma automática.

Si no hay parámetros, el array estará vacío. Si solo hay uno ese será el único elemento en `@ARGV`. En
el ejemplo anterior `@ARGV` contendrá:
-a, --machime, remote, /etc

Veámoslo en acción, guarda este código como <b>programming.pl</b>:

```perl
use strict;
use warnings;
use Data::Dumper qw(Dumper);

print Dumper \@ARGV;
```

Ejecuta: `perl programming.pl -a --machine remote /etc` y este será el resultado:

```
$VAR1 = [
          '-a',
          '--machine',
          'remote',
          '/etc'
        ];
```

Como puedes ver usamos `Dumper` del modulo `Data::Dumper` para mostrar
el contenido de `@ARGV`

Si vienes de otro lenguaje de programación puedes preguntarte:
<b>¿Donde esta el nombre del programa?</b>

## El nombre del script esta en $0

El nombre del programa que esta siendo ejecutado, en el ejemplo anterior <b>programming.pl</b>, esta siempre
en la variable `$0`. (Ten en cuenta que `$1`, `$2`, etc. son variables que no tienen nada
que ver)

## Programador C

En caso de que sepas programar en C, <b>argv</b> es similar a <b>@ARGV</b>, pero <b>@ARGV</b> en
Perl <b>no</b> contiene el nombre del programa.
Puedes encontrarlo en la variable `$0`. Además una variable como <b>argc</b> no es necesaria,
puedes obtener fácilmente el [ número de elementos en el array @ARGV](/contexto-escalar-y-lista-en-perl) usando la función
`scalar` o evaluando el array en [contexto escalar](/contexto-escalar-y-lista-en-perl).

## Programación Unix/Linux

Si provienes del mundo de la <b>programación Unix/Linux Shell</b> reconocerás que la variable `$0`
es el nombre del script también. Sin embargo, en shell `$1`, `$2`, etc. contienen el resto
de los parámetros enviados al script. Estas variables son usadas por las expresiones regulares de Perl.
Los parámetros de la línea de comandos están en `@ARGV`. Similar a `$*` en Unix/Linux shell.

## Como obtener los parámetros desde @ARGV

`@ARGV` es simplemente un [array Perl](arrays-en-perl).
La única diferencia con los arrays que tú creas, es que no hay necesidad de declararlo
y es rellenado automáticamente por Perl cuando el programa arranca.

Aparte de eso, puedes manipularlo como un [array](https://perlmaven.com/perl-arrays) normal.
Puedes iterar sobre sus elementos usando `foreach`, o acceder a uno de ellos usando un índice: `$ARGV[0]`.

También puedes usar [shift, unshift, pop o push](https://perlmaven.com/manipulating-perl-arrays) en este array.

De hecho no solo puedes obtener el contenido de `@ARGV`, también puedes modificarlo.

Si esperas un solo valor puedes comprobar su valor mirando `$ARGV[0]`. Si esperas
dos valores el segundo valor estará en `$ARGV[1]`.

Como ejemplo crearemos una agenda sencilla. Si proporcionas un nombre la aplicación mostrará
el teléfono correspondiente. Si indicas un nombre y un número el programa guardará esos valores
en la "base de datos". (No realizaremos el código relacionado con la base de datos, simplemente
imaginaremos que esta ahí.)

Sabemos que los parámetros llegarán en `$ARGV[0]` y quizás también en `$ARGV[1]`, pero
estos valores no tienen ningún significado aparte de ser el primer y segundo elemento del array.
Normalmente es mejor usar tus propias variables en el código en lugar de $ARGV[0] y similares.
Por tanto lo primero que haremos será copiar estos valores a variables con nombres más apropiados:

Por ejemplo:

```perl
my $name   = $ARGV[0];
my $number = $ARGV[1];
```

O mejor todavía:

```perl
my ($name, $number) = @ARGV;
```

Veamos un ejemplo completo (excepto por la parte de la base de datos).
Guarda el siguiente código en <b>programming.pl</b>.

```perl
use strict;
use warnings;

my ($name, $number) = @ARGV;

if (not defined $name) {
  die "Need name\n";
}

if (defined $number) {
  print "Save '$name' and '$number'\n";
  # guarda el nombre/número en la base de datos
  exit;
}

print "Fetch '$name'\n";
# busca el nombre en la base de datos y lo muestra
```

Después de copiar los valores de `@ARGV`, comprobamos si se proporcionó un nombre.
Si no, llamamos a `die` que mostrará un mensaje de error y saldrá del script.

Si había un nombre, comprobaremos el número. Si hay un número lo guardaremos
en la base de datos (que no esta implementada) y saldremos del script.

Si no hay número se buscará en la base de datos. (De nuevo, no implementado.)

Veamos como funciona: (El símbolo $ solo marca el prompt, no hay que escribirlo.)

```
$ perl programming.pl Foo 123
Guarda 'Foo' y '123'

$ perl programming.pl Bar 456
Guarda 'Bar' y '456'

$ perl programming.pl John Doe 789
Guarda 'John' y 'Doe'
```

Las dos primeras llamadas fueron correctas, pero la última no.
Nuestra intención era guardar el teléfono de "John Doe", pero en su lugar
nuestro script guardo el teléfono de "Jonh" como si fuese "Doe".

La razón es simple, y no tiene nada que ver con Perl. Funcionaría de la misma manera en otros lenguajes.
La línea de comandos, donde ejecutas los scripts desarma la línea y pasa los valores a perl que entonces los
pone en `@ARGV`. Tanto como la shell de Unix/Linux y la línea de comandos en Windows dividen la línea
en cada espacio. Cuando escribimos `perl programming.pl Jonh Doe 789`, la shell pasará 3 parámetros
a nuestro script. Para hacerlo funcionar de manera correcta el usuario debe poner los valores que tienen
espacios entre comillas:

```
$ perl a.pl "John Doe" 789
Guarda 'John Doe' y '789'
```

Como programador no puedes hacer mucho acerca de este problema.

## Comprobando los parámetros

Quizás puedas comprobar que el número de elementos no sobrepase el número de parámetros que esperas.
Evitaría que el usuario cometiese el error anterior, pero si el usuario quiere obtener
el número de Jonh Doe y olvida las comillas:

```
perl a.pl John Doe
Guarda 'John' y 'Doe'
```

En este caso hay 2 parámetros que es el número correcto.

Aquí también se puede hacer una pequeña mejora comprobando que el contenido de la variable `$number`
tiene un formato correcto para ser aceptado como número de teléfono. Esto reduciría la posibilidad de 
cometer errores para este caso.
No sería perfecto y no es una solución universal: en otros programas puede haber varios parámetros
que sean del mismo tipo.

Desafortunadamente no hay mucho que podamos hacer cuando analizamos `@ARGV` manualmente.
En otro articulo hablaré sobre `Getopt::Long` y librerías similares que pueden hacer la vida
un poco más sencilla.

## Obtener un único parámetro con shift

Un caso típico es cuando esperas que el usuario proporcione un único fichero en la línea de comandos.
En ese caso puedes escribir el siguiente código:

```perl
my $filename = shift or die "Usa: $0 FILENAME\n";
```

Partamos la línea en dos partes para entenderlo mejor:
`my $filename = shift`

Normalmente [shift](https://perlmaven.com/manipulating-perl-arrays) recibe un array como parámetro
pero en este caso la usamos sin ningún parámetro. Cuando no hay ningún parámetro  shift usa por defecto
la variable `@ARGV`. (Si el código no esta dentro de una función)

Después tenemos el siguiente código:
`$filename or die "Usa: $0 FILENAME\n"`

Esto es una expresión [booleana](/valores-booleanos-en-perl).
Si `$filename` contiene el nombre de un fichero entonces será
[considerado Verdadero](/valores-booleanos-en-perl) y el script continuará
sin ejecutar la parte `or die ...`.
Por otro lado, si @ARGV estaba vacío, `undef` será asignado a `$filename`,
y la expresión será [considerada Falsa](/valores-booleanos-en-perl)
y Perl ejecutará la parte derecha del la sentencia `or`, mostrando un mensaje
en la pantalla y saliendo del script.

Básicamente este fragmento de código comprueba si un parámetro fue pasado desde la línea
de comandos y lo copia a la variable `$filename`. Si no se proporciono ningún valor
el script terminará con error mediante `die`

## Pequeño bug

Hay un pequeño error en el código anterior. Si el usuario tiene un fichero con llamado 0 la expresión
será Falsa y el script no podrá procesar ese fichero. La cuestión es: ¿Realmente importa?
¿Podemos vivir con el hecho de que nuestro script no sea capaz de procesar un fichero llamado <b>0<b/>?

## Casos complejos

Hay un montón de casos que son mucho más complicados que el ejemplo anterior.
En dichos casos probablemente te interese usar un modulo como `Getop::Long` que es capaz
de analizar el contenido de `@ARGV` en base a una declaración de los parámetros que quieres
recibir en tu script.




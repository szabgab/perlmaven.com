---
title: "Abrir y leer archivos de texto"
timestamp: 2014-06-09T14:00:56
tags:
  - open
  - <$fh>
  - read
  - <
  - encoding
  - UTF-8
  - die
  - open or die
published: true
original: open-and-read-from-files
books:
  - beginner
author: szabgab
translator: lenieto3
---


En esta parte de [Perl tutorial](/perl-tutorial) vamos a ver <b>cómo leer desde un fichero en Perl</b>.

Esta vez, nos vamos a enfocar en archivos de texto.


Hay dos formas comunes de abrir un fichero dependiendo de cómo le gustaría manejar los casos de error.

## Excepción

Caso 1: Lanzar una excepción si no puede abrir el fichero:

```perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
```

## Advertir o guardar silencio

Caso 2: Dar una advertencia si no puede abrir el fichero, pero seguir corriendo:

```perl
use strict;
use warnings;

my $filename = 'data.txt';
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Could not open file '$filename' $!";
}
```

## Explicación

Veámoslos explicados:

Primero, usando un editor de texto, crear un fichero llamada 'data.txt' y agregarle unas pocas líneas:

```
Primera fila
Segunda fila
Tercera fila
```

Abrir un fichero para lectura es muy similar a como [se abre para escritura](https://perlmaven.com/writing-to-files-with-perl), pero en lugar del signo "mayor que" (`>`), usamos el signo "menor que" (`<`).

Esta vez también configuramos la codificación como UTF-8. En la mayoría del código usted verá sólo el signo "menor que".

```perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my $row = <$fh>;
print "$row\n";
print "hecho\n";
```

Una vez tenemos el manejador de fichero (fh) podemos leer desde él usando el mismo operador leer línea que fue usado para [leer desde el teclado (STDIN)](/instalacion-y-primeros-pasos-con-perl).
Esto leerá la primer línea del fichero.
Luego imprimimos el contenido de $row e imprimimos "hecho" sólo para aclarar que llegamos al final de nuestro ejemplo.

Si corre el script de arriba verá que imprime

```
Primera fila

done
```

Podrías preguntarte ¿por qué hay una línea en blanco antes de "hecho"?.

Esto es porque el operador leer línea lee toda la línea, incluyendo el salto de línea.

Así como en el caso de leer desde STDIN, acá tampoco, necesitamos ese salto de línea así que usaremos `chomp()` para removerlo.

## Leer más de una línea

Una vez que sabemos como leer una línea podemos ir más adelante y poner la llamada a leer línea en la condición de un ciclo `while`.

```perl
use strict;
use warnings;

my $filename = $0;
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
print "done\n";
```

Cada vez que alcanzamos la condición del ciclo `while`, primero se ejecutará `my $row = <$fh>`, la parte que leerá la siguiente línea del fichero. Si esa línea tiene algo, se evaluará como verdadero en el contexto booleano.

Después de que leemos la última línea, en la siguiente iteración el operador leer línea (`<$fh>`) retornará undef lo cual es falso. El ciclo while terminará.

<h3>Un caso extremo</h3>

Sin embargo hay un caso extremo cuando la última línea tiene sólo un 0 en ella, sin un salto de línea.
El código de arriba evaluará esa línea como falsa y el ciclo no se ejecutará. Afortunadamente, Perl en realidad está haciendo trampa acá. En este caso muy específico (leer una línea de un fichero en un ciclo while), perl actuará como si hubiera escrito `while (defined my $row = <$fh>) {` y entonces incluso tales líneas se ejecutarán adecuadamente.

## abrir sin die

La forma de manejar ficheros de arriba es usada en los scripts perl cuando necesariamente tiene que tener el fichero abierto o no tiene sentido seguir ejecutando su código.
Por ejemplo cuando todo el trabajo de su script es analizar ese fichero.

¿Y qué si es un fichero de configuración opcional? si puede leerlo cambia algunas configuraciones, si no puede sólo usa las configuraciones por defecto.

En ese caso la segunda solución puede ser una mejor manera de escribir su código.

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Could not open file '$filename' $!";
}
```

En este caso revisamos el valor retorno de `open`.
Si es verdadero seguimos y leemos el contenido del fichero.

Si esto falló, damos una advertencia usando la función integrada `warn` pero no lanzamos una excepción. Ni siquiera necesitamos incluir la parte `else`.

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
}
```


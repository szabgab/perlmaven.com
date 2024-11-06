---
title: "POD - Plain Old Documentation"
timestamp: 2014-03-17T18:40:59
tags:
  - POD
  - perldoc
  - =head1
  - =cut
  - =pod
  - =head2
  - documentation
  - pod2html
  - pod2pdf
published: true
original: pod-plain-old-documentation-of-perl
books:
  - beginner
author: szabgab
translator: davidegx
---


A los programadores normalmente no les gusta escribir documentación. En parte
es porque los programas son ficheros de texto plano y a menudo
tienen que escribir documentación en algún procesador de textos.

Para ello hay que aprender como funciona el procesador de textos y se pierde
mucho tiempo intentando que la documentación "sea bonita" en lugar de "tener
buen contenido".

En Perl no es así. Normalmente la documentación se escribe dentro
de los módulos junto con el código y se delega en una herramienta
para formatear esta documentación y que quede bonita.


En este capítulo del [Tutorial Perl](/perl-tutorial)
veremos <b>POD - Plain Old Documentation</b>, que es un lenguaje
de marcado usado por los programadores perl.

Un código sencillo con POD es algo así:

```perl
#!/usr/bin/perl
use strict;
use warnings;

=pod

=head1 DESCRIPTION

El script tiene 2 parámetros. El nombre o la dirección de una maquina
y un comando. Ejecutara el comando en la maquina proporcionada y
mostrara la salida en la pantalla.

=cut

print "Aqui viene el codigo... \n";
```

Si guardas este código como `script.pl` y lo ejecutas usando `perl script.pl`,
perl descartará cualquier cosa entre las líneas `=pod` y `=cut`.
Solo ejecutará el código real.

Por otro lado, si ejecutas `perldoc script.pl`, el comando <b>perldoc</b>
descartará todo el código. Obtendrá las líneas entre `=pod` y `=cut`,
las formateará según ciertas reglas y mostrará el resultado en la pantalla.

Estas reglas dependerán de tu sistema operativo, pero son exactamente las mismas
que vimos en 
[Documentación del núcleo de Perl y los módulos CPAN](/documentacion-nucleo-perl-modulos-cpan).

La ventaja de usar documentación embebida POD es que tu código nunca carecerá de
documentación por accidente, porque esta dentro de los propios modulos y scripts.

## ¿Demasiado simple?

La idea es que eliminando complicaciones para escribir documentación, más
gente documentará el código. En lugar de aprender como usar algún procesador
de textos para crear documentos elegantes, puedes simplemente escribir texto
con algunos pocos símbolos extra y obtienes una documentación razonablemente
elegante. (Echa un ojo a la documentación en [Meta CPAN](http://metacpan.org/)
para ver una versión de POD formateada con un estilo moderno.)

## El lenguaje de marcado

Puedes encontrar una descripción del [lenguaje de marcado POD](http://perldoc.perl.org/perlpod.html)
escribiendo [perldoc perlpod](http://perldoc.perl.org/perlpod.html).

Hay unos pocas marcas como `=head1` o `=head2`
que marcan "encabezados importantes" o "encabezados algo menos importantes".
La marca `=over` proporciona sangrado e `=item`
permite crear listas, hay unas pocas más.

`=cut` marca el final de una sección POD y 
`=pod` el inicio. Aunque esta última no es necesaria.

Cualquier texto que empiece con el signo `=` como primer carácter será
interpretado como una marca POD, y comenzará una sección POD que será cerrada
por `=cut`.

POD también permite crear enlaces usando la notación L&lt;some-link>.

El texto entre las marcas será mostrado como párrafos en un texto plano.

Si el texto no empieza en el primer carácter de la línea será mostrado tal
cual sea escrito: las líneas largas no se partirán y las líneas cortas seguirán
siendo cortas. Esto se usa para ejemplos de código.

Una cosa importante que hay que recordar es que POD requiere líneas vacías alrededor
de las marcas.
Por ejemplo

```perl
=head1 Title
=head2 Subtitle
Some Text
=cut
```

no funcionará de la forma esperada.

## La apariencia

POD como lenguaje de marcado no define como se deberían mostrar las cosas.
Define que `=head1` indica algo importante, y que `=head2` indica algo menos importante.

La herramienta usada para mostrar POD normalmente usará letras más grandes para mostrar
el texto head1 que para el texto head2. El control esta en las manos del programa
usado para mostrar la documentación.

El comando `perldoc` que viene incluido con perl muestra la documentación
POD como páginas [man](http://es.wikipedia.org/wiki/Man_%28Unix%29). Es bastante útil en Linux.
No tan conveniente en Windows.

El módulo [Pod::Html](https://metacpan.org/pod/Pod::Html) proporciona
otra herramienta de línea de comandos llamada `pod2html`. Esta herramienta
convierte el código POD en un documento HTML que puede verse en un navegador.

Hay otras herramientas para generar ficheros pdf o mobi desde POD.

## ¿Quien es el lector?

Después de ver esta técnica, ¿quien es la audiencia?

Los comentarios (que empiezan con #) son explicaciones para
los programadores que tienen que mantener el código, añadir
nuevas características o solucionar problemas.

La documentación escrita en POD es para los usuarios. Personas que
no necesitan mirar al código fuente. En el caso de una aplicación
serían usuarios finales.

En el caso de módulos Perl, los usuarios son otros programadores Perl
que necesitan crear aplicaciones u otros módulos. Ellos tampoco necesitan
mirar el código fuente. Deberían ser capaces de usar tu modulo simplemente
leyendo la documentación mediante el comando `perldoc`.


## Conclusión

Escribir documentación y que tenga buena apariencia no es difícil en Perl.




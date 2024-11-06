---
title: "Documentación del núcleo de Perl y los módulos CPAN"
timestamp: 2013-07-27T10:45:56
published: true
original: core-perl-documentation-cpan-module-documentation
books:
  - beginner
author: szabgab
translator: ileiva
---


Perl viene con mucha documentación pero toma un tiempo aprender a usarla.
En esta parte del [Tutorial de Perl](/perl-tutorial) explicaré como
entender la documentación.



## perldoc en la web

La mejor manera de acceder a la documentación del núcleo de Perl es visitar
el sitio web de [perldoc](http://perldoc.perl.org/).

Contiene una versión HTML de la documentación de Perl, el lenguaje y los
módulos que vienen con el núcleo de Perl.

No contiene documentación de los módulos CPAN. 
Hay una superposición, sin embargo, ya que hay algunos módulos que están disponibles
en CPAN y que también vienen incluidos en la distribución estándar de Perl (a menudo
referidos como de doble vida o <i>dual-lifed</i>).

Puedes usar la opción de búsqueda en la esquina superior derecha. Por ejemplo, puedes
escribir `split` y obtendrás la documentación para `split`.

Desafortunadamente, esta opción no sabe como comportarse con `while`, ni con
`$_` o `@_`. Para obtener información sobre ellos tendrás que
<i>hojear</i> la documentación.

Una de las páginas más importante es [perlvar](http://perldoc.perl.org/perlvar.html),
en donde puedes encontrar información acerca de variables tales como `$_` y `@_`.

[perlsyn](http://perldoc.perl.org/perlsyn.html) explica la sintáxis de Perl, 
incluyendo el [bucle while](https://perlmaven.com/while-loop).

## perldoc en la línea de comandos

La misma documentación viene con el código fuente de Perl, pero no todas
las distribuciones de Linux la traen instalada por defecto. En algunos casos viene
en un paquete separado. Por ejemplo, en Debian y Ubuntu está en el paquete 
<b>perl-doc</b>. Para acceder a ella debes instalar el paquete con el comando
`sudo aptitude install perl-doc`.

Una vez que la tienes instalada, puedes escribir `perldoc perl` en la línea
de comandos y obtendrás algunas explicaciones junto con una lista de los capítulos
de la documentación de Perl.

Puedes salir de ella usando la tecla `q` y luego escribir el nombre de alguno
de los capítulos. Por ejemplo: `perldoc perlsyn`.

Esto funciona tanto en Linux como en Windows, aunque el paginador de este último
deja mucho que desear, así que no lo recomiendo. En Linux se utiliza el lector
habitual de las páginas man, por lo que ya deberías estar familiarizado con su uso.


## Documentación de módulos CPAN

Todo módulo en CPAN viene con documentación y ejemplos.
La calidad de dicha documentación varía bastante entre autores, 
e incluso un solo autor puede tener módulos muy bien documentados y 
otros no tanto.

Después de instalar un módulo llamado Modulo::Nombre, puedes
acceder a su documentación escribiendo `perldoc Modulo::Nombre`.

Aunque existe una manera más conveniente que ni siquiera necesita que
el módulo en cuestión esté instalado. Hay varias interfaces web para CPAN.
Las principales son [Meta CPAN](http://metacpan.org/)
y [search CPAN](http://search.cpan.org/).

Ambos están basados en la misma documentación pero proporcionan una experiencia
ligeramente distinta.


## Búsqueda por palabra clave en Perl Maven

En este sitio puedes usar la búsqueda por palabra clave que está en el 
menú de la barra superior. De a poco encontrarás explicaciones para
más y más partes de Perl. En algún punto se incluirán la documentación
del núcleo de Perl y los módulos CPAN.

Si no encuentras algo, solo deja un comentario con las palabras clave que
buscas y tendrás una buena oportunidad que tu solicitud sea considerada.


---
title: "Instalación y primeros pasos con Perl"
timestamp: 2014-03-17T21:45:56
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
types:
  - screencast
published: true
original: installing-perl-and-getting-started
books:
  - beginner
author: szabgab
translator: davidegx
---


Esta es la primera parte del [Tutorial Perl](/perl-tutorial).

En esta parte aprenderás como instalar Perl en Microsoft Windows y como empezar
a usarlo en Windows, Linux o Mac.

Te daré algunas directrices sobre como configurar tu entorno de desarrollo, en otras
sencillas: ¿que editor o IDE usar para escribir Perl?

Veremos el típico ejemplo "Hola mundo".


## Windows

Para Windows usaremos [DWIM Perl](http://dwimperl.szabgab.com/). Es un paquete
que contiene el compilador/interprete de Perl, [Padre, el IDE Perl](http://padre.perlide.org/)
y unas cuantas extensiones de CPAN.

Para empezar entra en [DWIM Perl](http://dwimperl.szabgab.com/)
y pincha en el enlace para descargar <b>DWIM Perl para Windows</b>.

Continua, descarga el fichero exe e instálalo en tu sistema. Antes de hacerlo
asegúrate de que no tienes otra versión de Perl instalada.

Varias versiones podrían funcionar en el mismo sistema pero eso requeriria algunas
explicaciones extra. Por ahora mantendremos una única versión de Perl instalada
en tu sistema.

## Linux

La mayoría de las distribuciones modernas de Linux vienen con una versión reciente de Perl.
De momento usaremos esa versión de Perl. Como editor, puedes instalar Padre que esta incluido
en los sistemas de gestión de paquetes de la mayoría de las distribuciones Linux. Si no es así,
puedes optar por cualquier editor de textos corriente. Gedit es un buen ejemplo de un editor sencillo.
Si estas familiarizado con Vim o Emacs, usa el que prefieras.

## Apple

Creo que Macs también viene con Perl o lo puedes instalar de forma sencilla a través
de las herramientas estándar de instalación.

## Editor e IDE

Aunque lo recomiendo, no tienes porque usar el IDE Padre para escribir código Perl.
En la siguiente parte listaré un par de [editores e IDEs](https://perlmaven.com/perl-editor) que
puedes usar para programar en Perl. Incluso si usas otro editor recomendaría - para usuarios de
Windows - instalar el mencionado paquete DWIM Perl. 

Tiene un montón de extensiones Perl contenidas y te ahorrará mucho tiempo en el futuro.

## Vídeo

Si quieres, puedes ver el vídeo
[Hello world en Perl](http://www.youtube.com/watch?v=c3qzmJsR2H0)
que he subido a YouTube.  Puede que también quieras echar un ojo a
[Beginner Perl Maven video course (en)](https://perlmaven.com/beginner-perl-maven-video-course).

## Primer programa

Tu primer programa será similar a:

```perl
use 5.010;
use strict;
use warnings;

say "Hola mundo";
```

Lo explicaré paso a paso.

## Hola mundo

Una vez que has instalado Perl DWIM puedes hacer click
en "Inicio -> Todos los programas -> DWIM Perl -> Padre" que abrirá el
editor con un fichero vacío.

Escribe:

```perl
print "Hola mundo\n";
```

Como puedes ver en Perl las sentencias terminan con un punto y coma `;`.
El símbolo `\n` es usado para indicar una nueva línea.
Las cadenas de texto se encierran entre comillas dobles `"`.
La función `print` muestra un texto en la pantalla.
Cuanto este código se ejecuta perl mostrará el texto con un carácter de nueva línea al final.

Guarda el texto como hola.pl y ejecútalo pinchando "Ejecutar -> Ejecutar script".
Verás una ventana separada mostrando la salida del programa.

¡Enhorabuena!, has escrito tu primer script perl.

Vamos a mejorarlo un poco.

## Perl en la línea de comandos

Si no estas usando Padre o algún otro [IDE](https://perlmaven.com/perl-editor)
no podrás ejecutar el tu script desde el mismo editor. Al menos no por defecto.
Necesitarás abrir un terminal, moverte al directorio donde guardaste hola.pl
y escribir:

`perl hola.pl`

Así es como se ejecuta un script perl desde la línea de comandos.

## say() en lugar de print()

Vamos a mejorar un poco nuestro pequeño programa:

Primero indicaremos la versión mínima de Perl que queremos usar:

```perl
use 5.010;
print "Hola mundo\n";
```

Una vez que lo has escrito puedes ejecutarlo de nuevo mediante
"Ejecuar -> Ejecutar script" o pulsando <b>F5</b>.
Esto guardará el programa automáticamente antes de ejecutarlo

Generalmente es una buena práctica indicar cual es la mínima versión de perl que tu código necesita.

En este caso además añade algunas nuevas características de perl incluyendo la palabra reservada
`say`.
`say` es similar a `print`, pero añade automáticamente el carácter de
nueva línea al final, además es más corto.

Puedes cambiar tu código así:

```perl
use 5.010;
say "Hola mundo";
```

Cambiando `print` por `say` y eliminando `\n` del final del texto.

Probablemente tengas instaladas las versiones 5.12.3 o 5.14.
La mayoría de las distribuciones modernas de Linux vienen al menos con la versión 5.10.

Lamentablemente hay sitios usando versiones anteriores de perl.
En estos casos no podrás usar `say()` y puede que tengas que hacer
pequeños cambios en ejemplos posteriores. Indicaré en que momentos uso
características que requieren la versión 5.10.

## Red de seguridad

En todos los scripts recomiendo encarecidamente hacer algunos cambios al comportamiento
de Perl. Para ello añadimos 2 líneas con sendos pragmas, un concepto muy similar a los flags
en compiladores en otros lenguajes:

```perl
use 5.010;
use strict;
use warnings;

say "Hola mundo";
```

En esto caso el uso de la palabra reservada `use` le indica a perl
que tiene que cargar y habilitar estos pragmas.

`strict` y `warnings` ayudarán a encontrar algunos errores
frecuentes en tu código y en algunos casos evitarán que los cometas.
Son muy útiles.

## Entrada procedente del usuario

Ahora vamos a mejorar nuestro ejemplo pidiendo al usuario su nombre
y lo incluiremos en la respuesta.

```perl
use 5.010;
use strict;
use warnings;

say "¿Como te llamas? ";
my $name = <STDIN>;
say "Hola $name, ¿como estas?";
```

`$name` es una variable escalar.
Es decir, es una variable que contiene un único valor.

Las variables se declaran usando la palabra reservada <b>my</b>.
(Este es uno de los requisitos que añade el uso de `strict`.)

Las variables escalares siempre empiezan con el signo `$`.
&lt;STDIN&gt; es la herramienta para leer un texto introducido usando el teclado.

Escribe lo anterior y ejecútalo mediante F5.

Te preguntará tu nombre. Escríbelo y presiona la tecla INTRO para que
perl sepa que has finalizado.

Verás que el resultado tiene un pequeño error: la coma posterior
al nombre aparece en una nueva línea. Esto ocurre porque al presionar INTRO
el carácter de nueva línea se introdujo en la variable `$name`.

## Deshaciéndote de los saltos de línea

```perl
use 5.010;
use strict;
use warnings;

say "¿Como te llamas? ";
my $name = <STDIN>;
chomp $name;
say "Hola $name, ¿como estas?";
```

Es una tarea tan común en Perl que existe la función `chomp`
para eliminar los saltos de línea sobrantes de las cadenas de texto.

## Conclusión

<b>Siempre</b> deberías empezar cualquier código perl con las sentencias `use strict;` y
`use warnings;`. También se recomienda añadir `use 5.010`.

## Ejercicios

Prometí ejercicios.

Ejecuta el siguiente script:

```perl
use strict;
use warnings;
use 5.010;

say "Hola ";
say "mundo";
```

No se muestra en una sola línea. ¿Por qué? ¿Como lo arreglarías?

## Ejercicio 2

Escribe un script que solicite dos números al usuario, uno detrás de otro.
Muestra en la pantalla la suma de los números.


---
title: "Strings en Perl: entrecomillado, interpolación y escape"
timestamp: 2014-11-18T15:45:03
tags:
  - strings
  - \
  - escape character
  - interpolation
  - quote
  - embedded characters
  - q
  - qq
published: true
original: quoted-interpolated-and-escaped-strings-in-perl
books:
  - beginner
author: szabgab
translator: davidegx
---


Entender como las cadenas de texto, o strings, funcionan en cualquier lenguaje de
programación es importante, más aún en Perl porque son parte de la esencia del lenguaje.
Especialmente si tienes en cuenta que uno de los retroacronimos de Perl es
<b>Practical Extraction and Reporting Language</b> y para eso necesitas manejar muchos strings.


Los strings pueden ser entrecomillados mediante comillas simples `'` 
o comillas dobles `"`, el comportamiento es diferente entre unas y otras.

## Cadenas de texto encerradas en comillas simples

Si escribes caracteres entre comillas simples `'`, todos los caracteres excepto
la propia comilla simple `'`, son interpretados tal y como están escritos en el
código.

```perl
my $name = 'Foo';
print 'Hola $name, como estas?\n';
```

El resultado será:

```
Hola $name, como estas?\n
```

## Cadenas de texto encerradas en comillas dobles

Los strings dentro de comillas dobles `"` proporcionan interpolación
(las variables contenidas en el string son remplazadas por su contenido),
y también permiten el uso de secuencias de escape como `\n` por una nueva
línea o `\t` por una tabulación.

```perl
my $name = 'Foo';
my $time  = "hoy";
print "Hola $name,\ncomo estas $time?\n";
```

El resultado será:

```
Hola Foo,
como estas hoy?

```

Fíjate que hay un `\n` justo después de la coma y otro al final del string.

Para cadenas de texto sencillas como 'Foo' y "hoy" que non contienen los caracteres
`$`, `@`, o `\` da igual como las entrecomillemos.

Las dos siguientes líneas devolverían el mismo resultado:

```perl
$name = 'Foo';
$name = "Foo";
```


## Direcciones de correo

El símbolo `@` es interpolado cuando aparece dentro de comillas dobles, por
lo que escribir una dirección de correo requiere un poco de atención.

Con comillas simples `@` no es interpolado.

Con comillas dobles, este código:

```perl
use strict;
use warnings;
my $broken_email  = "foo@bar.com";
```

Generará un error: [Global symbol "@bar" requires explicit package name at ... line ... (en)](https://perlmaven.com/global-symbol-requires-explicit-package-name)
y un warning:
<b>Possible unintended interpolation of @bar in string at ... line ...</b>

El warning proporciona una buena pista sobre cual es el problema.

Por otro lado, este código con el email entrecomillado con comillas simples funcionará.

```perl
use strict;
use warnings;
my $good_email  = 'foo@bar.com';
```

¿Que ocurre si quieres usar interpolación de variables escalares pero necesitas incluir símbolos como `@`?

```perl
use strict;
use warnings;
my $name = 'foo';
my $good_email  = "$name\@bar.com";

print $good_email; # foo@bar.com
```

Siempre puedes <b>escapar</b> los caracteres especiales, en este caso el símbolo de la arroba `@`, usando el <b>carácter de escape</b>
que es la contrabarra `\`.

## Incluyendo el símbolo del dolar $ dentro de comillas dobles

De forma similar se puede incluir el signo `$`:

```perl
use strict;
use warnings;
my $name = 'foo';
print "\$name = $name\n";
```

Mostrará:

```
$name = foo
```

## Escapando el carácter de escape

Hay algunos casos en los que quieres incluir la contrabarra dentro de un string.
Si pones la contrabarra `\` en un string encerrado en comillas dobles,
Perl pensará que quieres escapar el siguiente carácter y lo hará.

No te preocupes, le puedes indicar Perl que lo evite escapando el carácter de escape:

Simplemente añade otra contrabarra delante:

```perl
use strict;
use warnings;
my $name = 'foo';
print "\\$name\n";
```

```
\foo
```

Se que esta secuencia de escape es un poco rara, pero así es como funciona en la mayoría de lenguajes.

Si quieres intentar entenderlo mejor, prueba algo como:

```perl
print "\\\\n\n\\n\n";
```

observa lo que muestra:

```
\\n
\n
```

y trata de entender como funciona.

## Escapando las comillas dobles

Hemos visto como puedes entrecomillar variables escalares dentro de comillas dobles y también como puedes escapar
el símbolo del dolar `$`.

También hemos visto como puedes usar el carácter de escape `\` y como lo puedes escapar.

¿Y si quieres mostrar una comilla doble dentro de una cadena delimitada por comillas dobles?


Este código tiene un error sintáctico:

```perl
use strict;
use warnings;
my $name = 'foo';
print "El "nombre" es "$name"\n";
```

Cuando Perl ve el símbolo de comilla doble justo antes de "nombre" piensa que es el final del string
y se queja de que la palabra <b>nombre</b> es un [bareword (en)](https://perlmaven.com/barewords-in-perl)
(texto sin comillas).

Como probablemente has adivinado necesitamos escapar el símbolo `"`:

```perl
use strict;
use warnings;
my $name = 'foo';
print "El \"nombre\" es \"$name\"\n";
```

Esto mostrará:

```
El "nombre" es "foo"
```

Funciona, pero es bastante difícil de leer.


## El operador qq

En estos casos es donde el operador `qq` es útil:

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(El "nombre" es "$name"\n);
```

Para alguien nuevo, qq() puede parecer una llamada a una función, pero no lo es. `qq` es un operador,
veremos en un segundo que más puede hacer, pero primero explicaré esto.

Remplazamos las comillas dobles `"` que envolvían a la cadena por los paréntesis del operador `qq`.
Esto quiere decir que las comillas dobles ya no son un operador especial en esta cadena, por tanto no necesitamos
escaparlas.
Esto hace el código mucho más legible.
Incluso diría elegante, si no temiese la ira de los programadores Python.

Pero, ¿y si quieres incluir paréntesis en tu string?

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(El (nombre) es "$name"\n);
```

No hay problema. Siempre y cuando estén balanceados
(es decir, exista el mismo número de `(` y `)`, y siempre teniendo los paréntesis
de apertura antes que los de cierre correspondientes) Perl puede interpretarlo correctamente.

Supongo que querrás romperlo ahora poniendo un paréntesis de cierre antes que uno de apertura:

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(El )nombre( es "$name"\n);
```

Perl te dará un error de sintaxis porque "nombre" es un [bareword (en)](https://perlmaven.com/barewords-in-perl).
Perl no puede entenderlo todo.

Podrías, por supuesto, escapar los paréntesis en la cadena `\)` y `\(`, pero estaríamos volviendo a tener código
difícil de leer.
¡No gracias!

¡Existe una forma mucho mejor de hacerlo!

¿Recuerdas que escribí que `qq` es un operador y no una función? Por ello puede hacer algunos trucos.

¿Que pasa si cambiamos los paréntesis por llaves? `{}`:

```perl
use strict;
use warnings;
my $name = 'foo';
print qq{El )nombre( es "$name"\n};
```

Esto funciona y muestra la cadena como queríamos:

```
El )nombre( es "foo"
```

(incluso aunque no tengo ni idea porque alguien querría mostrar algo como eso...)

Entonces [el tío de la segunda fila](http://perl.plover.com/yak/presentation/samples/slide027.html) levanta su mano
y pregunta ¿que pasaría si el string contiene tanto paréntesis como llaves, <b>y</b> también los quieres sin balancear?

¿Así?

```perl
use strict;
use warnings;
my $name = 'foo';
print qq[El )nombre} es "$name"\n];
```

mostrando esto:

```
El )nombre} es "foo"
```


... tenía que haber un uso para los corchetes, ¿no?


## El operador q

De forma similar a `qq` también existe el operador `q`.
Este operador también te permite seleccionar los delimitadores de tu string,
pero funciona como las comillas simples `'`: <b>NO</b> interpola las variables.

```perl
use strict;
use warnings;
print q[El )nombre} es "$name"\n];
```

mostrará:

```
El )nombre} es "$name"\n
```



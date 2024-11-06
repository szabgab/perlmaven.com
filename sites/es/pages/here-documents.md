---
title: "Here documents, o como crear strings multi-línea en Perl"
timestamp: 2015-07-04T20:25:01
tags:
  - <<
  - /m
  - /g
  - q
  - qq
published: true
original: here-documents
books:
  - beginner
author: szabgab
translator: davidegx
---


De vez en cuando puedes tener la necesidad de crear textos
que se extienden a lo largo de varias lineas.
Perl dispone de varias soluciones para escribir strings multi-línea, una
de ellas es here-document (documento-aquí).


El uso de <b>here-document</b> te permite crear un texto <b>multi-línea</b> conservando
espacios y saltos de línea. Si ejecutas el código siguiente mostrará exactamente
lo que ves empezando por Hola hasta que aparece END_MESSAGE.

## Here-document no interpolado

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $nombre = 'Foo';

my $mensaje = <<'END_MESSAGE';
Hola $nombre,

este es un mensaje que te voy a enviar.

Saludos
  Perl Maven
END_MESSAGE

print $mensaje;
```

Salida:

```
Hola $nombre,

este es un mensaje que te voy a enviar.

Saludos
  Perl Maven
```

El here-document comienza con dos caracteres de menor que `&lt;&lt;` seguido de una cadena arbitraria que
se convierte en la cadena que marca el fin del texto, y por último el punto y coma `;` que marca el final
de la sentencia.
Es un poco extraño porque realmente la sentencia no acaba aquí. El contenido del here-document
comienza en la línea siguiente del punto y coma, en nuestro caso con la palabra "Hola", y continua hasta
que perl encuentra la marca de fin del documento, en nuestro caso <b>END_MESSAGE</b>.

Si has visto here-documents en otros sitios, puede que te sorprenda ver comillas simples
alrededor de <b>END_MESSAGE</b>. En muchos ejemplos de código en Internet es común encontrar
código como:

```perl
my $mensaje = <<END_MESSAGE;
...
END_MESSAGE
```

Funciona y se comporta de la misma manera que si pusieses END_MESSAGE con comillas dobles, como en el
siguiente ejemplo, pero queda menos claro. Recomendaría usar siempre las comillas alrededor de la
marca de fin de mensaje.

```perl
my $mensaje = <<"END_MESSAGE";
...
END_MESSAGE
```

Si ya conoces la
[diferencia entre comillas simples y comillas dobles ](/strings-entrecomillados-interpolados-y-escapados-en-perl)
en Perl, no te sorprenderá saber que here-documents se comporta de la misma forma.
La única diferencia es que las comillas están alrededor de la marca de fin de texto en lugar de alrededor
del propio texto.
Si no se usan comillas Perl se comporta como si se usasen comillas dobles.

Si miras de nuevo el primer ejemplo, verás que Perl no intentó reemplazar `$nombre`
por el contenido de esa variable y que permaneció de forma literal en la salida.
(Ni siquiera es necesario que dicha variable estuviese definida. Puedes probar de nuevo
sin la sentencia `my $nombre = 'Foo';`)

## Here-document interpolado

En el siguiente ejemplo usaremos comillas dobles alrededor de la marca de fin de texto y
por lo tanto `$nombre` será reemplazado por su valor:

```perl
use strict;
use warnings;

my $nombre = 'Foo';
my $mensaje = <<"END_MSG";
Hola $name,

como estas?
END_MSG

print $mensaje;
```

El resultado de la ejecución será:

```
Hola Foo,

como estas?
```

## Advertencia: marca de fin idéntica al final

Un pequeño apunte. Tienes que asegurarte de que la marca de fin esta duplicada al final
del texto de forma <b>exacta</b>. Sin espacios delante o después. Sino Perl no
reconocerá el final del texto.
Esto quiere decir que no puedes identar la marca de fin como el resto de tu código. ¿O quizás si?

## Here documents y código identado

Si el fragmento de código here document va en una posición donde
normalmente identariamos el código, tenemos dos problemas:


```perl
#!/usr/bin/perl
use strict;
use warnings;

my $name = 'Foo';
my $send = 1;

if ($send) {
    my $mensaje = <<"END_MESSAGE";
        Hola $name,
    
        este es un mensaje que planeo enviarte.
    
        saludos
          Perl Maven
END_MESSAGE
    print $mensaje;
}
```

Uno ya mencionado previamente, la marca de cierre debe ser exactamente igual
en su declaración y al final del texto, por lo que no puedes identarlo al final.

El otro problema es que la salida contendrá todos los espacios en blanco usados
para identar:

```
        Hola Foo,
    
        este es un mensaje que planeo enviarte.
    
        saludos
          Perl Maven
```

El problema de la falta de identación en la marca de fin se puede resolver
incluyendo espacios suficientes delante:

```perl
    my $mensaje = <<"    END_MESSAGE";
       ...
    END_MESSAGE
```

La identación extra se puede solucionar usando una sustitución en la asignación.

```perl
    (my $mensaje = <<"    END_MESSAGE") =~ s/^ {8}//gm; 
        ...
    END_MESSAGE
```

En esta sustitución reemplazamos los 8 espacios al comienzo por la cadena vacía. El
modificador `/m` cambia el comportamiento de `^` para que en lugar
de corresponder con el <b>principio del string</b> corresponda con <b>el principio de cualquier línea</b>. El
modificador `/g` sirve para hacer la sustitución <b>globalmente</b>, es decir, realizar
la sustitución tantas veces como se encuentre el texto buscado.

Estos dos flags combinados provocarán que la sustitución elimine los 8 primeros espacios de cada línea
en la variable de la parte izquierda de `=~`.
En la parte izquierda es necesario poner la asignación entre paréntesis porque la precedencia
del operador de asignación `=` es menor que la precedencia de `=~`. Sin los
paréntesis, perl intentaría realizar la sustitución en el here-doc y fallaría en tiempo de
compilación:

Can't modify scalar in substitution (s///) at programming.pl line 9, near "s/^ {8}//gm;"

## Usando q o qq

Después de toda esta explicación no estoy seguro de si debería recomendar el uso de here-documents.
En muchos casos, en lugar de here-docuemnts, uso los operadores `qq` o `q`.
Dependiendo de si quiero interpolar o no los strings:

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $name = 'Foo';
my $send = 1;

if ($send) {
    (my $mensaje = qq{
        Hola $name,
    
        este es un mensaje que planeo enviarte.
    
        saludos
          Perl Maven
        }) =~ s/^ {8}//mg;
    print $mensaje;
}
```


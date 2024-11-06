---
title: "El bucle for en Perl"
timestamp: 2013-08-03T19:46:13
tags:
  - for
  - foreach
  - loop
  - infinite loop
published: true
original: for-loop-in-perl
books:
  - beginner
author: szabgab
translator: davidegx
---


En esta parte de [Perl Tutorial](/perl-tutorial) veremos
<b>el bucle for en Perl</b>. También conocido como <b>bucle for estilo C</b>,
aunque esta construcción esta disponible en muchos lenguajes de programación.


## for en Perl

La palabra reservada <b>for</b> en Perl puede funcionar de dos formas distintas.
Se puede usar como un bucle <b>foreach</b> y también como
un bucle estilo C de 3 partes. Normalmente se le llama estilo C 
pero existe en muchos lenguajes.

Mostraré como funciona aunque prefiero escribir bucles `foreach` como
se muestra en la sección [perl arrays](https://perlmaven.com/perl-arrays).

Las palabras reservadas `for` y `foreach` se pueden usar como sinónimos.
Perl averiguará cual es el significado que tenías en mente.

El <b>bucle estilo C</b> tiene tres partes en la sección de control.
Normalmente se parece al código siguiente, aunque puedes omitir cualquiera
de las partes.

```perl
for (INITIALIZE; TEST; STEP) {
  BODY;
}
```

Por ejemplo:

```perl
for (my $i=0; $i <= 9; $i++) {
   print "$i\n";
}
```

La parte INITIALIZE se ejecutará solo una vez cuando la ejecución llega a ese punto.

Justo después la parte TEST es ejecutada. Si devuelve falso
el bucle será ignorado por completo. Si la parte TEST devuelve verdadero se ejecutará BODY
seguido de STEP.

(Para el significado real de VERDADERO y FALSO, revisa [valores booleanos en Perl](https://perlmaven.com/boolean-values-in-perl).)

Luego viene la parte TEST y se repite sucesivamente mientras la parte TEST devuelva un valor verdadero.
Por lo tanto la ejecución se parece a:

```
INITIALIZE

TEST
BODY
STEP

TEST
BODY
STEP

...

TEST
```


## foreach

El bucle anterior, que va de 0 a 9, puede escribirse también como un <b>bucle foreach</b>
y el objetivo queda mucho más claro:

```perl
foreach my $i (0..9) {
  print "$i\n";
}
```

Como he mencionado, las dos palabras son sinónimos y mucha gente usa `for` 
pero escribe <b>bucles estilo foreach</b>:

```perl
for my $i (0..9) {
  print "$i\n";
}
```

## Las partes del bucle for en Perl

INITIALIZE es para inicializar alguna variable. Es ejecutado exactamente una vez.

TEST es una expresión booleana que comprueba si el bucle debería terminar o continuar.
Es ejecutado al menos una vez. TEST es ejecutado una vez más que BODY y STEP.

BODY es un conjunto de sentencias, normalmente es lo que queremos hacer de
forma repetida aunque en algunos caso un BODY vacío puede tener sentido.
Bueno, probablemente todos esos casos pueden ser reescritos de una forma mejor.

STEP es otro conjunto de acciones utilizados normalmente para incrementar o decrementar algún
tipo de índice. También puede ser vacío si, por ejemplo, realizamos ese cambio dentro de BODY.

## Bucle infinito

Puedes escribir un bucle infinito con <b>for</b>:

```perl
for (;;) {
  # hacer algo
}
```

Normalmente se suele escribir con `while`:

```perl
while (1) {
  # hacer algo
}
```

Esta explicado en el capitulo acerca del [bucle while en perl](https://perlmaven.com/while-loop).

## perldoc

Encontrarás la descripción oficial del bucle for en la sección
<b>perlsyn</b> de la
[documentación Perl](http://perldoc.perl.org/perlsyn.html#For-Loops).




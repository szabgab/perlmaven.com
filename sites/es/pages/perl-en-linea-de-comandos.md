---
title: "Perl en la línea de comandos"
timestamp: 2013-07-09T10:00:00
published: true
original: perl-on-the-command-line
books:
  - beginner
author: szabgab
translator: ileiva
---


A pesar que la mayoría del [Tutorial de Perl](/perl-tutorial)
trata con scripts guardados en un archivo, también veremos un par de ejemplos
de <h>one-liners</h> (instrucciones en una línea).

Aunque utilices [Padre](http://padre.perlide.org/) u otro IDE que
te permita ejecutar tu script desde el editor, es muy importante que
te familiarices con la línea de comandos (o <i>shell</i>) y que seas capaz de 
usar Perl en ella.


Si usas Linux, abre una ventana de terminal. Deberías ver el <i>prompt</i>, probablemente
terminado en un símbolo $.

Si usas Windows, abre una ventana de comandos. Para ello, haz click en

Inicio -> Ejecutar -> escribe "cmd" -> Presiona ENTER

Verás la pantalla negra de CMD con un <i>prompt</i> parecido a esto:

```
c:\>
```

## Versión de Perl

Escribe `perl -v`. Verás algo como esto:

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

En mi caso, por ejemplo, puedo ver que tengo la versión 5.12.3 de Perl instalada en mi
máquina Windows.


## Imprimiendo un número

Ahora escribe `perl -e "print 42"`.
Esto imprimirá el número `42` en la pantalla. En Windows el <i>prompt</i> aparecerá 
en la siguiente línea.

```
c:>perl -e "print 42"
42
c:>
```

En Linux verás algo como esto:

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

El resultado está en el principio de la línea, seguido por el <i>prompt</i>.
La diferencia se debe a los distintos comportamientos que tienen ambos intérpretes de línea de comando.

En el ejemplo usamos el <i>flag</i> `-e`, el cual le dice a Perl:
"No esperes un archivo, lo que viene a continuación es el código Perl".

Los ejemplos anteriores no son muy interesantes que digamos. Déjame mostrarte un ejemplo ligeramente
más complejo, sin explicarlo:

## Reemplazar Java por Perl

Este comando: `perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`
reemplazará todas las ocurrencias de la palabra <b>Java</b> por la palabra <b>Perl</b> en tu
currículum, conservando un respaldo del archivo.

En Linux puedes escribir `perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt`
para reemplazar la palabra Java por la palabra Perl en <b>todos</b> tus archivos de texto.

Más adelante hablaremos más sobre <i>one-liners<i> y aprenderás cómo usarlos.
Está de más decir que el conocimiento de <i>one-liners</i> es una herramienta muy poderosa en tus manos.

A propósito, si estás interesado en algunos buenos <i>one-liners</i>, recomiendo leer
[Perl One-Liners explained](http://www.catonmat.net/blog/perl-book/)
de Peteris Krumins.

## A continuación

La siguiente parte de este tutorial trata sobre la
[Documentación del núcleo de Perl y documentación de módulos de CPAN](https://perlmaven.com/core-perl-documentation-cpan-module-documentation).



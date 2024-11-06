---
title: "Perl tutorial"
timestamp: 2013-07-16T10:01:04
description: "Tutorial gratuito de Perl para personas que necesitan mantener código existente, crear pequeños scrips en Perl o desarrollar progamas Perl."
published: true
original: perl-tutorial
author: szabgab
translator: davidegx
archive: false
---

El tutorial Perl Maven te enseñará los principios básicos del lenguaje de programación Perl.
Seras capaz de escribir scripts sencillos, analizar ficheros de log o leer ficheros CSV entre otras
muchas cosas.

Aprenderás como usar CPAN y veremos algunos módulos CPAN concretos.

La versión online gratuita del tutorial esta actualmente en desarrollo. Muchas partes están listas
y otras son publicadas cada pocos días.
La mayoría de los artículos no están todavía traducidos al castellano, los enlaces a la versión original
en inglés estarán seguidos de (en) para indicar que todavía no esta traducido.
Si estas interesado en recibir notificaciones cuando se publiquen nuevos artículos
[regístrate en el newsletter](https://perlmaven.com/register) (en).

También hay una versión [e-book (en)](https://perlmaven.com/beginner-perl-maven-e-book) disponible para comprar.
Además del tutorial gratuito esa versión incluye muchos ejercicios y soluciones, incluyendo las áreas
que todavía no están disponibles en la versión gratuita.

El [vídeo-curso(en)](https://perlmaven.com/beginner-perl-maven-video-course) contiene sobre 210 episodios,
más de 5 horas de vídeo. Además de presentar el material también proporciona explicaciones sobre las
soluciones de todos los ejercicios.
También incluye el código fuente de todos los ejemplos y ejercicios.

## Free on-line Beginner Perl Maven tutorial

En este tutorial veremos como usar el lenguaje de programación Perl 5 para
<b>hacer tu trabajo</b>.

Aprenderemos tanto características generales del lenguaje, así como extensiones o librerías
o se denominan en Perl, <b>módulos</b>. Veremos algunos de los módulos estándar incluidos
en perl y otros módulos externos, que instalaremos desde <b>CPAN</b>. 

<p>
<b>Introducción</b>
<ol>
<li>[Instalando Perl, mostrando Hola Mundo, red de seguridad (use strict, use warnings)](/instalacion-y-primeros-pasos-con-perl)</li>
<li>[#!/usr/bin/perl - the hash-bang line (en)](https://perlmaven.com/hashbang)</li>
<li>[Editores e IDEs, entornos de desarrollo en Perl](/editor-de-perl)</li>
<li>[Obteniendo ayuda](/ayuda)</li>
<li>[Perl en la línea de comandos](/perl-en-linea-de-comandos)</li>
<li>[Documentación del núcleo de Perl y los módulos CPAN](/documentacion-nucleo-perl-modulos-cpan)</li>
<li>[POD - Plain Old Documentation](/pod-plain-old-documentation-de-perl)</li>
<li>[Depurando Perl scripts](/depurando-scripts-perl)</li>
</ol>

<b>Escalares</b>
<ol>
<li>[Errores y warnings tipicos en Perl](/errores-y-warnings-comunes)</li>
<li>[Conversión automática de texto a número](/conversion-automatica-de-valores-en-perl)</li>
<li>Sentencias condicionales: if</li>
<li>[Valores booleanos en Perl](/valores-booleanos-en-perl)</li>
<li>[Operadores numéricos](/operadores-numericos)</li>
<li>[Operadores para strings: concatenación (.) y repetición (x)](/operadores-string)</li>
<li>[undef, el valor inicial y la función defined](/undef-y-defined-en-perl)</li>
<li>[Strings en Perl: entrecomillado, interpolación y secuencias de escape](/strings-entrecomillados-interpolados-y-escapados-en-perl)</li>
<li>[Here documents](/here-documents)</li>
<li>[Variables escalares (en)](https://perlmaven.com/scalar-variables)</li>
<li>[Comparando escalares (en)](https://perlmaven.com/comparing-scalars-in-perl)</li>
<li>[Funciones para tratar Strings: length, lc, uc, index, substr (en)](https://perlmaven.com/string-functions-length-lc-uc-index-substr)</li>
<li>[Adivina el número (rand, int) (en)](https://perlmaven.com/number-guessing-game)</li>
<li>[Bucle while en Perl (en)](https://perlmaven.com/while-loop)</li>
<li>[Rango de las variables en Perl (en)](https://perlmaven.com/scope-of-variables-in-perl)</li>
<li>[Boolean Short circuit (en)](https://perlmaven.com/short-circuit)</li>
</ol>

<b>Ficheros</b>
<ol>
<li>[exit (en)](https://perlmaven.com/how-to-exit-from-perl-script)</li>
<li>[Standard Output, Standard Error and command line redirection (en)](https://perlmaven.com/stdout-stderr-and-redirection)</li>
<li>[warn (en)](https://perlmaven.com/warn)</li>
<li>[die (en)](https://perlmaven.com/die)</li>
<li>[Escribiendo en ficheros (en)](https://perlmaven.com/writing-to-files-with-perl)</li>
<li>[Anexando texto a ficheros (en)](https://perlmaven.com/appending-to-files)</li>
<li>[Abriendo y leyendo ficheros en Perl](/abrir-y-leer-desde-archivos-de-texto)</li>
<li>[No abras ficheros a la antigua usanza (en)](https://perlmaven.com/open-files-in-the-old-way)</li>
<li>Modo binario, tratando con Unicode</li>
<li>Leyendo un fichero binario, read, eof</li>
<li>tell, seek</li>
<li>truncate (en)</li>
<li>[Modo slurp (en)](https://perlmaven.com/slurp)</li>
</ol>

<b>Listas y Arrays</b>
<ol>
<li>Bucle foreach en Perl</li>
<li>[Bucle for en Perl](/bucle-for-en-perl)</li>
<li>Listas en Perl</li>
<li>Usando Modulos</li>
<li>[Arrays en Perl](/arrays-en-perl)</li>
<li>[Procesando parámetros en la línea de comandos (@ARGV)](/argv-en-perl)</li>
<li>Procesando parámetros en la línea de comandos con Getopt::Long</li>
<li>[split (en)](https://perlmaven.com/perl-split)</li>
<li>[Como leer fichero CSV usando Perl (split, Text::CSV_XS)](/como-leer-un-fichero-csv-en-perl)</li>
<li>[join](/join)</li>
<li>[El año 19100 (time, localtime, gmtime)](/el-anno-19100) e introduciendo el contexto</li>
<li>[Sensibilidad al contexto en Perl](/contexto-escalar-y-lista-en-perl)</li>
<li>[Ordenando arrays en Perl](/ordenando-arrays-en-perl)</li>
<li>[Ordenando strings mixtos (en)](https://perlmaven.com/sorting-mixed-strings)</li>
<li>[Valores únicos en arrays (en)](https://perlmaven.com/unique-values-in-an-array-in-perl)</li>
<li>[Manipulando arrays: shift, unshift, push, pop (en)](https://perlmaven.com/manipulating-perl-arrays)</li>
<li>Pilas y [colas (en)](https://perlmaven.com/using-a-queue-in-perl)</li>
<li>reverse</li>
<li>[El operador ternario](/el-operador-ternario-en-perl)</li>
<li>Controles en bucles: next y last</li>
<li>min, max, sum usando List::Util</li>
</ol>

<b>Subrutinas</b>
<ol>
<li>[Subrutinas y funciones en Perl (en)](https://perlmaven.com/subroutines-and-functions-in-perl)</li>
<li>Paso y comprobación de parámetros en subrutinas (en)</li>
<li>[Número variable de parámetros (en)](https://perlmaven.com/variable-number-of-parameters)</li>
<li>Devolviendo una lista (en)</li>
<li>[Subrutinas recursivas (en)](https://perlmaven.com/recursive-subroutines)</li>
</ol>

<b>Hashes, arrays</b>
<ol>
<li>[Perl Hashes (diccionarios, array asociativos, tablas look-up table) (en)](https://perlmaven.com/perl-hashes)</li>
<li>exists, eliminando elementos en un hash (en)<li>
<li>[Ordenando un hash (en)](https://perlmaven.com/how-to-sort-a-hash-in-perl)</li>
<li>[Frecuencia de una palabra en un fichero de texto (en)](https://perlmaven.com/count-words-in-text-using-perl)</li>
</ol>

<b>Expresiones regulares</b>
<ol>
<li>[Introducción a las expresiones regulares en Perl (en)](https://perlmaven.com/introduction-to-regexes-in-perl)</li>
<li>[Regex: character classes (en)](https://perlmaven.com/regex-character-classes)</li>
<li>Regex: quantifiers</li>
<li>Regex: Greedy and non-greedy match</li>
<li>Regex: Grouping and capturing</li>
<li>Regex: Anchors</li>
<li>Regex options and modifiers</li>
<li>Sustituciones (búsqueda y reemplazo)</li>
<li>[trim - eliminando espacios sobrantes (en)](https://perlmaven.com/trim)</li>
</ol>

<b>Relación de Perl con la línea de comandos</b>
<ol>
<li>Perl -X operators</li>
<li>Perl pipes</li>
<li>Ejecutando programas externos mediante [system (en)](https://perlmaven.com/running-external-programs-from-perl)</li>
<li>Comandos Unix: rm, mv, chmod, chown, cd, mkdir, rmdir, ln, ls, cp</li>
<li>[Como borrar, copiar o renombrar un fichero en Perl (en)](https://perlmaven.com/how-to-remove-copy-or-rename-a-file-with-perl)</li>
<li>Windows/DOS commands: del, ren, dir</li>
<li>File globbing (Wildcards)</li>
<li>Directory handles.</li>
<li>Recorriendo un árbol de directorios [de forma recursiva](https://perlmaven.com/recursive-subroutines),
[uso de una cola (en)](https://perlmaven.com/traversing-the-filesystem-using-a-queue) y uso de find (en).</li>
</ol>

<b>CPAN</b>
<ol>
<li>[Descargando e instalando Perl (Strawberry Perl o una compilación manual) (en)](https://perlmaven.com/download-and-install-perl)</li>
<li>Descargando e instalando Perl usando Perlbrew</li>
<li>Buscando y evaluando módulos en CPAN</li>
<li>Descargando e instalando módulos Perl desde CPAN</li>
<li>[Como modificar @INC para usar módulos Perl que no están en directorios estándar (en)](https://perlmaven.com/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)</li>
<li>[Como cambiar @INC para usar un ruta relativa (en)](https://perlmaven.com/how-to-add-a-relative-directory-to-inc) (for [Pro](https://perlmaven.com/pro) subscribers.)</li>
<li>local::lib</li>
</ol>

<b>Algunos ejemplos usando Perl</b>
<ol>
<li>[How to replace a string in a file with Perl? (slurp) (en)](https://perlmaven.com/how-to-replace-a-string-in-a-file-with-perl)</li>
<li>Leyendo ficheros Excel usando Perl</li>
<li>[Creando ficheros Excel usando Perl (en)](https://perlmaven.com/create-an-excel-file-with-perl) (for [Pro](/pro) subscribers.)</li>
<li>Enviando emails usando Perl</li>
<li>Scripts CGI en Perl</li>
<li>Aplicaciones web en Perl: PSGI</li>
<li>Parseando ficheros XML</li>
<li>Leyendo y escribiendo ficheros JSON</li>
<li>[Acceso a base de datos usando Perl (DBI, DBD::SQLite, MySQL, PostgreSQL, ODBC) (en)](https://perlmaven.com/simple-database-access-using-perl-dbi-and-sql)</li>
<li>Accediendo a LDAP usando Perl</li>
</ol>
<li>Mensajes de error y warnings comunes<br />
  <ol>
    <li>[Global symbol requires explicit package name (en)](https://perlmaven.com/global-symbol-requires-explicit-package-name)</li>
    <li>[Uso de valores no inicializados (en)](https://perlmaven.com/use-of-uninitialized-value)</li>
    <li>[Bareword not allowed while "strict subs" in use (en)](https://perlmaven.com/barewords-in-perl)</li>
    <li>[Name "main::x" used only once: possible typo at ... (en)](https://perlmaven.com/name-used-only-once-possible-typo)</li>
    <li>[Unknown warnings category (en)](https://perlmaven.com/unknown-warnings-category)</li>
    <li>[Can't locate ... in @INC (en)](https://perlmaven.com/cant-locate-in-inc)</li>
    <li>[Scalar found where operator expected (en)](https://perlmaven.com/scalar-found-where-operator-expected)</li>
    <li>["my" variable masks earlier declaration in same scope (en)](https://perlmaven.com/my-variable-masks-earlier-declaration-in-same-scope)</li>
    <li>[Can't call method ... on unblessed reference (en)](https://perlmaven.com/cant-call-method-on-unblessed-reference)</li>
    <li>[Argument ... isn't numeric in numeric ... (en)](https://perlmaven.com/argument-isnt-numeric-in-numeric)</li>
    <li>[Can't locate object method "..." via package "1" (perhaps you forgot to load "1"?) (en)](https://perlmaven.com/cant-locate-object-method-via-package-1)</li>
    <li>[Odd number of elements in hash assignment (en)](https://perlmaven.com/creating-hash-from-an-array)</li>
    <li>[Possible attempt to separate words with commas (en)](https://perlmaven.com/qw-quote-word)</li>
    <li>[Undefined subroutine ... called (en)](https://perlmaven.com/autoload)</li>
  </ol>
</li>

<b>Other</b>
<ol>
<li>[Splice to slice and dice arrays in Perl (en)](https://perlmaven.com/splice-to-slice-and-dice-arrays-in-perl)</li>
<li>[How to create a Perl Module for code reuse (en)](https://perlmaven.com/how-to-create-a-perl-module-for-code-reuse)</li>
<li>[Object Oriented Perl using Mooses (en)](https://perlmaven.com/object-oriented-perl-using-moose)</li>
<li>[Attribute types in Perl classes when using Moose (en)](https://perlmaven.com/attribute-types-in-perl-classes-when-using-moose)</li>
<li>[Multi dimensional arrays (en)](https://perlmaven.com/multi-dimensional-arrays-in-perl)</li>
<li>[Multi dimensional hashes (en)](https://perlmaven.com/multi-dimensional-hashes)</li>
<li>[Minimal requirement to build a sane CPAN package (en)](https://perlmaven.com/minimal-requirement-to-build-a-sane-cpan-package)</li>
<li>[Testing a simple Perl module (en)](https://perlmaven.com/testing-a-simple-perl-module)</li>
<li>[What are string and numeric contexts? (en)](https://perlmaven.com/what-are-string-and-numeric-contexts)</li>
</ol>

<b>Perl Orientado a Objetos con Moo</b>

Hay una serie completa de artículos acerca de como escribir código Orientado
a Objetos usando el framework [Moo (en)](https://perlmaven.com/moo).

<hr />

Recordatorio, hay [e-books](https://perlmaven.com/beginner-perl-maven-e-book) y 
[cursos en vídeo](https://perlmaven.com/beginner-perl-maven-video-course) disponibles para
[comprar (en)](https://perlmaven.com/products).


<b>Introducción al curso avanzado de Perl</b>
<li>[Librerías en Perl 4](/librerias-perl-4)</li>
<li>[El problema con las librerías en Perl 4](/el-problema-con-las-librerias)</li>
<li>[Espacios con nombre y paquetes](/espacios-con-nombre-y-paquetes)</li>

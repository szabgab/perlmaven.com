---
title: "Editor de Perl"
timestamp: 2013-06-14T10:00:00
tags:
  - IDE
  - editor
  - Padre
  - vim
  - emacs
  - Eclipse
  - Komodo
published: true
original: perl-editor
books:
  - beginner
author: szabgab
translator: ileiva
---


Los scripts o programas Perl son simples archivos de texto.
Puedes usar cualquier editor de texto para crearlos, pero es mejor evitar
los procesadores de texto (p. ej., MS Word). Puedo recomendarte algunos editores
y entornos de desarrollo integrado (IDE).

A propósito, este artículo forma parte del [tutorial de Perl](/perl-tutorial).


## ¿Editor o IDE?

Para programar en Perl puedes usar un editor de texto o un <b>entorno de desarrollo integrado</b>, también llamado IDE por sus siglas en inglés.

Primero describiré los editores para las plataformas más usadas hoy en día, y luego los IDE,
que son generalmente independientes de la plataforma.

## Unix / Linux

Si usas Linux o Unix, los editores más populares son
[Vim](http://www.vim.org/) y [Emacs](http://www.gnu.org/software/emacs/).
Ambos siguen filosofías muy distintas, y tampoco se parecen a los demás editores.

Si ya estás familiarizado con uno de ellos, te recomendaría que lo usaras.

Para cada uno están disponibles modos o extensiones especiales que facilitan el uso de
Perl, pero incluso sin estos modos o extensiones siguen siendo muy buenas opciones para programar en Perl.

Si no estás familiarizado con estos editores, te recomendaría que separes la
curva de aprendizaje de Perl de la experiencia de aprendizaje de un nuevo editor de texto.

Ambos editores son muy poderosos, pero llegar a dominarlos requiere tiempo.

Probablemente sea mejor que te centres en aprender Perl por el momento y luego
aprendas a utilizar alguno de estos editores.

Ambos editores son nativos en Linux/Unix, pero también están disponibles para 
los demás sistemas operativos principales.

## Editores de Perl para Windows

En Windows mucha gente utiliza los llamados "editores de programación".

* [Ultra Edit](http://www.ultraedit.com/) es un editor comercial.
* [TextPad](http://www.textpad.com/) es shareware.
* [Notepad++](http://notepad-plus-plus.org/) es un editor gratuito de código abierto.

Por mi parte, utilizo bastante <b>Notepad++</b> y lo mantengo instalado en mi máquina Windows, ya que puede ser bastante útil.

## Mac OS X

No utilizo Mac, pero según el voto popular, el editor más utilizado para programar en Perl es [TextMate](http://macromates.com/)

## IDE para Perl

Ninguno de los editores mencionados es un IDE, esto es, ninguno de ellos ofrece
un auténtico depurador integrado de Perl. Tampoco proporcionan ayuda específica para el lenguaje.

[Komodo](http://www.activestate.com/) (de ActiveState) cuesta unos cientos de dólares.
Existe una versión gratuita con capacidades limitadas.

Para los que ya sean usuarios de [Eclipse](http://www.eclipse.org/) les interesará saber que
existe un complemento para programar en Perl llamado EPIC. También hay un proyecto llamado
[Perlipse](https://github.com/skorg/perlipse).


## Padre, el IDE para Perl

En julio de 2008 empecé a desarrollar un <b>IDE para Perl en Perl</b>. Lo llamé Padre
(Perl Application Development and Refactoring Environment) o <a href="http://padre.perlide.org/">
Padre, el IDE para Perl</a>.

Mucha gente se ha unido al proyecto. Actualmente se incluye en las principales distribuciones de Linux y también
se puede instalar desde CPAN. Visita la página de [descarga](http://padre.perlide.org/download.html)
para más detalles.

En algunos aspectos aún no es tan robusto como Eclipse o Komodo, pero en otras áreas 
específicas de Perl ya los ha superado.

Por otra parte, el desarrollo de <b>Padre</b> es muy activo.
Si buscas un <b>editor</b> o un <b>IDE</b> para Perl, te recomiendo que lo pruebes.


## La gran encuesta sobre editores para Perl

En octubre de 2009 realicé una encuesta en la que pregunté
[¿Qué editores o IDE utilizas para programar en Perl?](http://perlide.org/poll200910/)

Puedes seguir a la mayoría, ir en contra de ella o elegir el editor para Perl que se adapte mejor a tus necesidades.


## Otros editores

Alex Shatlovsky recomienda [Sublime Text](http://www.sublimetext.com/), un editor multiplataforma (aunque de pago).

## A continuación

La siguiente parte de este tutorial es una breve introducción a [Perl en la línea de comandos](https://perlmaven.com/perl-on-the-command-line)



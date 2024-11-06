---
title: "Como adicionar el campo de licencia a los ficheros META.yml y META.json en CPAN ?"
timestamp: 2014-11-01T07:45:56
tags:
  - license
  - Perl
  - Perl 5
  - CPAN
  - META
  - ExtUtils::MakeMaker
  - Module::Build
  - Module::Install
  - Dist::Zilla
  - CPAN::Meta::Spec
published: true
original: how-to-add-list-of-contributors-to-the-cpan-meta-files
author: szabgab
translator: danimera
---


Cada distribución en CPAN puede incluir un META.yml y un archivo META.json.
Ellos deberían tener la misma información, META.json es sólo el más reciente formato.
Encontrarás muchas más distribuciones con sólo META.yml y encontrarás
una distribución pocos, probablemente muy antigua con ningún archivo META en absoluto.

Los archivos META pueden tener ambos un campo que indica la <b>licencia</b> de la distribución.

Tener la información de licencia en los archivos del META lo pone muy fácil para herramientas automatizadas
para comprobar si un conjunto de módulos tienen un determinado conjunto de licencias.


Como la META archivos generalmente se generan automáticamente cuando se suelta la distribución
por el autor, voy a mostrarte como puedes decir los 4 sistemas de empaquetados principales
incluir el campo de la licencia.

En los ejemplos Utilizare los más comunes, así llamado, licencia de <b>Perl</b>:


## ExtUtils::MakeMaker

Si  está usando [ ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker) agregar lo siguiente a tu Makefile.PL
como parámetro en la función <b>WriteMakefile</b>:

```perl
'LICENSE'  => 'perl',
```

Si quieres estar seguro que viejas versiones de ExtUtils::MakeMaker no den advertencias sobre
desconocido un campo de licencia, puede utilizar el código siguiente:

```perl
($ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE'  => 'perl', ) : ()),
```

[ la versión distribuida con perl 5.8.8 es 6.30](http://search.cpan.org/src/NWCLARK/perl-5.8.8/lib/ExtUtils/MakeMaker.pm)
por lo tanto  todavía no contiene esta característica. lo mejor es si tu pudieses actualizarlo ExtUtils::MakeMaker.

## Module::Build

Si está utilizando [ Module::Build](https://metacpan.org/pod/Module::Build), agregue lo siguiente al Build.PL,
en la llamada  Module::Build->new:

```perl
license               => 'perl',
```

## Module::Install

Si  está usando [ Module::Install](https://metacpan.org/pod/Module::Install) agregar lo siguiente a Makefile.PL:

```perl
license        'perl';
```

## Dist::Zilla

Si está utilizando [ Dist::Zilla](http://dzil.org/), simplemente agregue la siguiente entrada al archivo dist.ini:

```perl
license = Perl_5
```

## META especificaciones

Con el fin de revisar la actual lista de opciones válidas para el campo de la licencia,
Consulte la [ Especificación CPAN::Meta](https://metacpan.org/pod/CPAN::Meta::Spec).

## Derechos de autor y licencias

Según la [ CPAN licencias directrices](http://www.perlfoundation.org/cpan_licensing_guidelines)
de la Fundación Perl, es <b>necesario</b> tener información de la licencia en los archivos META.

Por supuesto, hay otros elementos necesarios de la concesión de licencias. Este artículo sólo se enfoca en la entrada de los archivos  META.

---
title: "Como adicionar vinculo al sistema de control de version de una distribucion CPAN?"
timestamp: 2014-11-01T08:45:56
tags:
  - Perl
  - Perl 5
  - CPAN
  - Git
  - Github
  - SVN
  - Subversion
  - VCS
  - META
  - ExtUtils::MakeMaker
  - Module::Build
  - Module::Install
  - Dist::Zilla
  - CPAN::Meta::Spec
published: true
original: how-to-add-link-to-version-control-system-of-a-cpan-distributions
author: szabgab
translator: danimera
---


Cuando se mira en [ META CPAN](https://www.metacpan.org/), o en
[ search.cpan.org](http://search.cpan.org/),  verá que algunos módulos
tienen un enlace a Github o algún otro lugar donde hospedan su proyecto.

En search.cpan.org, es un simple enlace junto al título del <b>Repositorio</b>, en Meta CPAN
es un enlace o un pop-up bajo el título <b>Repositorio clon</b> dependiendo del tipo de
repositorio. (Github obtiene  pop-ups, repositorios privados tienden a enlaces simples).


Ambos sitios toman el enlace al sistema de Control de versiones de los archivos META incluidos en las distribuciones de CPAN.
META.yml o el META.json más recientes. ( sólo difieren en su formato.)

Como los META archivos generalmente se generan automáticamente cuando se suelta la distribución
por el autor, voy a mostrarte como puedes decir a los 4 sistemas de paquetes principales 
incluir el enlace del repositorio.

En los ejemplos utilizare el enlace al repositorio de [ Task::DWIM](https://metacpan.org/pod/Task::DWIM),
que es una distribución experimental listado todos los módulos incluidos en una [ DWIM Perl](http://dwimperl.szabgab.com/)
distribución.


## ExtUtils::MakeMaker

Si utilizas [ ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker) agregar lo siguiente a tu Makefile.PL
como parámetro en la función <b>WriteMakefile</b>:


```perl
META_MERGE => {
    'meta-spec' => { version => 2 },
     resources => {
         repository => {
             type => 'git',
             url  => 'https://github.com/dwimperl/Task-DWIM.git',
             web  => 'https://github.com/dwimperl/Task-DWIM',
         },
     },
},
```

Si su versión de ExtUtils::MakeMaker no admite todavía esto, simplemente actualizar ExtUtils::MakeMaker.

## Module::Build

Si utilizas [ Module::Build](https://metacpan.org/pod/Module::Build), agregue lo siguiente al Build.PL,
en la llamada <b>Module::Build->new</b>:

```perl
meta_merge => {
    resources => {
            repository => 'https://github.com/dwimperl/Task-DWIM'
    }
},
```


## Module::Install

Si utilizas [ Module::Install](https://metacpan.org/pod/Module::Install) agregar lo siguiente a Makefile.PL:

```perl
repository 'https://github.com/dwimperl/Task-DWIM';
```

## Dist::Zilla

Si utilizas [ Dist::Zilla](http://dzil.org/), el
[ Dist::Zilla::plugin::Repository](https://metacpan.org/pod/Dist::Zilla::Plugin::Repository)
agregará automáticamente el enlace a su repositorio, aunque también se puede especificar manualmente.

```perl
[MetaResources]
Repository.URL = https://github.com/dwimperl/Task-DWIM.git
```

Una versión detallada incluye más detalles como en el ejemplo siguiente. Como puedo ver, estas piezas son solamente
incluidas en el archivo META.json y no en el archivo META.yml. Para generar ese archivo, necesitará también
incluir el [ MetaJSON plugin](https://metacpan.org/pod/Dist::Zilla::Plugin::MetaJSON) de Dist::Zilla.

```perl
[MetaResources]
Repository.web = https://github.com/dwimperl/Task-DWIM
Repository.URL = https://github.com/dwimperl/Task-DWIM.git
Repository.Type = git

[MetaJSON]
```


Hay otras maneras de <a href="http://www.lowlevelmanager.com/2012/05/dzil-plugins-github-vs-githubmeta.html"> añadir
los enlaces de repositorio</a> a los META archivos  cuando se utiliza Dist::Zilla.

Probablemente la más simple forma es usar el
[ GithubMeta](https://metacpan.org/pod/Dist::Zilla::Plugin::GithubMeta) plugin 
añadiendo la siguiente línea al archivo dist.ini:

```
[GithubMeta]
```

## ¿Por qué debo añadir este enlace?

Es simple. Es más fácil enviar parches a la versión más reciente de su módulo,
más probable que los obtendrá.

También podría haber ya hecho algunos cambios a su módulo desde la última versión.
Tal vez ya has solucionado el error que me gustaría arreglar. Si puedo ver tu repositorio podemos evitar duplicar trabajo.

## Otros recursos

Si ya ha lidiado con esto, habría que agregar otros recursos también.
El [ CPAN META Specification ](https://metacpan.org/pod/CPAN::Meta::Spec#resources) tiene todo lo que aparece.
Si algo no está claro, sólo pregunta.

## Licencias

En otro artículo mostré [ Cómo agregar la información de la licencia a los META archivos de distribuciones CPAN](https://perlmaven.com/how-to-add-the-license-field-to-meta-files-on-cpan).
Si tuvieras un repositorio público, sería más fácil para otros enviar ese parche también.


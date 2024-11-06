---
title: "Comment ajouter le champ licence aux fichiers META de CPAN ?"
timestamp: 2013-06-01T16:45:56
tags:
  - licence
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
original: how-to-add-the-license-field-to-meta-files-on-cpan
author: szabgab
translator: oval
---


Chaque distribution sur CPAN peut inclure un fichier META sous deux formats, yml ou json.
Ces deux fichiers devraient maintenir la même information. META.json n'est que le nouveau format.
Ainsi, vous trouverez beaucoup plus de distributions avec seulement le fichier META.yml.
Et vous en trouverez quelques-unes, probablement de très anciennes distributions, sans aucun fichier META.

Ces deux fichiers META peuvent avoir un champ indiquant <b>la licence</b> de la distribution.

Avoir les informations de la licence dans les fichiers META permet pour des outils automatisés
de très facilement vérifier si un ensemble de modules a un certain ensemble de licences.


Comme les fichiers META sont généralement générés automatiquement lorsque la distribution est livrée par l'auteur,
je vais vous montrer comment vous pouvez configurer les quatre principaux systèmes d'empaquetage pour inclure le champ licence.

Dans les exemples ci-dessous, je vais utiliser la licence la plus courante, celle dénommée la licence <b>Perl</b> :

## ExtUtils::MakeMaker

Si vous utilisez [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker),
ajoutez la ligne suivante dans votre Makefile.PL comme paramètre dans la fonction WriteMakefile :

```perl
'LICENSE' => 'perl',
```

Si vous voulez vous assurer que les anciennes versions de ExtUtils::MakeMaker ne vont pas donner
des avertissements sur le champ inconnu LICENCE, vous pouvez utiliser le code suivant :

```perl
($ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE'  => 'perl', ) : ()),
```

[La version livrée avec perl 5.8.8 est 6.30](http://search.cpan.org/src/NWCLARK/perl-5.8.8/lib/ExtUtils/MakeMaker.pm) et
ne contient pas encore cette fonctionnalité. Le mieux serait de mettre à jour ExtUtils::MakeMaker.

## Module::Build

Si vous utilisez [Module::Build](https://metacpan.org/pod/Module::Build),
ajoutez la ligne suivante dans Build.PL, lors de l'appel à Module::Build->new :

```perl
license => 'perl',
```

## Module::Install

Si vous utilisez [Module::Install](https://metacpan.org/pod/Module::Install),
ajoutez la ligne suivante dans Makefile.PL :

```perl
license 'perl';
```

## Dist::Zilla

Si vous utilisez [Dist::Zilla](http://dzil.org/),
ajoutez la ligne suivante dans dist.ini :

```perl
license = Perl_5
```

## Spécification des META

Afin de vérifier la liste des options valides pour le champ de la licence,
consultez la spécification des META dans la documentation du module [CPAN::Meta::Spec](https://metacpan.org/pod/CPAN::Meta::Spec).

## Droit d'auteur et licence

Selon le [guide CPAN sur les licences](http://www.perlfoundation.org/cpan_licensing_guidelines) de la fondation Perl,
il est <b>obligatoire</b> d'avoir les informations de la licence dans les fichiers META.

Il y a bien sûr d'autres éléments nécessaires à la licence.
Cet article se concentre uniquement sur l'entrée dans les fichiers META.

---
title: "Comment ajouter la liste des contributeurs aux fichiers META de CPAN ?"
timestamp: 2013-06-01T20:45:56
tags:
  - x_contributors
  - contributeurs
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
translator: oval
---


Les fichiers META.json et META.yml des distributions CPAN sont des sources très importantes d'information automatisée.
Par exemple, pour une distribution, ils peuvent indiquer :
* [la licence](comment-ajouter-le-champ-licence-aux-meta-fichiers-cpan)
* [le lien vers le système de contrôle de version](comment-ajouter-le-lien-vers-le-systeme-de-controle-de-versions-d-une-distribution-cpan)

Ces champs sont répertoriés dans la documentation du module [CPAN::Meta::Spec](https://metacpan.org/pod/CPAN::Meta::Spec).

Il n'y a pas de champ spécifié pour la liste des contributeurs de la distribution, mais il y a un moyen d'ajouter des champs personnalisés :
il suffit de les préfixer avec x_ ou X_.


## Pourquoi devrais-je lister les contributeurs aussi dans le fichier META ?

Certes, ils sont déjà inscrits :
* ou bien dans le fichier des modifications Changes
* ou bien dans la documentation POD du module

Mais, avoir cette liste dans les fichiers META permettra à quelqu'un de les extraire automatiquement afin par exemple de les afficher dans l'outil [Meta CPAN](https://metacpan.org/).

Ainsi, il sera plus facile de trouver les endroits où une personne a contribué, même si elle n'a jamais publié un module.

## Comment ?

J'ai demandé à [David Golden](http://www.dagolden.com/) qui a suggéré d'utiliser le nom <b>x_contributors</b> à la liste des contributeurs de la même manière qu'ils sont dans la section 'auteurs' dans la section POD du module (Nom &lt;email>).

Voyons comment cela peut être réalisé par les principaux systèmes d'empaquetage !

## ExtUtils::MakeMaker

La version la plus récente de [Test::Strict](https://metacpan.org/release/Test-Strict) a déjà cela dans l'appel de WriteMakefile :

```perl
    META_MERGE => {
       x_contributors => [
        'Foo Bar <foo@bar.com>',
        'Zorg <zorg@cpan.org>',
       ],
    },
```

## Module::Build

J'ai ajouté la section appropriée pour [XML::Feed](https://metacpan.org/release/XML-Feed) bien qu'elle n'ait pas été livrée depuis.

Ajouter le code suivant dans l'appel à <b>Module::Build->new</b> :

```perl
    meta_merge =>
         {
            x_contributors => [
                'Foo Bar <foo@bar.com>',
                'Zorg <zorg@cpan.org>',
            ],
         },
```

## Module::Install

J'ai juste ajouté le code ci-dessous à la prochaine livraison de [Padre, l'EDI de Perl](http://padre.perlide.org/) :

```perl
Meta->add_metadata(
    x_contributors => [
        'Foo Bar <foo@bar.com>',
        'Zorg <zorg@cpan.org>',
    ],
);
```

## Dist::Zilla

Quand j'ai commencé à utiliser ce module, il n'y avait pas de façon manuelle pour ajouter un champ supplémentaire ayant plusieurs valeurs,
mais David Golden a rapidement livré le module d'extension [Dist::Zilla::Plugin::Meta::Contributors](https://metacpan.org/pod/Dist::Zilla::Plugin::Meta::Contributors) qui vous permet d'écrire ceci :

```perl
[Meta::Contributors]
contributor = Foo Bar <foo@bar.com>
contributor = Zorg <zorg@cpan.org>
```

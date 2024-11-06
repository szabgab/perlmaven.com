---
title: "Comment ajouter le lien versle système de contrôle de version d'une distribution aux fichiers META de CPAN ?"
timestamp: 2013-06-01T10:45:56
tags:
  - Git
  - Github
  - SVN
  - Subversion
  - VCS
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
original: how-to-add-link-to-version-control-system-of-a-cpan-distributions
author: szabgab
translator: oval
---


Que vous utilisiez [Meta CPAN](https://www.metacpan.org/) ou [search.cpan.org](http://search.cpan.org/),
vous verrez que certains modules ont un lien vers Github ou tout autre endroit où les auteurs de ces modules entreposent leurs projets.

search.cpan.org affiche juste la valeur en clair du lien au niveau du champ libellé <i><b>Repository</b></i> (Dépôt).
Meta CPAN fournit le lien dont le libellé se trouve entre parenthèses <i><b>(&lt;nom_du_dépôt> clone)</i></b>, au niveau du champ libellé <i><b>Repository</b></i> (Dépôt). Pour Github, une fenêtre contextuelle fournit des informations détaillées dans un beau format. Les autres sites personnels n'auront certainement que le lien.


Les deux sites retrouvent ce lien vers le système de contrôle de version depuis les fichiers META inclus dans les distributions CPAN.
Soit le fichier META.yml, soit le fichier META.json, celui-ci étant le plus récent. Ils ne devraient différer que dans leur format.

Comme les fichiers META sont généralement générés automatiquement lorsque la distribution est livrée par l'auteur,
je vais vous montrer comment vous pouvez configurer les quatre principaux systèmes d'empaquetage pour inclure le champ dépôt.

Dans les exemples ci-dessous, je vais utiliser le lien vers le dépôt de [Task::DWIM](https://metacpan.org/pod/Task::DWIM)
qui est une distribution expérimentale qui liste tous les modules inclus dans la distribution [DWIM Perl](http://dwimperl.szabgab.com/).

## ExtUtils::MakeMaker

Si vous utilisez [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker),
ajoutez la ligne suivante dans votre Makefile.PL comme paramètre dans la fonction WriteMakefile :

```perl
META_MERGE => {
    resources => {
        repository => 'https://github.com/dwimperl/Task-DWIM',
    },
},
```

Si votre version de ExtUtils::MakeMaker ne supporte pas cette fonctionnalité, il suffit de mettre à jour ExtUtils::MakeMaker.

## Module::Build

Si vous utilisez [Module::Build](https://metacpan.org/pod/Module::Build),
ajoutez la ligne suivante dans Build.PL, lors de l'appel à Module::Build->new :

```perl
meta_merge => {
    resources => {
        repository => 'https://github.com/dwimperl/Task-DWIM'
    }
},
```

## Module::Install

Si vous utilisez [Module::Install](https://metacpan.org/pod/Module::Install),
ajoutez la ligne suivante dans Makefile.PL :

```perl
repository 'https://github.com/dwimperl/Task-DWIM';
```

## Dist::Zilla

Si vous utilisez [Dist::Zilla](http://dzil.org/),
le module d'extension [Dist::Zilla::Plugin::Repository](https://metacpan.org/pod/Dist::Zilla::Plugin::Repository)
ajoute automatiquement le lien vers votre dépôt, mais vous pouvez également le spécifier manuellement :

```perl
[MetaResources]
repository.url = https://github.com/dwimperl/Task-DWIM.git
```

Une version détaillée incluerait plus de détails comme dans l'exemple suivant.
Ces détails ne sont inclus que dans le fichier META.json, pas dans le fichier META.yml.
Pour générer ce fichier, vous aurez également besoin de comprendre le module d'extension
[Dist::Zilla::Plugin::MetaJSON](https://metacpan.org/pod/Dist::Zilla::Plugin::MetaJSON).

```perl
[MetaResources]
repository.web = https://github.com/dwimperl/Task-DWIM
repository.url = https://github.com/dwimperl/Task-DWIM.git
repository.type = git

[MetaJSON]
```

Il y a d'autres façons <a href="http://www.lowlevelmanager.com/2012/05/dzil-plugins-github-vs-githubmeta.html">d'ajouter
 des liens vers des dépôts (EN)</a> dans les fichiers META lors de l'utilisation Dist::Zilla.

## Pourquoi dois-je ajouter ce lien ?

C'est simple ! Plus il est facile d'envoyer des correctifs pour la version la plus récente de votre module, plus il est probable que vous les aurez !

Aussi, vous avez peut-être déjà apporté quelques modifications à votre module depuis la dernière version.
Vous avez peut-être déjà fixé le bogue que j'aimerais corriger. Si je peux voir votre dépôt, nous pouvons éviter le travail en double.

## Autres ressources

Pendant que vous êtes dans la gestion des fichiers META, vous pouvez ajouter d'autres ressources de cette manière.
La [spécification Meta CPAN](https://metacpan.org/pod/CPAN::Meta::Spec#resources) répertorie toutes ces ressources.
Si un point de cette documentation n'est pas clair, il suffit de demander de l'aide.

## Licences

Dans un autre article, j'ai montré [comment ajouter les informations de licence pour les fichiers META des distributions CPAN](/comment-ajouter-le-champ-licence-aux-meta-fichiers-cpan). Si vous aviez un dépôt public, il serait aussi plus facile pour les autres d'envoyer ce correctif.

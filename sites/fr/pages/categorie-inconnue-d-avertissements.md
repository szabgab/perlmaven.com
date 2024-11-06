---
title: "Catégorie inconnue d'avertissements"
timestamp: 2013-04-19T10:30:03
tags:
  - ;
  - warning
  - avertissement
  - catégorie inconnue
  - message d'erreur
published: true
original: unknown-warnings-category
books:
  - beginner
author: szabgab
translator: oval
---


Je ne pense pas que ce genre de message d'erreur soit souvent rencontré en Perl.
Au moins, je ne me souviens pas d'en avoir eu depuis des lustres, mais récemment, cela m'est tombé dessus au cours d'une formation Perl.


## Catégorie d'avertissement '1' inconnue

Le message complet ressemblait à ceci :

```
Unknown warnings category '1' at hello_world.pl line 4
BEGIN failed--compilation aborted at hello_world.pl line 4.
Bonjour tout le monde
```

Ceci était contrariant, surtout que le code était simplissime :

```
use strict;
use warnings

print "Bonjour tout le monde";
```

J'ai scruté le code un bon moment sans voir de problème.
Comme vous pouvez le voir, la chaîne de caractères "Bonjour tout le monde" est affichée.

J'étais troublé et j'ai pris pas mal de temps avant de remarquer ce que vous avez déjà probablement noté :
le problème est le point-virgule manquant à la fin de l'instruction `use warnings`.

Perl exécute l'instruction `print` qui affiche la chaîne de caractères et qui retourne 1 (ce qui indique que `print` a réussi).
Ainsi, Perl pense que j'ai écrit `use warnings 1`.

Il est possible d'indiquer quelles catégories utiliser avec `use warnings`, mais la catégorie 1 n'existe pas.

## Catégorie d'avertissement 'Foo' inconnue

Ceci est un autre cas du même problème.

Le message d'erreur ressemble à ceci :

```
Unknown warnings category 'Foo' at hello.pl line 4
BEGIN failed--compilation aborted at hello.pl line 4.
```

et le code d'exemple ci-dessous montre comment l'interpolation de chaînes fonctionne.
C'est le second exemple que j'enseigne, juste après "Bonjour tout le monde".

```perl
use strict;
use warnings

my $name = "Foo";
print "Salut $name\n";
```

## Points-virgules manquants

Bien sûr, les exemples donnée ci-dessus ne sont que des cas très spéciaux du problème générique d'oublier un point-virgule que Perl ne peut détecter que sur l'instruction suivante.

Le bon réflexe face à ce genre de message d'erreur est de vérifier la ligne précédant celle indiquée dans le message d'erreur : elle ne finit pas par un point-virgule.


---
title: "Les tableaux en Perl"
timestamp: 2013-06-15T15:45:02
tags:
  - tableau
  - tableaux
  - longueur
  - taille
  - "@"
  - foreach
  - Data::Dumper
  - scalar
  - push
  - pop
  - shift
published: true
original: perl-arrays
books:
  - beginner
author: szabgab
translator: oval
---


Dans cet article du [tutoriel Perl](/perl-tutorial), nous allons en apprendre davantage sur les tableaux en Perl.
Ceci est un aperçu de la façon dont fonctionnent les tableaux en Perl. Nous donnerons des explications plus détaillées dans de futurs articles.

Les noms de variables des tableaux en Perl sont préfixés par le symbole `@` appelé dans le jargon Perl un <i>sigil</i>.
(mnémonique : `@` représente le premier a de <i>array</i>).

Comme nous encourageons systématiquement l'utilisation de `strict`,
vous devez déclarer ces variables en utilisant le mot-clé `my` avant la première assignation.


Rappelez-vous ! Tous les exemples ci-dessous supposent que votre fichier commence par :

```perl
use strict;
use warnings;
use 5.010;
```

## Initialisation d'un tableau Perl

Déclarer un tableau tout simplement :

```perl
my @noms;
```

Déclarer un tableau tout en lui assignant des valeurs :

```perl
my @noms = ("Foo", "Bar", "Baz");
```

## Débogage d'un tableau Perl

```perl
use Data::Dumper qw(Dumper);

my @noms = ("Foo", "Bar", "Baz");

say Dumper \@noms;
```

Le résultat est le suivant :

```
$VAR1 = [
    'Foo',
    'Bar',
    'Baz'
];
```

## Le mot-clé foreach pour parcourir un tableau Perl

```perl
my @noms = ("Foo", "Bar", "Baz");
foreach my $n (@noms) {
  say $n;
}
```

Le résultat est le suivant :

```
Foo
Bar
Baz
```

## Accéder à un des éléments d'un tableau Perl

```perl
my @noms = ("Foo", "Bar", "Baz");
say $noms[0];
```

Attention ! Lorsque vous accédez à un seul élément d'un tableau, le <i>sigil</i> change de `@` à `$`.
Cela pourrait causer de la confusion pour certaines personnes, mais si vous y réfléchissez deux minutes, il est assez facile de comprendre pourquoi.

`@` marque le pluriel et `$` le singulier.
Lorsque vous accédez à un seul élément d'un tableau, celui-ci se comporte comme une variable scalaire normale.

## Les indices dans un tableau Perl

Les indices d'un tableau commencent à partir de 0.
Le plus grand indice est toujours dans la variable notée `&lt;$#nom_du_tableau>`.

```perl
my @noms = ("Foo", "Bar", "Baz");
say $#noms;
```

Le résultat est le suivant :

```
2
```

car les indices sont 0, 1 et 2.

## Longueur ou taille d'un tableau Perl

En Perl il n'ya pas de fonction spéciale pour aller chercher la taille d'un tableau,
mais il y a plusieurs façons d'obtenir cette valeur.

D'une part, la taille d'un tableau est le plus grand indice augmenté de 1.
Dans l'exemple ci-dessus, `$#noms+1` est la <b>taille</b> ou la <b>longueur</b> du tableau.

D'autre part, la fonction prédéfinie `scalar` peut être utilisée pour obtenir la taille d'un tableau :

```perl
my @noms = ("Foo", "Bar", "Baz");
say scalar @noms;
```

Le résultat est le suivant :

```
3
```

La fonction fonction prédéfinie `scalar` est une sorte de fonction de conversion qui
- entre autres choses - convertit un tableau en un scalaire.
En raison d'une décision arbitraire, mais intelligente, cette conversion donne la taille du tableau.

## Une boucle basée les indices d'un tableau

Il y a des cas où une boucle sur les valeurs d'un tableau n'est pas suffisant.
Nous pourrions avoir besoin à la fois de la valeur et de l'indice de cette valeur.
Dans ce cas, nous avons besoin de faire une boucle sur les indices, et nous obtenons les valeurs en utilisant les indices.

```perl
my @noms = ("Foo", "Bar", "Baz");
foreach my $i (0 .. $#noms) {
  say "$i - $noms[$i]";
}
```

Le résultat est le suivant :

```
0 - Foo
1 - Bar
2 - Baz
```

## La fonction prédéfinie push appliquée sur un tableau Perl

La fonction prédéfinie `push` ajoute une nouvelle valeur à la fin du tableau qui donc grandit.

```perl
my @noms = ("Foo", "Bar", "Baz");

push @noms, 'Moo';
say Dumper \@names;
```

Le résultat est le suivant :

```
$VAR1 = [
    'Foo',
    'Bar',
    'Baz',
    'Moo'
];
```

## La fonction prédéfinie pop appliquée sur un tableau Perl

La fonction prédéfinie `pop` récupère le dernier élément du tableau.

```perl
my @noms = ("Foo", "Bar", "Baz");
my $dernier_element = pop @noms;

say "Dernier élément : $dernier_element";
say Dumper \@noms;
```

Le résultat est le suivant :

```
Last: Baz
$VAR1 = [
    'Foo',
    'Bar',
];
```

## La fonction prédéfinie shift appliquée sur un tableau Perl

La fonction prédéfinie `shift` :
* retourne l'élément le plus à gauche d'un tableau (càd le premier élément)
* et déplace tous les autres éléments vers la gauche

```perl
my @noms = ("Foo", "Bar", "Baz");
my $element_le_plus_a_gauche = shift @noms;

say "Premier élément : $element_le_plus_a_gauche";
say Dumper \@noms;
```

Le résultat est le suivant :

```
Premier élément : Foo
$VAR1 = [
    'Bar',
    'Baz',
];
```

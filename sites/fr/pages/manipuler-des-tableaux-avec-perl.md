---
title: "Manipuler des tableaux avec Perl : shift, unshift, push, pop"
timestamp: 2013-06-08T14:45:01
tags:
  - tableau
  - shift
  - unshift
  - push
  - pop
  - fonction prédéfinie
published: true
original: manipulating-perl-arrays
books:
  - beginner
author: szabgab
translator: oval
---


En plus de permettre un accès direct à chaque élément d'un tableau,
Perl fournit également diverses autres façons intéressantes afin de manipuler des tableaux.
En particulier, il y a des fonctions qui permettent d'utiliser très facilement et efficacement un tableau Perl comme une pile ou une file d'attente.


## La fonction prédéfinie pop

La fonction `pop` enlève et retourne le dernier élément d'un tableau.

```perl
my @noms = ('Foo', 'Bar', 'Baz');
my $dernier = pop @noms;

print "$dernier\n";  # Baz
print "@noms\n";     # Foo Bar
```

Dans ce premier exemple, vous pouvez voir comment, étant donné un tableau de trois éléments,
la fonction `pop` enlève le dernier élément (celui avec l'indice le plus élevé) de ce tableau et le renvoie.

Dans le cas particulier d'un tableau donné vide, la fonction `pop`
retourne [undef (EN)](https://perlmaven.com/undef-and-defined-in-perl).

## La fonction prédéfinie push

La fonction `push` peut ajouter une ou plusieurs valeurs à la fin d'un tableau
(En fait, il peut également ajouter zéro valeur, mais ce n'est pas très utile, n'est-ce pas?).

```perl
my @noms = ('Foo', 'Bar');
push @noms, 'Moo';
print "@noms\n";     # Foo Bar Moo

my @autres = ('Darth', 'Vader');
push @noms, @autres;
print "@noms\n";     # Foo Bar Moo Darth Vader
```

Dans cet exemple, au départ, le tableau a deux éléments.

Lors du premier appel à `push`, nous avons ajouté une valeur scalaire unique à la fin du tableau `@noms`.
Ainsi, ce tableau a gagné un élément, ayant donc trois éléments au total.

Lors du deuxième appel à `push`, nous avons ajouté les valeurs contenues dans le tableau `@autres` à la fin du tableau `@noms`.
Ainsi, ce tableau a gagné deux éléments, ayant donc cinq éléments au total.

## La fonction prédéfinie shift

La fonction `shift` déplace l'ensemble des éléments d'un tableau vers la gauche,
en supposant que vous imaginez le tableau commencer par la gauche.
Le premier élément du tableau est enlevé et devient la valeur de retour de la fonction.

Après l'opération, le tableau a un élément de moins.
Elle est assez similaire à `pop`, mais elle fonctionne au début du tableau.

```perl
my @noms = ('Foo', 'Bar', 'Moo');
my $premier = shift @noms;
print "$premier\n";  # Foo
print "@noms\n";     # Bar Moo
```

Dans le cas particulier d'un tableau donné vide, la fonction <b>shift</b>
retourne [undef (EN)](https://perlmaven.com/undef-and-defined-in-perl).

## La fonction prédéfinie unshift

La fonction `unshift` est la fonction inverse de la fonction `shift`.
`unshift` aura une ou plusieurs valeurs (ou zéro si c'est ce que vous voulez) qui sera (seront)
placée(s) au début du tableau en déplaçant tous les autres éléments vers la droite.

```perl
my @noms = ('Foo', 'Bar');
unshift @noms, 'Moo';
print "@noms\n"; # Moo Foo Bar 

my @autres = ('Darth', 'Vader');
unshift @noms, @autres;
print "@noms\n"; # Darth Vader Moo Foo Bar
```

Suivant l'exemple ci-dessus, vous pouvez appeler cette fonction avec en premier argument un tableau (`@noms` ) suivi par :
* soit une seule valeur scalaire ('Moo') qui devient alors le premier élément du tableau
* soit un deuxième tableau (`@autres`) dont les éléments seront copiés au début du premier tableau dont les autres éléments seront déplacés vers des indices plus élevés

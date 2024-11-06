---
title: "Jeu "Devine un nombre""
timestamp: 2013-05-26T22:45:17
tags:
  - rand
  - hasard
  - int
  - entier
published: true
original: number-guessing-game
books:
  - beginner
author: szabgab
translator: oval
---


Dans cet article du [tutoriel Perl](/perl-tutorial), nous allons commencer à construire un jeu tout petit, masis ô combien amusant.
Ce fut le premier jeu que j'ai écrit quand j'étais au lycée, avant même que Perl 1.0 soit sorti.


Pour écrire ce jeu, nous devons apprendre deux sujets simples et sans rapport entre eux :
<b>Comment générer des nombres aléatoires en Perl</b> et
<b>Comment obtenir la partie entière d'un nombre</b>.

## Partie entière d'un nombre rationnel

La fonction prédéfinie `int()` renvoie la partie entière de son paramètre :

```perl
use strict;
use warnings;
use 5.010;
 
my $x = int 3,14;
say $x; # va afficher 3
 
my $z = int 3;
say $z; # va aussi a1fficher 3
 
my $w = int 3,99999;
say $w; # même ceci affichera 3
 
say int -3,14; # va afficher -3
```

## Nombres aléatoires

Un appel à la fonction prédéfinie `rand($n)` de Perl retourne un nombre aléatoire rationnel compris entre 0 et $n, 0 inclus mais $n exclus.

Si `$n = 42`, alors un appel à `rand($n)` retourne un nombre aléatoire compris entre 0 inclus mais 42 exclus. Par exemple : 11,264624821095826.

Si nous ne donnons aucune valeur, alors `rand()` par défaut retourne des valeurs comprises entre 0 et 1, 0 inclus mais 1 exclus.

Combiner `rand` et `int` permet de générer des nombres aléatoires entiers.

Le code suivant :

```perl
use strict;
use warnings;
use 5.010;
 
my $z = int rand 6;
say $z;
```

retourne un des nombres entiers compris entre 0 et 6, 0 inclus mais 6 exclus. La valeur de retour peut donc être l'un des nombres suivants : 0,1,2,3,4,5.

Si nous ajoutons maintenant 1 au résultat, alors nous obtenons l'un des nombres 1,2,3,4,5,6, ce qui est équivalent à jeter un dé à six faces.

## Exercice : jeu devine un nombre

C'est le début d'un jeu que nous allons écrire. Un jeu petit, mais amusant.

Écrire un script dans lequel la fonction prédéfinie `rand()` permet à l'ordinateur de "penser" à un nombre entier compris entre 1 et 200. L'utilisateur doit deviner ce nombre.

Après que l'utilisateur a écrit au clavier le nombre auquel il pensait, l'ordinateur indique si ce nombre donné était plus grand ou plus petit que le nombre "pensé".

A ce stade, <b>il n'est pas nécessaire</b> de permettre à l'utilisateur de deviner à plusieurs reprises.
Nous y travaillerons dans un autre article. Bien sûr, je ne vais pas vous empêcher de lire la [boucle while en Perl (EN)](https://perlmaven.com/while-loop).
Vous pouvez lire cet article et laisser l'utilisateur deviner à plusieurs reprises.

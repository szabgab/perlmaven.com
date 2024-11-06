---
title: "Ajouter en fin de fichier"
timestamp: 2013-04-19T10:30:01
tags:
  - files
  - append
  - open
  - ">>"
published: true
original: appending-to-files
books:
  - beginner
author: szabgab
translator: oval
---


Dans cette leçon issue du [tutoriel de Perl](/perl-tutorial), nous allons voir <b>comment inclure des données en fin de ficher avec Perl</b>.

Dans la précédente leçon, nous avons appris [comment écrire dans des fichiers](https://perlmaven.com/writing-to-files-with-perl).
Ce cas d'utilisation est bon quand nous sommes entrain de créer un fichier vide, mais il existe d'autres cas d'utilisation où vous aimeriez garder le contenu du fichier original tout en ajoutant quelques nouvelles lignes de contenu en fin de ce fichier.

Le cas le plus répandu étant quand vous écrivez dans un fichier journal.


Ouvrir un fichier avec le symbole `>` détruira le contenu du fichier s'il y en avait un :

```perl
open(my $fh, '>', 'rapport.txt') or die ...
```

Si nous voulions ajouter du contenu à la fin de ce fichier, nous utiliserions le double symbole `>>`, comme montré dans l'exemple ci-dessous :

```perl
open(my $fh, '>>', 'rapport.txt') or die ...
```

Appeler cette fonction prédéfinie ouvrira le fichier en mode ajout à la fin. Cela signifie que le fichier restera intact et quelque soit ce que `print()` ou `say()` envoie dans ce fichier sera ajouté en fin de ce fichier.

L'exemple complet est comme ci-dessous :

```perl
use strict;
use warnings;
use 5.010;

my $nom_de_fichier = 'rapport.txt';
open(my $fh, '>>', $nom_de_fichier) or die "Impossible d'ouvrir le fichier '$nom_de_fichier' $!";
say $fh "Mon premier rapport généré via perl";
close $fh;
say 'effectué!';
```

Si vous lancez ce script plusieurs fois, vous verrez que ce fichier grandit.
À chaque fois que ce script est lancé, une nouvelle ligne est ajouté en fin du fichier.


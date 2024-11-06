---
title: "La fonction prédéfinie join"
timestamp: 2013-04-19T10:30:05
tags:
  - join
published: true
original: join
books:
  - beginner
author: szabgab
translator: oval
---


Je suppose qu'il n'y a pas grand chose à dire concernant la fonction prédéfinie `join`,
à part qu'elle est le pendant de la fonction prédéfinie `split`.


Cette fonction accepte plusieurs éléments d'une liste ou d'un tableau, et les rassemblent tous ensemble dans une chaine de caractères.

```perl
use strict;
use warnings;
use v5.10;

my @noms = ('Foo', 'Bar', 'Moo');
my $chaine = join ':', @noms;
say $chaine;                    # Foo:Bar:Moo

my $valeur = join "-", $chaine, "noms";
say $valeur;                    # Foo:Bar:Moo-noms


$chaine = join '', @noms, 'Baz';
say $chaine;                    # FooBarMooBaz
```

Le premier paramètre de la fonction prédéfinie <b>join</b> est le "connecteur", une chaîne de caractères qui sera insérée entre chacun des autres paramètres.
Les paramètres suivants restants seront réduits à une liste d'éléments qui seront agglutinés les uns aux autres par le "connecteur".

Ce "connecteur" peut être n'importe quelle chaîne de caractères, même une chaîne vide.



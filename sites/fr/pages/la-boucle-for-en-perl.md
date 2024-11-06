---
title: "La boucle for en Perl"
timestamp: 2013-06-15T08:46:13
tags:
  - for
  - foreach
  - boucle
  - boucle infinie
published: true
original: for-loop-in-perl
books:
  - beginner
author: szabgab
translator: oval
---


Dans cet article du [tutoriel Perl](/perl-tutorial), nous allons parler de la boucle `for` en Perl.
Certaines personnes l'appellent également <b>la boucle <i>for</i> de style C</b>, mais
cette construction est en fait disponible dans de nombreux langages de programmation.


## Le mot-clé for

Le <b>mot-clé for</b> en Perl peut fonctionner de deux manières différentes :
* exactement comme une boucle `foreach`
* comme la boucle `for` de style C, qui est composée de trois parties

Perl détermine l'utilisation que vous avez en tête.

Je vais décrire les deux fonctionnements, même si je préfère utiliser la boucle de style `foreach`,
comme décrit dans l'article [les tableaux en Perl](/les-tableaux-en-perl).

Les deux mots-clés `for` et `foreach` peuvent être utilisés comme des synonymes, voir la section `foreach` ci-dessous.

<b>La boucle <i>for</i> de style C</b> est composée de 3 parties dans sa section de contrôle, et d'une quatrième qui est un bloc de code.
En général, elle ressemble au code ci-dessous, bien qu'il soit possible d'omettre l'une de ces 4 parties :

```perl
for (<INITIALISATION> ; <CONDITION D'EXÉCUTION> ; <INCRÉMENTATION>) {
  <CORPS>
}
```

voir le code ci-dessous à titre d'exemple :

```perl
for (my $i = 0; $i <= 9; $i++) {
   print "$i\n";
}
```

La partie INITIALISATION sera exécutée une et une fois lorsque l'exécution atteint ce point.

Puis, immédiatement après INITIALISATION, la partie CONDITION D'EXÉCUTION est exécutée.
Si cette condition est fausse, alors la quatrième partie { CORPS } est complètement ignorée.
Si cette condition est vraie, alors :
* la quatrième partie { CORPS } est exécutée
* la troisième partie INCRÉMENTATION est exécutée juste après

(Pour la signification exacte de VRAI et FAUX en Perl, allez lire l'article [Les valeurs booléennes en Perl](/valeurs-booleennes-en-perl))

Puis revient la partie <CONDITION D'EXÉCUTION>. La boucle continue encore et encore, tant que la <CONDITION D'EXÉCUTION> retourne une valeur vraie.

Donc, le déroulement de la boucle ressemble à ceci :

```
<INITIALISATION>

<CONDITION D'EXÉCUTION> # vrai
    <CORPS>
    <INCRÉMENTATION>

<CONDITION D'EXÉCUTION> # vrai
    <CORPS>
    <INCRÉMENTATION>

...

<CONDITION D'EXÉCUTION> # faux

...

```

## Le mot-clé foreach

La boucle ci-dessus - allant de 0 à 9 - peut être écrit dans une boucle `foreach` comme
ci-dessous et je pense que l'intention est beaucoup plus claire :

```perl
foreach my $i (0..9) {
  print "$i\n";
}
```

Comme je l'ai indiqué dans la section précédente, `for` et `foreach` sont en fait synonymes,
de sorte que certaines personnes utilisent `for` pour écrire une boucle  de type `foreach` comme ceci :

```perl
for my $i (0..9) {
  print "$i\n";
}
```

## Les parties de la boucle pour Perl

INITIALISATION est bien sûr pour initialiser une variable. Elle est exécutée une et une seule fois.

CONDITION D'EXÉCUTION est une expression booléenne qui teste si la boucle doit s'arrêter ou doit continuer.
Elle est exécutée au moins une fois. Elle est exécutée une fois de plus que CORPS et INCRÉMENTATION le sont.

CORPS est un ensemble d'instructions que nous voulons faire répéter autant de fois que CONDITION D'EXÉCUTION est vraie.
Dans certains cas, CORPS vide peut aussi être logique. En fait, ces cas devraient être réécrits d'une manière plus compréhensible sur le long terme.

INCRÉMENTATION est un autre ensemble d'instructions réduit généralement afin d'augmenter ou de diminuer un variable servant d'index.
Elle peut aussi être laissée vide si, par exemple, nous faisons ce changement à l'intérieur de CORPS.

## La boucle infinie

Vous pouvez écrire une boucle infinie en utilisant la boucle `for` :

```perl
for (;;) {
  # do something
}
```

Habituellement, les gens l'écrivent avec une instruction `while` comme ci-dessous :

```perl
while (1) {
  # do something
}
```

Elle est décrite dans l'article [la boucle while en Perl](/la-boucle-while-en-perl).

## perldoc

Vous pouvez trouver la description officielle de la boucle `for` dans <a href="http://perldoc.perl.org/perlsyn.html#For-Loops">la section <b>perlsyn</b> de la documentation Perl</a>.

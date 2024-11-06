---
title: "la valeur initiale undef et la fonction prédéfinie defined en Perl"
timestamp: 2013-06-29T23:01:05
tags:
  - undef
  - defined
published: true
original: undef-and-defined-in-perl
books:
  - beginner
author: szabgab
translator: oval
---


Dans certains langages, il y a une façon particulière d'indiquer que «cette variable n'a pas de valeur» :
* `Null` en SQL, PHP et Java
* `None` en Python
* `Nil` en Ruby

En Perl, cette valeur est notée `undef`.


Étudions cette valeur plus en détail !

## D'où vient la valeur undef ?

Lorsque vous déclarez une variable scalaire sans lui attribuer de valeur, son contenu sera la valeur bien définie `undef`.

```perl
my $x;
```

Certaines fonctions retournent `undef` pour indiquer l'échec.
D'autres retournent `undef` si elles n'ont pas de réelles valeurs à retourner.

```perl
my $x = do_something();
```

Vous pouvez utiliser la fonction prédéfinie `undef()` pour réinitialiser une variable à `undef` :

```perl
# some code
undef $x;
```

Vous pouvez même utiliser la valeur de retour de la fonction prédéfinie `undef()` pour définir une variable à `undef`.

```perl
$x = undef;
```

Les parenthèses après le nom de la fonction sont facultatives. Je les ai donc omises dans l'exemple.

Comme vous pouvez le voir, il y a un certain nombre de façons d'obtenir <i><b>undef</b></i> dans une variable scalaire.
La question est alors : qu'est-ce qui se passe si vous utilisez une telle variable ?

Mais avant cela, nous allons voir quelque chose d'autre :

## Comment vérifier si une valeur ou une variable est à <i>undef</i> ?

La fonction prédéfinie `defined()` retourne [vrai](/valeurs-booleennes-en-perl) si la valeur donnée est <i><b>not undef</b></i>.
Elle retourne [faux](/valeurs-booleennes-en-perl) si la valeur donnée est <i><b>undef</b></i>.

Vous pouvez l'utiliser de cette façon :

```perl
use strict;
use warnings;
use 5.010;

my $x;

# écrire du code qui pourrait initialiser $x ou non

if (defined $x) {
    say '$x est définie';
} else {
    say '$x est indéfinie';
}
```

## Quelle est la valeur réelle de <i>undef</i> ?

Bien qu'<b>undef</b> indique l'absence de valeur, il est encore possible d'utiliser la variable indéfinie.

Perl fournit deux valeurs par défaut utiles qui remplaceront <i>undef</i> selon le contexte.
Si vous utilisez une variable qui est <i>undef</i> dans :
* une opération numérique, alors elle se comporte comme si elle était égale à 0
* une opération de chaîne, alors elle se comporte comme si elle était egale à une chaîne vide

Voir l'exemple suivant :

```perl
use strict;
use warnings;
use 5.010;

my $x;
say $x + 4, ;  # 4
say 'Foo' . $x . 'Bar' ;  # FooBar

$x++;
say $x; # 1
```

Dans l'exemple ci-dessus, la variable $x - qui est à <i>undef</i> par défaut - se comporte comme :
* un 0 dans le plus (+)
* une chaîne vide dans la concaténation (.)
* un 0 de nouveau dans l'auto-incrémentation (++)

Cela n'est pas parfait, loin s'en faut. Si vous avez activé les avertissements via l'instruction `use warnings` ([ce qui est toujours recommandé](https://perlmaven.com/installing-perl-and-getting-started)), vous serez confrontés à deux avertissements [use of unitialized value](https://perlmaven.com/use-of-uninitialized-value) pour les deux premières instructions, mais pas pour celle de l'auto-incrémentation :

```
Use of uninitialized value $x in addition (+) at ... line 6.
Use of uninitialized value $x in concatenation (.) or string at ... line 7.
```

Je pense que vous ne l'avez pas pour l'auto-incrémentation, car perl est indulgent.
Nous verrons plus tard que c'est très pratique dans les endroits où vous souhaitez compter des choses.

Vous pouvez, bien sûr, éviter les avertissements en initialisant la variable à la valeur initiale correcte (0 ou la chaîne vide, en fonction de ce qu'elle devrait être), ou en désactivant les avertissements appropriés. Nous en parlerons dans un autre article.

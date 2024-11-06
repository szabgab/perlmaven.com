---
title: "Les barewords en Perl"
timestamp: 2013-05-05T10:45:56
tags:
  - bareword
  - strict
published: true
original: barewords-in-perl
books:
  - beginner
author: szabgab
translator: oval
---


`use strict` comporte 3 parties. L'une d'entre elles, appelée ainsi : `use strict "subs"`, interdit <b>l'utilisation inappropriée des <i>barewords</i></b>.

Qu'est-ce que cela signifie ?


Sans cette restriction, le code ci-dessous fonctionne et affiche "salut".

```perl
my $x = salut;
print "$x\n"; # salut
```

C'est étrange en soi, car nous avons l'habitude de mettre les chaînes de caractères entre guillemets. Mais Perl, par défaut, permet aux <i>barewords</i> - des mots sans guillemets - de se comporter comme des chaînes de caractères.

Le code ci-dessus affiche donc "salut". En fait, au moins jusqu'à ce que quelqu'un ajoute une routine appelée "salut" en haut de votre script :

```perl
sub salut {
  return "zzz";
}
 
my $x = salut;
print "$x\n"; # zzz
```

Oui. Dans cette version, perl voit la routine salut(), l'appelle, et assigne à $x la valeur de retour de cette routine.

Néanmoins, si quelqu'un déplace la routine à la fin de votre fichier, après l'assignation, perl ne vois pas tout d'un coup la routine au moment de l'assignation. Résultat : nous nous retrouvons au point de départ, c'est-à-dire $x valorisée avec "salut".

Non, vous ne voulez pas vous retrouver dans un tel désordre par accident. En fait, sans doute jamais. En ayant `use strict` dans votre code, perl n'autorisera pas le <i>bareword</i> "salut" dans votre code, ce qui permet d'éviter ce type de confusion.

Le code ci-dessous

```perl
use strict;
 
my $x = salut;
print "$x\n";
```

donne l'erreur suivante :

```
Bareword "hello" not allowed while "strict subs" in use at script.pl line 3.
Execution of script.pl aborted due to compilation errors.
```

## Du bon usage des <i>barewords</i>

Il y a d'autres endroits où les <i>barewords</i> peuvent être utilisés même lorsque `use strict "subs"` est activé.

Tout d'abord, les noms des routines que nous créons ne sont réellement que des <i>barewords</i>. C'est bon d'avoir cela !

Nous pouvons aussi utiliser des <i>barewords</i> :
* sur le côté gauche de la flèche double =>
* entre accolades lorsque nous faisons référence à un des éléments d'un tableau associatif

```perl
use strict;
use warnings;
 
my %h = (nom => 'Foo');

print $h{nom}, "\n";
```

Dans les deux cas du code ci-dessus, "nom" est un <i>bareword</i>,
mais ceux-ci sont autorisés même lorsque `use strict` est activé.

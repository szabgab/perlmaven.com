---
title: "La boucle while en Perl"
timestamp: 2013-06-15T12:45:51
tags:
  - boucle
  - boucle infinie
  - while
  - last
published: true
original: while-loop
books:
  - beginner
author: szabgab
translator: oval
---


Dans cet article du [tutoriel Perl](/perl-tutorial), nous allons voir comment fonctionne la boucle `while` en Perl.


La boucle `while` a :
* une condition
* un bloc de code enveloppé dans des accolades

```perl
use strict;
use warnings;
use 5.010;

my $compteur = 10;

while ($compteur > 0) {
  say $compteur;
  $compteur -= 2;
}
say 'fin';
```

Dans l'exemple ci-dessus :
* cette condition vérifie si la variable $compteur est supérieure à 0
* ce bloc de code affiche la variable $compteur et la décrémente de 2

Lorsque l'exécution atteint d'abord le début de la boucle `while`,
il est vérifié si la condition de ce `while` est [vraie ou fausse](/valeurs-boolennes-en-perl).

Si la condition est fausse, le bloc est ignoré et la déclaration suivante, dans notre cas l'affichage de «fin», est exécutée.

Si la condition est vraie, le bloc est exécuté, puis l'exécution remonte au niveau de la condition afin de l'évaluer de nouveau.
Si la condition est fausse, le bloc est ignoré et «fin», est affiché.
Si la condition est vraie, le bloc est exécuté de nouveau et nous remontons à la condition de nouveau.

Et ainsi de suite tant que la condition est vraie, ce qui pourrait s'écrire :

`while (la-condition-est-vraie) { fait-quelque-chose }`

## La boucle infinie

Dans le code ci-dessus, nous avons toujours décrémenté la variable, donc nous savions qu'à un moment donné la condition deviendrait fausse.
Si pour une raison quelconque la condition ne devient jamais fausse, vous obtenez une boucle infinie.
Votre programme sera coincé dans le bloc de code de la boucle duquel il ne peut jamais s'échapper.

Par exemple, cela se produirait si nous avions oublié de décrémenter la variable $compteur, ou 
si nous étions entrain de l'incrémenter bien qu'en vérifiant toujours une limite inférieure.

Si cela arrive par erreur, c'est un bug.

Sinon, dans le cas contraire, si cela arrive <b>en connaissance de cause</b>, c'est pour utiliser une boucle infinie qui rend notre programme plus simple à écrire et plus facile à lire. Nous aimons le code lisible !
Si nous tenons à avoir une boucle infinie, nous pouvons utiliser une condition qui est toujours vraie.

Ainsi, nous pouvons écrire :

```perl
while (42) {
  # ici nous faisons quelque chose
}
```

Bien sûr, les gens qui n'ont pas [la référence culturelle appropriée](http://fr.wikipedia.org/wiki/La_grande_question_sur_la_vie,_l'univers_et_le_reste#La_recherche_de_la_r.C3.A9ponse_ultime) vont se demander pourquoi 42. Ainsi, la condition - pour obtenir une boucle infinie - la plus généralement acceptée,
mais bien plus ennuyeuse, est le nombre 1.

```perl
while (1) {
  # ici nous faisons quelque chose
}
```

Naturellement, étant donné que le code ne peut pas sortir de cette boucle,
nous pouvons nous demander comment ce programme peut finir sans l'interrompre de l'extérieur.

Pour cela, il y a plusieurs possibilités qui s'offrent à nous.

L'une d'elles est d'utiliser, à l'intérieur de cette boucle `while`, le mot-clé `last` qui est une instruction complète à lui tout seul.
Cette utilisation va forcer à passer outre le reste du bloc et à ne pas vérifier la condition, mettant ainsi fin à la boucle.
Habituellement, une condition doit être vérifiée pour l'utiliser.

```perl
use strict;
use warnings;
use 5.010;

while (1) {
  print "Quel langage de programmation êtes-vous entrain d'apprendre à l'instant même ? ";
  my $nom = <STDIN>;
  chomp $nom;
  if ($nom eq 'Perl') {
    last;
  }
  say 'À côté de la plaque ! Essayez de nouveau !';
}
say 'Bien !';
```

Dans cet exemple, nous posons une question à l'utilisateur et
nous espérons qu'il sera en mesure de donner la bonne réponse.
Il sera coincé avec cette question pour toujours s'il ne tape pas «Perl».

Alors, la conversation pourrait ressembler à cela :

```
Quel langage de programmation êtes-vous entrain d'apprendre à l'instant même ? Java
À côté de la plaque ! Essayez de nouveau !
Quel langage de programmation êtes-vous entrain d'apprendre à l'instant même ? PHP
À côté de la plaque ! Essayez de nouveau !
Quel langage de programmation êtes-vous entrain d'apprendre à l'instant même ? Perl
Bien !
```

Comme vous pouvez le voir, une fois que l'utilisateur a tapé la bonne réponse,
`last` est appelé, et donc le reste du bloc affichant «À côté de la plaque ! Essayez de nouveau !»
a été ignoré et l'exécution s'est poursuivie après la boucle `while`.

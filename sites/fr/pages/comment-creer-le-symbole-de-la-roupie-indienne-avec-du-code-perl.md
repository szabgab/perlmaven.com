---
title: "Comment créer le symbole de la roupie indienne avec du code Perl ?"
timestamp: 2013-04-19T10:30:04
tags:
  - binmode
  - Unicode
  - UTF8
published: true
original: how-to-create-an-indian-rupee-symbol-with-perl-code
books:
  - beginner
author: szabgab
translator: oval
---


Récemment, j'ai reçu un courriel d'un des mes lecteurs me demandant comment créer le symbole de la roupie indienne avec Perl.
Je lui ai répondu de vérifier <b>quel caractère unicode est utilisé pour le symbole "roupie indienne"</b> et finalement de vérifier comment afficher les caractères Unicode avec Perl</b>.

Comme cela pourrait intéressé d'autres personnes, laissez-moi vous montrer ci-dessous comment procéder !


La première recherche m'a mené à la page wikipedia décrivant [le symbole de la roupie indienne](http://fr.wikipedia.org/wiki/Symbole_de_la_roupie_indienne).

apparemment, il y a :
* un <b>symbole générique pour la roupie</b> : U+20A8 `&#8360;`
* un <b>symbole spécifique pour la roupie indienne</b> : U+20B9 `&#8377;`

Si vous voulez afficher un caractère Unicode à l'écran (via la sortie standard ou STDOUT), alors vous aurez besoin de préciser à Perl de changer l'encodage de STDOUT à UTF8. Vous pouvez faire cela avec la fonction prédéfinie `binmode`.
consultez le document intitulé [introduction à Unicode avec Perl (EN)](http://perldoc.perl.org/perluniintro.html) pour de plus amples détails !

Pour des codes points spécifiques, vous devrez utiliser le signe `\x` suivi d'une valeur hexadécimale, le tout entre accolade. Dans le cadre de cet exemple, ces symboles sont 20A8 et 20B9 respectivement.

```perl
use strict;
use warnings;
use 5.010;

binmode(STDOUT, ":utf8");

say "\x{20A8}"; # &#8360;
say "\x{20B9}"; # &#8377;
```

Bien sûr, si vous écrivez une page HTML, vous feriez mieux d'inclure l'entité HTML représentant le même caractère qui est un signe & suivi du signe # lui-même suvi d'une représentation décimale du point de code suivi d'une point-virgule.
Pour convertir une valeur depuis la base heaxdécimale vers la base décimale, vous pouvez procéder comme ci-dessous en Perl :

```perl
print 0x20A8, "\n";  # 8360
print 0x20B9, "\n";  # 8377
```

Ainsi, en HTML, vous inclureriez `&amp;#8360;` and `&amp;#8377;` respectivement.

perl 5.14.2 a été utilisé sous Linux pour tester les exemples ci-dessus. Des versions ultérieures ne pourraient pas fonctionner.


---
title: "Quelles sont les nouveautés sous Perl 5.10 ? say, //, state"
timestamp: 2013-06-08T05:45:56
tags:
  - v5.10
  - 5.010
  - say
  - //
  - défini-ou
  - defined or
  - state
published: true
original: what-is-new-in-perl-5.10--say-defined-or-state
author: szabgab
translator: oval
---


Ce n'est plus vraiment d'actualité : Perl 5.10 a été livré le 18 Décembre 2007, jour du 20e anniversaire de Perl.
Beaucoup de gens ont écrit des articles à ce sujet. Il existe plusieurs présentations en ligne disponibles.
Par exemple, voir la discussion sur [PerlMonks (EN)](http://perlmonks.org/?node_id=654042) qui énumère plusieurs bons liens.

Néanmoins, j'écris cet article sur ce sujet, car de nombreuses entreprises adoptent tardivement les changements, et veulent voir d'abord comment Perl 5.10 ou une version ultérieure peut améliorer leur vie.

(La version originale de cet article a été publiée le 24 décembre 2007 sur szabgab.com).


Il y a beaucoup de nouvelles fonctionnalités. Commençons parmi les plus simples !

## La fonction prédéfinie say

Il y a une nouvelle <b>fonction prédéfinie `say`</b>.
Elle est identique à `print`, à part ajouter automatiquement un saut de ligne <b>"\n"</b> juste après la chaîne de caractères à afficher, et ce pour chaque appel.
Cela ne semble pas un gros problème et cela n'est pas en effet énorme,
mais néanmoins cela fait gagner beaucoup de temps d'écriture, en particulier dans le code de débogage.
Nous tapons tant de fois :

```perl
print "$var\n";
```

alors que maintenant, nous tapons juste :

```perl
say $var;
```

Vous ne devriez pas vous inquiéter au sujet de nouvelles fonctions surgissant dans l'ancien code.
En effet, la nouvelle fonction n'est disponible que si vous la demandez expressément en écrivant :

```perl
use feature qw(say);
```

ou si vous forcez 5.10 comme étant la version minimale pour laquelle votre code peut fonctionner :

```perl
use 5.010;
```

## L'opérateur défini-ou //

Une autre aide pratique est le nouvel <b>opérateur défini-ou, codé `//`</b>.
Il est presque le même que le bon vieil <b>opérateur ou, codé ||</b>, mais sans le bogue "0 n'est pas une valeur réelle".

Auparavant, quand nous voulions donner une <b>valeur par défaut</b> à un scalaire, nous devions écrire :

```perl
$x = defined $x ? $x : $DEFAUT;
```

ce qui est vraiment long, et nous avions donc l'envie d'écrire :

```perl
$x ||= $DEFAUT;
```

Mais alors 0, "0" ou la chaîne vide ne sont pas acceptées comme des valeurs valides.
Ils sont alors remplacés par la valeur de $DEFAUT. Bien que correct dans certains cas, cela crée un bogue dans d'autres cas.

Le nouvel opérateur défini-ou peut résoudre ce problème, car il ne retournera la valeur de droite uniquement que si la valeur de gauche est `undef`.
Ainsi, nous pouvons écrire la valorisation sous une forme <b>courte et correcte</b> :

```perl
$x //= $DEFAULT;
```

## Le mot-clé state

La troisième nouveauté explicitée dans cet article est le nouveau <b>mot-clé `slate`</b>.

Elle est aussi facultative et est inclus uniquement si vous écrivez :

```perl
use feature qw(state);
```

ou :

```perl
use 5.010;
```

Lorsqu'il est utilisé, il est semblable à `my`, mais il ne crée et n'initialise la variable qu'une seule fois.
C'est la même chose que la variable statique en C. Auparavant, nous devions écrire quelque chose comme ceci :

```perl
{
   my $compteur = 0;
   sub  {
      $compteur++;
      return $compteur;
   }
}
```

ce qui nécessite toujours beaucoup d'explications pourquoi `$compteur` est mis à 0 une seule fois et
comment il peut toujours retourner un nombre plus élevé.
Le bloc anonyme est également peu clair en première lecture.

Maintenant, vous pouvez écrire ceci :

```perl
sub compteur_au_suivant {
   state $compteur = 0;
   $compteur++;
   return $compteur;
}
```

ce qui est plus clair.

Pour un autre cas d'utilisation du mot-clé `state`, allez lire la section "Comment éviter d'afficher les répétitions des avertissements de Perl ?" dans l'article [Comment capturer et sauver des avertissements en Perl ? (EN)](https://perlmaven.com/how-to-capture-and-save-warnings-in-perl).

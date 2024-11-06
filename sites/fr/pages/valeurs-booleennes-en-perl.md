---
title: "Les valeurs booléennes en Perl"
timestamp: 2013-04-25T11:45:56
tags:
  - undef
  - true
  - false
  - booléen
published: true
original: boolean-values-in-perl
books:
  - livre_debutant
author: szabgab
translator: oval
---


Perl ne possède pas un type booléen dédié, et pourtant, dans la documentation de Perl, vous pouvez souvent voir qu'une fonction retourne une valeur "booléenne".
Parfois, la documentation dit que la fonction retourne vrai ou retourne faux.

Alors, quelle est la vérité ?


Perl n'a pas de type booléen dédié, mais chaque valeur scalaire - si elle est vérifiée sous <b>if</b> - sera vraie ou fausse. Vous pouvez donc écrire :

```perl
if ($x eq "foo") {
}
```

et vous pouvez également écrire :

```perl
if ($x) {
}
```

Le premier fragment de code va vérifier si le contenu de la variable <b>$x</b> est le même que la chaîne de caractères "foo"
tandis que le second va vérifier si $x elle-même est vraie ou non.

## Quelles sont les valeurs vraies et fausses en Perl ?

La réponse est assez facile. Permettez-moi de citer la documentation :

<pre>
Le nombre 0, les chaînes de caractères '0' et '', la liste vide "()", et undef
sont tous faux dans un contexte booléen. Toutes les autres valeurs sont vraies.
La négation d'une valeur vraie par "!" ou "not" renvoie une valeur fausse spéciale.
Lorsqu'elle est évaluée comme une chaîne de caractères, elle est traitée comme '',
mais, évaluée comme un nombre, elle est traité comme 0.

Tiré de "perlsyn" sous la rubrique «Vérités et Mensonges".
</pre>

Ainsi, les valeurs scalaires suivantes sont considérées comme fausses :

* undef - la valeur indéfinie
* 0 - le nombre 0, même si vous l'écrivez 000 ou 0.0
* '' - la chaîne vide
* '0' - la chaîne qui contient un seul zéro

Toutes les autres valeurs scalaires, incluant les suivantes, sont vraies :

* 1 - tout nombre non nul
* ' ' - la chaîne avec seulement un espace
* '00' - la chaîne contenant au moins deux zéros
* "0\n" - un zéro suivi d'un retour
* 'true'
* 'false' - oui, même la chaîne 'false' est évaluée à vrai

Je pense que c'est parce que [Larry Wall](http://www.wall.org/~larry/), créateur de Perl, a une vision générale positive du monde.
Il pense probablement qu'il y a très peu de mauvaises et fausses choses dans le monde. La plupart des choses sont vraies.


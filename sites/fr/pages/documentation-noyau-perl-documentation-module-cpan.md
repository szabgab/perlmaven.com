---
title: "Documentation du noyau Perl et documentation de module CPAN"
timestamp: 2014-07-23T09:57:56
tags:
  - perldoc
  - documentation
  - POD
  - CPAN
published: true
original: core-perl-documentation-cpan-module-documentation
books:
  - beginner
author: szabgab
translator: arhuman
---


Perl est fourni avec beaucoup de documentation, mais cela prend du temps
avant d'être habitué à l'utiliser. Dans cette partie du 
[tutoriel Perl](/perl-tutorial) je vais vous expliquer comment vous retrouver dans la documentation.


## perldoc sur le web

Le moyen le plus pratique d'accéder à la documentation du noyau perl est
de visiter le site web [perldoc](http://perldoc.perl.org/).

Il contient une version HTML de la documentation pour Perl, le langage et 
pour les modules disponibles avec le noyau Perl tels qu'ils sont livrés par
les mainteneurs de Perl 5.

Il ne contient pas la documentation des modules CPAN.
Il y a une redondance cependant, comme il y a certains modules qui sont 
disponibles à partir du CPAN mais qui sont aussi inclus dans la distribution
standard de Perl.
(Ils sont souvent cités comme "ayant une double vie" ou <b>dual-lifed</b>.)

Vous pouvez utiliser la boite de recherche dans le coin supérieur droit.
Par exemple, vous pouvez taper `split` et vous obtiendrez la documentation
de `split`.

Malheureusement elle ne sait pas quoi faire avec `while`, ni `$_` ou
`@_`. Pour avoir une explication de ceux là, vous devrez feuilleter la documentation.

La page la plus importante pourrait être [perlvar](http://perldoc.perl.org/perlvar.html),
où vous pourrez trouvez l'information sur les variables telles que `$_` and `@_`.

[perlsyn](http://perldoc.perl.org/perlsyn.html) explique la syntaxe de Perl incluant 
celle de la [boucle while](https://perlmaven.com/while-loop).

## perldoc en ligne de commande

La même documentation est livrée avec le code source de Perl, mais 
toutes les distributions Linux ne l'installent pas par défaut. Dans
certains cas il y a un paquet séparé. Par exemple avec Debian et Ubuntu
c'est le paquet <b>perl-doc</b>. Vous devez l'installer en exécutant
`sudo aptitude install perl-doc` avant de pouvoir utiliser `perldoc`.

Une fois que vous l'avez installé, vous pouvez taper `perldoc perl` sur la 
ligne de commande et vous aurez une explication et la liste des chapitres de la 
documentation de Perl.
Vous pouvez quitter en tappant la touche `q`, et ensuite taper le nom d'un
des chapitres.
Par exemple : `perldoc perlsyn`.

Cela marche à la fois sur Linux et Windows, même si le pager sous Windows est particulièrement
faible, c'est pourquoi je ne le recommande pas. Sous Linux c'est le lecteur habituel man donc
il devrait déjà vous être familier.

## Documentation des modules CPAN

Chaque module sur CPAN est fourni avec documentation et exemples.
La quantité et qualité de cette documentation et des exemples varient
grandement selon les auteurs, et même un seul auteur peut avoir des modules
bien documentés et d'autres très sous documentés.

Après que vous ayez installé un module appelé Module::Name, vous pouvez accéder à
sa documentation en tapant `perldoc Module::Name`.

Il y a un moyen plus pratique cependant, qui ne requiert même pas que le module soit
installé. Il y a plusieurs interfaces web au CPAN. Les principales sont [Meta CPAN](http://metacpan.org/)
et [search CPAN](http://search.cpan.org/).

Elles sont basées toutes les deux sur la même documentation, mais offrent une expérience légèrement différente.

## Recherche par mots clés sur Perl Maven

Une addition récente à ce site est la recherche par mots clés dans la barre de menu du haut.
Doucement vous trouverez une explication pour de plus en plus de parties de perl.
A un moment donné, une partie de la documentation du noyau de perl et de la documentation
des modules les plus importants de CPAN seront aussi inclus.

S'il vous manque quelque chose maintenant, faites juste un commentaire dessous,
avec les mots clés que vous cherchez et vous aurez une bonne chance d'avoir votre
demande complétée.

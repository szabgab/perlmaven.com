---
title: "Lequel est le meilleur : perl-CGI, mod_perl ou PSGI ?"
timestamp: 2013-04-25T22:45:56
tags:
  - CGI
  - mod_perl
  - FastCGI
  - PSGI
  - Plack
published: true
original: perl-cgi-mod-perl-psgi
author: szabgab
translator: oval
---


Je viens tout juste de voir une question demandant <b>quelle est la meilleure façon : perl-cgi ou mod-perl ?</b>
Je pourrais répondre brièvement : aucun des deux. En fait, utilisez un cadriciel web compatible PSGI, puis déployez-le autant que vous le souhaitez.


## Perl CGI

Il y a longtemps, très longtemps, dans une galaxie lointaine, très lointaine, nous utilisions CGI (acronyme de Common Gateway Interface) afin de créer des applications web. C'était bien : il résolvait tous les problèmes ... des années 90 du précédent millénaire. Mais aussi, il était lent.

Les gens voulurent une solution plus rapide. Ainsi apparut <b>mod_perl</b> : un module dans le serveur web Apache. Il était capable de choses extraordinaires, mais la plupart des gens l'utilisèrent comme un simple moteur turbo pour leurs applications CGI existantes. Il pouvait en effet augmenter la vitesse d'un site web d'un facteur 100, voire 200, par rapport à la solution pure CGI.

D'autres solutions s'en vinrent pour pallier la lenteur de CGI, comme par exemple <b>FastCGI</b>.

Tout cela était bon et permit de résoudre les problèmes des premières années du 21ème siècle, mais il était difficile de passer d'un système à l'autre.
Puis vint enfin l'ère moderne.

## PSGI et Plack

[Tatsuhiko Miyagawa](http://bulknews.typepad.com/) créa <a href="http://plackperl.org/">PSGI et
Plack</a>. Ce qui permit aux développeurs d'écrire leur code une et une seule fois, et de le déployer de nombreuses manières : CGI, mod_perl, FastCGI, nginx et Starman. Juste pour en nommer quelques-uns.

Cela libère un peu le développeur de logiciels du codage en dur lié au déploiement du code.

## Cadriciels

Bien sûr, presque personne n'écrit du code pur Plack/PSGI. Presque tout le monde utilise l'un des cadriciels Perl de développement d'applications web.

Les petites et moyennes applications reposent généralement soit sur [Perl Dancer](http://perldancer.org/),
soit sur [Mojolicious](http://mojolicious.org/). Les grandes applications reposent sur [Catalyst](http://www.catalystframework.org/).

Maintenant, j'ai "seulement" besoin d'écrire mes tutoriels pour tous ces cadriciels ...

(Ce message est en partie basé sur la réponse de [Dave Cross](http://perlhacks.com/). Merci !)

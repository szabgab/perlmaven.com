---
title: "Utiliser le débogueur intégré de Perl"
timestamp: 2013-04-19T10:30:11
tags:
  - debugger
  - -d
  - debug
  - screencast
published: true
original: using-the-built-in-debugger-of-perl
author: szabgab
translator: oval
---


La nouvelle vidéo d'écran montre comment [utiliser le débogueur intégré de Perl (EN)](http://www.youtube.com/watch?v=jiYZcV3khdY).
Je parle de ce sujet durant divers ateliers et conférences. Il y a toujours de nombreuses personnes qui n'ont jamais utilisé de débogueur.
J'espère que cela aidera à ce que plus de gens commencent à l'utiliser.


<iframe width="640" height="480" src="http://www.youtube.com/embed/jiYZcV3khdY" frameborder="0" allowfullscreen></iframe>

Lancer le débogueur :

perl -d yourscript.pl <param1> <param2> ...

Les commandes du débogueur mentionnées dans la vidéo sont :

q - quitter

h - afficher l'aide

p - afficher

s - aller dans

n - aller au-delà

r - sortir de

T - afficher la pile de traces

l - afficher le code


Je recommande aussi de lire le livre de Richard Foley et Andy Lester: [Pro Perl Debugging](http://www.apress.com/9781590594544).


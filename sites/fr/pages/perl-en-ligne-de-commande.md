---
title: "Perl en ligne de commande"
timestamp: 2013-06-08T14:45:56
tags:
  - -v
  - -e
  - -p
  - -i
published: true
original: perl-on-the-command-line
books:
  - beginner
author: szabgab
translator: oval
---


Alors que la plupart des articles du [tutoriel Perl](/perl-tutorial) utilisent des scripts enregistrés dans un fichier,
nous verrons également quelques exemples d'unilignes.

Même si vous utilisez [Padre](http://padre.perlide.org/) ou un autre EDI qui permet d'exécuter le script de l'éditeur lui-même,
il est très important de vous familiariser avec la ligne de commande (ou <i>shell</i>) et être en mesure d'y utiliser perl.


Si vous utilisez Linux, ouvrez une fenêtre de terminal :

vous devriez voir une invite, probablement se terminant par le signe $.

Si vous utilisez Windows, ouvrez une fenêtre de commande (en cliquant sur Démarrer -> Exécuter, puis en tapant "cmd" et ENTRÉE) :

vous verrez la fenêtre noire de CMD avec un message qui ressemble probablement à l'invite ci-dessous.

```
c:\>
```

## La version de Perl

Tapez `perl -v` et ENTRÉE, ce qui affiche un message similaire à celui ci-dessous :

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

À la lecture de ce message, je peux voir que j'ai la version 5.12.3 de Perl installée sur cette machine Windows.

## Afficher un nombre

Maintenant, tapez `perl-e "print 42"`, ce qui affiche le nombre 42 à l'écran.

Sous Windows, le nombre s'affiche sur la ligne suivante :

```
c:>perl -e "print 42"
42
c:>
```

Sous Linux, vous verrez quelque chose plutôt comme ceci :

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

Le résultat est en début de ligne, immédiatement suivi par l'invite.
Cette différence est due au différent dans le comportement des deux interpréteurs de ligne de commande.

Dans cet exemple, nous utilisons l'option `-e` indiquant à perl :
"Ne t'attend pas à un fichier ! La prochaine chose sur la ligne de commande est le code Perl à exécuter lui-même !"

Les exemples ci-dessus ne sont évidemment pas très intéressants.
Permettez-moi de vous en montrer un un peu plus complexe, sans l'expliquer en détail dans la section suivante !

## Remplacer Java par Perl

Cette commande `perl -i.bak -p -e "s/\bJava\b/Perl/" cv.txt` remplacera dans votre cv toutes les occurences du mot Java par le mot Perl  tout en gardant une copie de sauvegarde du fichier.

Sous Linux, vous pouvez même écrire `perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt` pour remplacer Java par Perl dans <b>tous</b> vos fichiers texte.

Dans un chapitre ultérieur, nous parlerons plus des unilignes et vous apprendrez comment les utiliser.
En bref, la connaissance des unilignes est une arme très puissante entre vos mains.

Au fait, si vous êtes intéressé par certains très bons unilignes, je vous recommande la lecture de
[Perl One-Liners explained (EN)](http://www.catonmat.net/blog/perl-book/) par Krumins Peteris.

## La suite

La suite est disponible dans <a href="https://perlmaven.com/core-perl-documentation-cpan-module-documentation">la documentation du noyau Perl et
la documentation des modules sous CPAN</a>.

---
title: "Comment supprimer, copier, ou renommer un fichier avec Perl ?"
timestamp: 2013-05-05T05:45:19
tags:
  - unlink
  - remove
  - rm
  - del
  - delete
  - copy
  - cp
  - rename
  - move
  - mv
  - File::Copy
published: true
original: how-to-remove-copy-or-rename-a-file-with-perl
books:
  - beginner
author: szabgab
translator: oval
---


Lors de l'écriture des scripts Perl, la plupart de ceux qui viennent du monde du système d'administration ou de celui de l'écriture de scripts Unix ou Linux vont essayer de continuer à utiliser les commandes Unix normales `rm`, `cp` et `mv` en les appelant soit entre les guillemets obliques inversés soit avec la fonction prédéfinie `system`.

Cette technique fonctionne sur la plateforme qu'ils utilisent, mais fait perdre l'un des principaux avantages que Perl a apporté au monde de l'administration du système Unix. Voyons comment nous pouvons exécuter ces opérations avec Perl d'une manière indépendante de la plateforme, et <b>sans passer par un programme shell</b>.


## Supprimer

Le nom de la fonction prédéfinie en Perl est `unlink`.

Cette fonction supprime un ou plusieurs fichiers du système de fichiers.
Elle est similaire à la commande `rm` sous Unix et à la commande `del` sous DOS/Windows.

```perl
unlink $fichier;
unlink @fichiers;
```

Elle utilise $_, la variable par défaut de Perl, si aucun paramètre n'est donné.

Pour une documentation complète, voir [perldoc -f unlink](http://perldoc.perl.org/functions/unlink.html).

## Renommer

Le nom de la fonction prédéfinie en Perl est `rename`.

Cette fonction renomme ou déplace un fichier.
Elle est similaire à la commande `mv` sous Unix et à la commande `rename` sous DOS/Windows.

```perl
rename $old_name, $new_name;
```

Comme cela ne fonctionne pas dans tous les systèmes de fichiers, la solution recommandée est la fonction `move` du module `File::Copy` :

```perl
use File::Copy qw(move);

move $old_name, $new_name;
```

Pour une documentation complète, voir : 

[perldoc -f rename](http://perldoc.perl.org/functions/rename.html).

[perldoc File::Copy](http://perldoc.perl.org/File/Copy.html).

## Copier

Il n'existe pas de fonction prédéfinie `copy` dans le noyau de perl.
La méthode standard pour copier un fichier est d'utiliser la fonction `copy` du module File::Copy.

Ceci est similaire à la commande `cp` sous Unix et à la commande `copy` de DOS/Windows.

```perl
use File::Copy qw(copy);

copy $old_file, $new_file;
```

Pour une documentation complète, voir [perldoc File::Copy](http://perldoc.perl.org/File/Copy.html).

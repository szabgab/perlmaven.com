---
title: "Tester les avertissements dans un module Perl"
timestamp: 2013-05-26T10:10:10
tags:
  - avertissements
  - warnings
  - __WARN__
  - Test::Warn
published: true
original: test-for-warnings-in-a-perl-module
author: szabgab
translator: oval
---


Il se peut que vous écriviez un module Perl qui - dans le cadre de son API - émette des avertissements dans certains cas.

Ce serait bien si nous pouvions nous assurer que cet avertissement ne disparaisse pas quand une tierce personne change le code plus tard afin de tenter de corriger un bug ou d'ajouter une fonctionnalité.

Probablement la meilleure façon de le faire est d'écrire un test qui vérifie si vous obtenez l'avertissement au bon moment.


Par exemple, votre module a une fonction analysant un fichier journal.
Que se passe-t-il quand une des lignes de ce fichier est incorrecte ?
Votre fonction générera-t-elle une exception ?
Ignorera-t-elle la ligne incorrecte en continuant silencieusement ?
Lancera-t-elle un avertissement avant de continuer ?

Peut-être une fonction est obsolète, et sans doute devrait-elle donner un avertissement quand elle est invoquée, mais dans le même temps encore fonctionner correctement.
Au moins jusqu'à ce qu'elle soit retirée.

Souhaitez-vous vous assurer que l'avertissement reste là ? Qu'il ne soit pas enlevé ou caché par erreur ou par quelqu'un qui ne savait pas que l'avertissement faisait partie de l'API ?

Comment pouvez-vous tester votre code pour vous assurer qu'il donne un avertissement au bon moment ?

## Le signal d'avertissement __WARN__

En Perl, tout appel à la fonction prédéfinie `warn` émet un signal interne. Vous pouvez configurer votre code de test pour [capturer et enregistrer des avertissements](https://perlmaven.com/how-to-capture-and-save-warnings-in-perl) en utilisant <b>$SIG{__WARN__}</b>, puis examiner si l'avertissement était le bon.

Quelque chose comme ceci :

```perl
{
  my @avertissements;

  local $SIG{__WARN__} = sub {
     push @avertissements, @_;
  };
  traiter_journal();
  is scalar(@avertissements), 1, 'exactement un avertissement';
  like $avertissements[0], qr{ligne invalide}, 'avertissement concernant une ligne invalide';
}
```

Que faire si nous souhaitons tester ceci pour plusieurs cas différents ?
Allons-nous devoir copier une partie de ce code encore et encore ?
Allons-nous créer notre propre fonction pour faire cela ?

## Test::Warn

Heureusement, Janek Schleicher l'a déjà fait quand il a créé le module [Test::Warn](https://metacpan.org/module/Test::Warn) qui est actuellement maintenu par [Alexandr Ciornii](http://chorny.net/).

Vous pouvez utiliser les fonctions pratiques fournies par ce module et vous n'avez pas besoin de réinventer la roue.

Grâce à ce module, le code ci-dessus serait réduit à :

```perl
warning_like { traiter_journal() } qr{ligne invalide}, 'avertissement concernant une ligne invalide';
```

Notez bien qu'il y a un bloc autour de l'appel de fonction et qu'il n'y a pas de virgule entre le bloc et l'expression régulière prévue.

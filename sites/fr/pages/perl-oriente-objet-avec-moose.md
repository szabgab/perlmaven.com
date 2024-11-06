---
title: "Perl orienté objet avec Moose"
timestamp: 2013-06-22T23:58:59
tags:
  - POO
  - orienté objet
  - classe
  - objet
  - instance
  - constructeur
  - accesseurs
  - modificateurs
  - mutateurs
  - attributs
  - Moose
published: true
original: object-oriented-perl-using-moose
books:
  - advanced
author: szabgab
translator: oval
---


Dans les prochains articles, nous allons apprendre comment écrire du code orienté objet en Perl.
Nous allons commencer par quelques exemples simples que nous étofferons pas à pas.
Nous commencerons à utiliser Moose, mais nous apprendrons aussi comment créer des classes par d'autres moyens.


## Un constructeur avec Moose

Commençons par écrire un script simple qui utilise la <b>classe</b> Personne.
Nous ne faisons rien de spécial encore : nous chargeons tout simplement le module qui
implémente cette classe et appelons le <b>constructeur</b> pour créer une <b>instance</b>.

```perl
use strict;
use warnings;
use v5.10;

use Personne;
my $enseignant = Personne->new();
```

Enregistrez ce code dans le fichier &lt;répertoire_de_base>/bin/app.pl !

Cela ne devrait pas être nouveau pour vous, car je suis sûr que vous avez déjà utilisé d'autres modules de la même façon.
Notre objectif est de savoir comment la classe Personne a été implémentée :

```perl
package Personne;
use Moose;

1;
```

Et ... c'est tout !

Ce code est enregistré dans &lt;répertoire_de_base>/lib/Personne.pm.
Notez que le nom de base du fichier - Personne (sans l'extension .pm) - et le nom du module - Personne, défini via le mot clé `package` - sont identiques !

Tout ce que vous devez faire pour implémenter une classe dans ce fichier est de :
* de créer un module (via le mot clé `package`) avec le nom de la classe
* d'ajouter `use Moose;`
* de fournir à la toute fin du fichier une valeur vraie
* d'enregistrer cette classe dans le fichier ayant le même nom (sensible à la casse !) que le module avec l'extension `.pm`.

Charger Moose active automatiquement `use strict` et `use warnings`.
C'est bien pratique, mais attention à ne pas trop vous habituer à cette commodité au point d'oublier de l'écrire dans du code non Moose.

Charger Moose ajoute également automatiquement un constructeur par défaut appelé `new`.

Notez que Perl n'exige pas de nommer le constructeur `new`, mais dans la plupart des cas, c'est ce que l'auteur choisit de toute façon.

## Attributs et accesseurs

Avoir une classe vide n'est pas très amusant. Allons plus loin dans l'utilisation :

```perl
use strict;
use warnings;
use v5.10;

use Personne;
my $teacher = Personne->new;

$enseignant->nom('Joe');
say $enseignant->nom;
```

Dans ce code, après la création de l'<b>objet</b>, nous appelons la méthode "nom" avec une chaîne comme paramètre,
ce qui valorise <b>l'attribut</b> "nom" de l'objet $enseignant avec la valeur «Joe».
Parce que cette méthode valorise l'attribut de même nom, elle est appelée un <b>modificateur</b>.

Ensuite, nous appelons la même méthode, mais cette fois sans aucun paramètre.
Cela va récupérer la valeur précédemment stockée. Parce que cette méthode récupère la valeur, elle est appelé un <b>accesseur</b>.

Dans notre cas, l'accesseur et le modificateur ont le même nom, mais ce n'est pas une obligation non plus.

En général, accesseurs et modificateurs sont regroupés dans le terme générique <b>mutateurs</b>.

L'implémentation de la nouvelle classe est la suivante :

The code implementing the new class is this:

```perl
package Personne;
use Moose;

has 'nom' => (is => 'rw');

1;
```

La nouvelle partie `has 'nom' => (is => 'rw');` dit :

"La classe Personne a - `has` - un attribut appelé `«nom»` qui est - `is` -
 accessible - <i>`r`eadable</i> - et modifiable <i>`w`ritable</i>".

Ceci crée automatiquement une méthode appelée "nom" qui est à la fois un modificateur (pour la modification) et un accesseur (pour l'accessibilité).

## Essayez le code !

Afin d'essayer cela :
* créez un répertoire nommé "repertoire_de_base"
* créez un sous-répertoire appelé "lib" dans "repertoire_de_base"
* enregistrez le fichier Personne.pm dans le sous-répertoire "lib"
* créez un sous-répertoire nommé "bin" dans "repertoire_de_base"
* enregistrez le script nommé person.pl dans le sous-répertoire "bin"

Vous devriez donc avoir :

```
repertoire_de_base/lib/Personne.pm
repertoire_de_base/bin/personne.pl
```

Ouvrez votre terminal (ou une fenêtre de commande sous Windows), placez-vous dans le répertoire "repertoire_de_base" et tapez `perl -Ilib bin/personne.pl`.
(Sous MS Windows, vous pourriez avoir besoin d'utiliser des barres obliques : \)

## Les paramètres du constructeur

Dans le script suivant, nous passons une paire clé-valeur au constructeur, correspondant au nom de l'attribut et à la valeur de cet attribut.

```perl
use strict;
use warnings;
use v5.10;

use Personne;

my $enseignant = Personne->new( nom => 'Joe' );
say $enseignant->nom;
```

Cela fonctionne aussi avec le même module comme nous avons déjà utilisé le constructeur pour définir la valeur initiale d'un attribut de cette façon, sans 
avoir à apporter de modifications au module Personne lui-même.

Moose accepte automatiquement tous les <b>membres</b> (autre nom pour les attributs) pour être passés lors de la construction.

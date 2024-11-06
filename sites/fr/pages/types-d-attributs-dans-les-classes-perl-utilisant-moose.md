---
title: "Les types d'attributs dans les classes Perl utilisant Moose"
timestamp: 2013-06-22T23:59:59
tags:
  - POO
  - orienté objet
  - classe
  - objet
  - instance
  - constructeur
  - accesseurs
  - modificateurs
  - attributs
published: true
original: attribute-types-in-perl-classes-when-using-moose
books:
  - advanced
author: szabgab
translator: oval
---


Dans un script Perl simple, nous n'avons pas l'habitude de beaucoup nous soucier au sujet des types de valeurs.
Mais dès lors que l'application grandit, un système de type peut aider à améliorer la cohérence de l'application.

Moose vous permet de définir un type pour chaque attribut, puis force les types via les modificateurs.


Après la première [introduction à Perl orienté objet avec Moose](https://perlmaven.com/object-oriented-perl-using-moose),
vous devriez vous familiariser avec le système de vérification de type de Moose.

## Définir le type Int

L'exemple ci-dessous nous montre comment utiliser la classe Personne écrite avec Moose :

```perl
use strict;
use warnings;
use v5.10;

use Personne;

my $etudiant = Personne->new( nom => 'Martin' );
$etudiant->annee(1988);
say $etudiant->annee; # 1988
$etudiant->annee('il y a 23 ans'); # erreur !
```

Après le chargement du module de Personne (la classe), nous créons l'objet $etudiant en appelant le constructeur de la classe, <i>new</i>.
Ensuite, nous appelons "annee" en mode modificateur afin de lui assigner la valeur 1988 passée en argument.
Après nous appelons "annee" en mode accesseur afin d'afficher sa valeur 1998.
Enfin, nous essayons de lui assigner la valeur "il y a 23 ans", ce qui provoquera une erreur (voir plus loin).

L'exemple ci-dessous nous montre comment écrirer la classe Personne avec Moose :

```perl
package Personne;
use Moose;

has 'nom' => (is => 'rw');
has 'annee' => (isa => 'Int', is => 'rw');

1;
```

Dans ce module, vous pouvez voir deux attributs: nom et annee. L'attribut "annee" a son option `isa` valorisée à `Int`.
Pour cette raison, le modificateur de Moose va restreindre pour cet attribut les valeurs acceptables à l'ensemble des nombres entiers.

Afin de voir les résultats des deux exemples ci-dessus, veuillez suivre les points suivants :
* Enregistrez le module "<répertoire_de_votre_choix>/lib/Personne.pm"
* Sauvegardez le script dans "<même_répertoire_de_votre_choix>/bin/app.pl"
* Puis, à partir du répertoire choisi dans les points précédents, exécutez le script avec "perl -Ilib bin/app.pl"

Le script va afficher la valeur 1988, suivie de l'erreur suivante :

```
Attribute (annee) does not pass the type constraint because:
   Validation failed for 'Int' with value "il y a 23 ans"
       at accessor Personne::annee (defined at lib/Personne.pm line 5) line 4
   Personne::annee('Personne=HASH(0x19a4120)', 'il y a 23 ans')
       called at bin/app.pl line 13
```

Ce message d'erreur indique que Moose n'a pas accepté la chaîne "il y a 23 ans" comme un entier.

## Définir un type de classe

Outre les [contraintes de type par défaut (EN)](https://metacpan.org/pod/Moose::Util::TypeConstraints#Default-Type-Constraints) (comme `Int`),
Moose vous permet également d'utiliser le nom d'une classe existante comme une contrainte de type.

Par exemple, vous pouvez déclarer que l'attribut "anniversaire" doit être un objet DateTime.

```perl
package Personne;
use Moose;

has 'nom' => (is => 'rw');
has 'anniversaire' => (isa => 'DateTime', is => 'rw');

1;
```

Essayez l'exemple de script ci-dessous :

```perl
use strict;
use warnings;
use v5.10;

use Personne;
use DateTime;

my $etudiant = Person->new( name => 'Joe' );
$etudiant->anniversaire( DateTime->new( year => 1988, month => 4, day => 17) );
say $etudiant->anniversaire;
$etudiant->anniversaire(1988);
```

Vous pouvez voir concernant les appels au modificateur de l'attribut "aniversaire" que :
* au premier appel, le modificateur reçoit un objet DateTime créé à la volée. Cet appel fonctionne bien.
* au deuxième appel, le modificateur reçoit le numéro 1988. Cet appel ne fonctionne pas.

Le premier appel ne provoque rien. L'attribut est bien valorisé, comme le montre l'affichage par `say`.

Le deuxième appel provoque une exception similaire à celle vue dans la section précédente de cet article :

```
Attribute (anniversaire) does not pass the type constraint because:
    Validation failed for 'DateTime' with value 1988
       at accessor Personne::anniversaire (defined at lib/Personne.pm line 5) line 4
    Person::birthday('Person=HASH(0x2143928)', 1988)
       called at bin/app.pl line 14
```

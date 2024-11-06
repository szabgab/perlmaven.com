---
title: "Tutoriel de Perl"
timestamp: 2013-04-15T00:00:20
description: "tutoriel en ligne gratuit sur Perl pour ceux qui ont besoin de maintenir du code Perl existant, pour ceux qui utilisent Perl pour des scripts simples, et pour ceux qui développent des applications en Perl"
types:
  - formation
  - cours
  - débutant
  - tutoriel
published: true
original: perl-tutorial
translator: oval
archive: false
---

<div class="main-content">
Remarque : La [version originale de ce tutoriel Perl](https://perlmaven.com) a été écrite en anglais par [Gabor Szabo](/about#auteur) qui a fait appel à des bénévoles pour traduire [ce tutoriel Perl dans d'autres langues](/about#traduction). Cette traduction - dans votre cas, en français - devrait vous permettre de vous concentrer sur l'apprentissage du langage Perl, en faisant abstraction de la barrière de la langue, et ainsi de reporter l'apprentissage de la langue anglaise à plus tard, mais pas ad vinam aeternam. Tôt ou tard, vous devrez, comme tout programmeur Perl - et en fait, comme tout programmeur de n'importe quel langage, apprendre au moins les rudiments de la langue anglaise afin de profiter de toute la documentation originale rédigée en anglais sur différents supports : livres, forums, bulletins en ligne d'informations, blogues, etc. Tout hyperlien qui est contenu dans un article écrit dans une langue et qui référence un autre article non encore traduit dans cette langue est redirigé vers la version anglaise de cet autre article.
</div>

Le tutoriel Perl Maven va vous apprendre les bases du langage de programmation Perl.
Vous serez en mesure d'écrire des scripts simples, d'analyser des fichiers journaux et de lire et écrire des fichiers CSV.
Cette liste est non exhaustive et ne nomme que quelques tâches courantes parmi tant d'autres.

Vous allez apprendre à utiliser l'archive CPAN et plusieurs modules CPAN spécifiques.

Ce sera une bonne base pour vous permettre d'aller de l'avant.

La version gratuite en ligne de ce tutoriel est actuellement en développement. De nombreux articles sont prêts. Des articles supplémentaires sont publiés régulièrement dans la langue originale.
Si vous êtes intéressé d'être mis au courant lorsque de nouveaux articles sont publiés, s'il vous plaît, veuillez vous [abonner au bulletin d'informations](/perl-maven-bulletin-d-informations).

Une [version numérique de cette documentation (EN)](https://perlmaven.com/beginner-perl-maven-e-book) existe aussi et est disponible à l'achat. En plus du tutoriel gratuit, cette version comprend également les diapositives du cours correspondant, y compris de nombreux exercices et leurs solutions. Le matériel du cours couvre toutes les parties, y compris celles qui ne sont pas encore reproduites dans la version gratuite.

La [vidéo du cours](https://perlmaven.com/beginner-perl-maven-video-course) comprend plus de 210 capture vidéos, sur un total de plus de 5 heures de vidéo. En plus de présenter le matériel, il fournit aussi des explications aux solutions de tous les exercices.
L'ensemble comprend également le code source de tous les exemples et les exercices.

## Le tutoriel en ligne gratuit Perl Maven pour débutant

Dans ce tutoriel, vous allez apprendre à utiliser le langage de programmation Perl 5 pour que le <b>travail soit fait</b>.

Vous apprendrez les caractéristiques générales du langage, ainsi que les extensions, les bibliothèques ou - comme les programmeurs Perl les appellent - les <b>modules</b>. Nous allons voir les modules standards qui sont intégrés avec Perl et les modules tierces qui sont installés sur <b>CPAN</b>.

Quand cela sera possible, j'essaierai d'enseigner de façon très orientée tâche. Je vais énumérer les tâches, puis nous allons apprendre les outils nécessaires pour les résoudre. Lorsque cela est possible, je vais aussi vous diriger vers quelques exercices que vous pourrez faire pour mettre en pratique ce que vous aurez appris.

## Table des matières

<b>Introduction</b>
<ol>
<li>[Installer Perl, afficher "Bonjour tout le monde", filet de sécurité (use strict; use warnings;)](https://perlmaven.com/installing-perl-and-getting-started) (EN)</li>
<li>[Éditeurs et EDIs, environnements de développement pour Perl](https://perlmaven.com/perl-editor) (EN)</li>
<li>[Perl en ligne de commande](/perl-en-ligne-de-commande)</li>
<li>[Documentation du noyau Perl et des modules CPAN](/documentation-noyau-perl-documentation-module-cpan) (EN)</li>
<li>[POD - Plain Old Documentation : la bonne vieille documentation à la Perl](https://perlmaven.com/pod-plain-old-documentation-of-perl) (EN)</li>
<li>[Déboguer des scripts Perl](/utiliser-le-debogueur-integre-de-perl)</li>
</ol>

<b>Les scalaires</b>
<ol>
<li>
    Avertissements et messages d'erreur courants :<br />
    <ul>
    <li>[Global symbol requires explicit package name](https://perlmaven.com/global-symbol-requires-explicit-package-name) (EN)</li>
    <li>[Use of uninitialized value](https://perlmaven.com/use-of-uninitialized-value) (EN)</li>
    <li>[Bareword not allowed while "strict subs" in use](/barewords-en-perl)</li>
    <li>[Name "main::x" used only once: possible typo at ...](https://perlmaven.com/name-used-only-once-possible-typo) (EN)</li>
    <li>[Unknown warnings category](/categorie-inconnue-d-avertissements)</li>
    <li>[Scalar found where operator expected](https://perlmaven.com/scalar-found-where-operator-expected) (EN)</li>
    </ul>
</li>
<li>[Conversion automatique d'une chaîne de caractères en nombre](https://perlmaven.com/automatic-value-conversion-or-casting-in-perl) (EN)</li>
<li>Les instructions conditionnelles: if</li>
<li>[Valeurs booléennes (vrai et faux) en Perl](/valeurs-booleennes-en-perl)</li>
<li>Opérateurs sur nombres et chaînes de caractères</li>
<li>[La valeur initiale undef et la fonction pré-définie defined](https://perlmaven.com/undef-and-defined-in-perl) (EN)</li>
<li>Les documents heredoc</li>
<li>[Les fonctions prédéfinies pour les chaînes de caractères : length, lc, uc, index, substr](https://perlmaven.com/string-functions-length-lc-uc-index-substr) (EN)</li>
<li>[Jeu "Devine le nombre" (rand, int)](/jeu-devine-un-nombre)</li>
<li>[La boucle while en Perl](/la-boucle-while-en-perl)</li>
</ol>

<b>Les fichiers</b>
<ol>
<li>die, warn et exit</li>
<li>[Écrire dans des fichiers](https://perlmaven.com/writing-to-files-with-perl) (EN)</li>
<li>[Ajouter en fin de fichiers](/ajouter-en-fin-de-fichiers)</li>
<li>[Ouvrir et lire des fichiers avec Perl](https://perlmaven.com/open-and-read-from-files) (EN)</li>
<li>[N'ouvrez pas de fichiers à l'ancienne!](https://perlmaven.com/open-files-in-the-old-way) (EN)</li>
<li>Le mode binaire, avec Unicode</li>
<li>Lire un fichier binaire : read, eof</li>
<li>dire, chercher</li>
<li>tronquer</li>
</ol>

<b>Les listes et les tableaux</b>
<ol>
<li>La boucle foreach en Perl</li>
<li>[La boucle for en Perl](/la-boucle-for-en-perl)</li>
<li>Les listes en Perl</li>
<li>Utiliser des modules</li>
<li>[Les tableaux en Perl](/les-tableaux-en-perl)</li>
<li>Traiter les paramètres de la ligne de commande : @ARGV et Getopt::Long</li>
<li>[Comment lire et traiter un fichier CSV ? split, Text::CSV_XS](https://perlmaven.com/how-to-read-a-csv-file-using-perl) (EN)</li>
<li>[La fonction prédéfinie join](/la-fonction-predefinie-join)</li>
<li>[L'année 19100 (time, localtime, gmtime)](https://perlmaven.com/the-year-19100) (EN) et introduction au contexte</li>
<li>[Sensibilité au contexte en Perl](https://perlmaven.com/scalar-and-list-context-in-perl) (EN)</li>
<li>[Trier des tableaux en Perl](https://perlmaven.com/sorting-arrays-in-perl) (EN)</li>
<li>[Valeurs uniques dans un tableau Perl](https://perlmaven.com/unique-values-in-an-array-in-perl) (EN)</li>
<li>[Manipuler des tableaux en Perl : shift, unshift, push, pop](/manipuler-des-tableaux-avec-perl)</li>
<li>La pile et la file d'attente</li>
<li>La fonction prédéfinie reverse</li>
<li>L'opérateur ternaire</li>
<li>Les commandes de boucles : next et last</li>
<li>min, max, sum avec List::Util</li>
</ol>

<b>Les fonctions</b>
<ol>
<li>[Les fonctions en Perl](https://perlmaven.com/subroutines-and-functions-in-perl) (EN)</li>
<li>Passer et vérifier des paramètres de fonctions</li>
<li>Nombre variable de paramètres</li>
<li>Renvoyer une liste</li>
<li>fonctions récursives</li>
</ol>

<b>Les tables de hachage</b>
<ol>
<li>[Les tables de hachages en Perl](https://perlmaven.com/perl-hashes) : dictionnaire, tableau associatif, table de conversion (EN)</li>
<li>Vérifier l'existence d'une clé : exists ; Supprimer des éléments de la table de hachage : delete</li>
</ol>

<b>Les expressions régulières</b>
<ol>
<li>Les expressions régulières en Perl</li>
<li>Regex: classes de caractères</li>
<li>Regex: quantifieurs</li>
<li>Regex: quantifieurs possessifs et non avides</li>
<li>Regex: groupement et capture</li>
<li>Regex: ancres</li>
<li>Regex: options et modificateurs</li>
<li>Substitutions (rechercher et remplacer)</li>
<li>[Couper/Supprimer les espaces avant et après](https://perlmaven.com/trim) (EN)</li>
</ol>

<b>Fonctionnalités du système d'exploitation via Perl</b>
<ol>
<li>Les opérateurs -X de Perl</li>
<li>Les tubes avec Perl</li>
<li>Exécuter des programmes externes</li>
<li>Des commandes Unix : rm, mv, chmod, chown, cd, mkdir, rmdir, ln, ls, cp</li>
<li>[Comment supprimer, copier ou renommer un fichier avec Perl ?](/comment-supprimer-copier-ou-renommer-un-fichier-avec-perl)</li>
<li>Des commandes Windows/DOS : del, ren, dir</li>
<li>Filtrer des fichiers (via des motifs)</li>
<li>Les descripteurs de répertoire</li>
<li>Parcourir une arborescence de répertoires : find</li>
</ol>

<b>CPAN</b>
<ol>
<li>[Télécharger et installer Perl : Strawberry Perl ou compilation manuelle](https://perlmaven.com/download-and-install-perl) (EN)</li>
<li>Télécharger et installer Perl : Perlbrew</li>
<li>Localiser et évaluer des modules CPAN</li>
<li>Télécharger et installer des modules CPAN avec Perl</li>
<li>[Comment modifier @INC pour trouver des modules Perl dans un chemin non standard ?](https://perlmaven.com/how-to-change-inc-to-find-perl-modules-in-non-standard-locations) (EN)</li>
<li>Comment modifier @INC dans un répertoire relatif ?</li>
<li>local::lib</li>
</ol>

<b>Quelques exemples d'utilisation de Perl</b>
<ol>
<li><a href="/comment-remplacer-une-chaine-de-caracteres-dans-un-fichier-avec-perl">Comment remplacer une chaîne dans un fichier avec Perl ? (<i>slurp</i>)</a></li>
<li>Lire des fichiers Excel avec Perl</li>
<li>Créer des fichiers Excel avec Perl</li>
<li>Envoyer des courriels avec Perl</li>
<li>Les scripts CGI avec Perl</li>
<li>Web applications with Perl: PSGI</li>
<li>Analyser des fichiers XML</li>
<li>Lire et écrire des fichiers JSON</li>
<li>Accéder des bases de données avec Perl: DBI, DBD::SQLite, MySQL, PostgreSQL, ODBC</li>
<li>Accéder LDAP avec Perl</li>
</ol>

<b>Autre</b>
<ol>
<li>[splice pour trancher et découper les tableaux en Perl](https://perlmaven.com/splice-to-slice-and-dice-arrays-in-perl) (EN)</li>
<li>[Comment créer un module Perl pour la réutilisation du code ?](https://perlmaven.com/how-to-create-a-perl-module-for-code-reuse) (EN)</li>
<li>[Perl orienté objet avec Moose](https://perlmaven.com/object-oriented-perl-using-moose) (EN)</li>
<li>[Les types d'attributs dans les classes Perl avec Moose](/types-d-attributs-dans-les-classes-perl-utilisant-moose)</li>
</ol>

<hr />

Nous vous rappelons que tout ce matériel et plus encore est [disponible à l'achat](/products) sous forme de [livres numériques](/perl-livres) et de [vidéos](/perl-videos).


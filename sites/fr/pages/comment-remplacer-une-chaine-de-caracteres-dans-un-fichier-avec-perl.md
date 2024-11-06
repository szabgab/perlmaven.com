---
title: "Comment remplacer une chaîne de caractères dans un fichier avec Perl ?"
timestamp: 2013-06-08T13:10:10
tags:
  - ouvrir
  - fermer
  - remplacer
  - open
  - close
  - File::Slurp
  - read_file
  - write_file
  - slurp
  - $/
  - $INPUT_RECORD_SEPARATOR
published: true
original: how-to-replace-a-string-in-a-file-with-perl
books:
  - beginner
author: szabgab
translator: oval
---


Félicitations ! Votre jeune pousse vient tout juste d'être rachetée par une grande société.
Vous devez maintenant remplacer <b>Tous droits réservés, Ma Jeune Pousse</b> par <b>Tous droits réservés, La grande société</b> dans le fichier LISEZMOI.txt.


## Remplacer le contenu avec File::Slurp

Si vous pouvez installer [File::Slurp](https://metacpan.org/pod/File::Slurp) et
si le fichier n'est pas trop grand pour tenir dans la mémoire de votre ordinateur, alors ce qui suit peut être la solution :

```perl
use strict;
use warnings;

use File::Slurp qw(read_file write_file);

my $nom_de_fichier = 'LISEZMOI.txt';

my $donnees = read_file $nom_de_fichier, {binmode => ':utf8'};
$donnees =~ s/Tous droits réservés, Ma Jeune Pousse/Tous droits réservés, La grande société/g;
write_file $nom_de_fichier, {binmode => ':utf8'}, $donnees;
```

La fonction `read_file` de File::Slurp va lire le fichier entier dans une variable scalaire unique.
Cela suppose que le fichier ne soit pas trop grand.

Nous avons mis `binmode => ': utf8'` pour gérer correctement les caractères Unicode.
Ensuite, une substitution par expression régulière est utilisée avec le modificateur /g pour remplacer 
globalement toutes les occurrences de l'ancien texte par le nouveau texte.

Ensuite, nous sauvegardons le contenu dans le même fichier,
en utilisant encore `binmode => ':utf8'` pour gérer correctement les caractères Unicode.

## Remplacer le contenu avec du Perl pur

Si vous ne pouvez pas installer File::Slurp, vous pouvez mettre en œuvre une version limitée de ses fonctions.
Dans ce cas, la partie principale du code est presque pareille, sauf que nous ne transmettons pas les paramètres 
pour ouvrir le fichier en mode Unicode. Cela est déjà codé dans les fonctions elles-mêmes.
Vous pouvez voir comment cela se fait dans les appels à la fonction prédéfinie `open`.

```perl
use strict;
use warnings;

my $nom_de_fichier = 'LISEZMOI.txt';

my $donnees = lire_fichier($nom_de_fichier);
$donnees =~ s/Tous droits réservés, Ma Jeune Pousse/Tous droits réservés, La grande société/g;
ecrire_fichier($nom_de_fichier, $donnees);
exit;

sub lire_fichier {
    my ($nom_de_fichier) = @_;

    open my $entree, '<:encoding(UTF-8)', $nom_de_fichier or die "Impossible d'ouvrir '$nom_de_fichier' en lecture : $!";
    local $/ = undef;
    my $tout = <$entree>;
    close $entree;

    return $tout;
}

sub ecrire_fichier {
    my ($nom_de_fichier, $contenu) = @_;

    open my $sortie, '>:encoding(UTF-8)', $nom_de_fichier or die "Impossible d'ouvrir '$nom_de_fichier' en écriture : $!";
    print $sortie $contenu;
    close $sortie;

    return;
}
```

Dans la fonction `lire_fichier`, la variable $/ (aussi appelée $INPUT_RECORD_SEPARATOR) est "valorisée" à `undef`.
C'est ce qui est généralement considéré comme le <b>mode <i>slurp</i></b>. Cette variable indique à l'opérateur "lire-une-ligne" `&lt;&gt;` de Perl
de lire en une fois tout le contenu du fichier et de mettre ce contenu dans la variable scalaire située dans la partie gauche de l'assignation : `my $tout = &lt;$entree>;`. Nous avons même utilisé le mot-clé `local` lorsque nous avons valorisé `$/` : ainsi, cette valorisation disparaîtra une fois que
nous sortirons du bloc englobant - dans cet exemple, une fois que nous sortons de la fonction `lire_fichier`.

La fonction `ecrire_fichier` est beaucoup plus simple à lire. Elle est là seulement afin de rendre la partie principale du code similaire à la solution précédente.

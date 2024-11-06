---
title: "Calculer des soldes bancaires, deux pour le prix d'un : DBD::CSV"
timestamp: 2013-04-19T10:30:02
tags:
  - DBD::CSV
  - CSV
  - SQL
  - DBI
published: true
original: calculate-bank-balance-take-two-dbd-csv
author: dmcbride
translator: oval
---


<i>Ceci est un article du contributeur [Darin McBride](http://www.linkedin.com/pub/darin-mcbride/32/a53/184).
Darin est un développeur de logiciels au laboratoire canadien d'IBM et est l'auteur de [plusieurs modules Perl sur CPAN](https://www.metacpan.org/author/DMCBRIDE). Père de trois enfants, il essaie de déterminer comment `use more 'sleep';`. -- Gabor</i>

Après que Gabor a répondu à la question d'un utilisateur [Comment calculer les soldes bancaires en CSV](https://perlmaven.com/how-to-calculate-balance-of-bank-accounts-in-csv-file-using-perl), j'ai suggéré que cela était un exemple criant pour utiliser [DBD::CSV](https://metacpan.org/pod/DBD::CSV). Gabor m'a invité à synchroniser mes doigts avec ma bouche - pour ainsi dire - afin de m'expliquer plus en détails.


## Pourquoi DBD::CSV?

Presque à chaque fois que quelqu'un pose une question au sujet de CSV en Perl, ma première pensée est toujous la même : DBD::CSV. La raison en est double.

Premièrement, en accèdant à des fichiers CSV via DBD::CSV, vous apprenez alors et/ou utilisez deux compétences qui sont transposables à beaucoup plus de projets que celle employée avec de naïfs splits ou même que celle employée avec [Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS) : <b>DBI</b> and <b>SQL</b>. Cela signifie que votre champ de compétences augmentera d'une manière plus utile à votre carrière, mais, plus rapidement, vous aurez également un plus grand nombre de personnes à qui vous pourrez demander de l'aide. Par exemple, tous les administrateurs de base de données devraient être en mesure de vous aider concernant vos questions SQL, mais probablement moins cocnernant vos questions Perl.

Deuxièmement, utiliser DBD::CSV vous fait raisonner différemment sur vos données. Souvent, selon mon expérience, simplement traiter le fichier CSV comme s'il s'agissait d'une table dans une base de données relationnelle peut être suffisant pour avoir de soudaines intuitions de solutions plus simples, même si l'ordinateur va passer beaucoup plus de temps à les exécuter.

Et cerise sur le gâteau, une fois que vous vous rendez compte que vos données sont ... des données, la transition naturelle vers un autre système de base de données (SQLite, DB2, Oracle, ou quoi que ce soit à portée de main) devient naturel. Et puisque vous avez déjà écrit votre code avec DBD::CSV, la transition vers DBD::DB2 ou DBD::SQLite (les deux que j'utilise le plus, c'est vous qui voyez) devient plus simple.

## L'approche

Donc, au départ, nous allons commencer avec le fichier CSV original :

```
TranID,Date,NuCo,Type,Montant,ChequeNo,DDNo,Banque,Direction
13520,01-01-2011,5131342,Dr,5000,,,,
13524,01-01-2011,5131342,Dr,1000,,416123,SB,Ashoknagar
13538,08-01-2011,5131342,Cr,1620,19101,,,
13548,17-01-2011,5131342,Cr,3500,19102,,,
13519,01-01-2011,5522341,Dr,2000,14514,,SBM,Hampankatte
13523,01-01-2011,5522341,Cr,500,19121,,,
13529,02-01-2011,5522341,Dr,5000,13211,,SB,Ashoknagar
13539,09-01-2011,5522341,Cr,500,19122,,,
13541,10-01-2011,5522341,Cr,2000,19123,,,
```

Rien de nouveau jusqu'à présent. Je ne sais pas ce que tous ces champs représentent, mais la question était simple : <i>comment calculer et afficher le solde total de chaque compte à l'aide des tableaux de hachage en Perl sans l'aide de la fonction d'analyse ?</i> Ok, pas tout à fait simple, donc je vais aussi faire quelques ajustements. Je sens que Gabor a répondu à cette question de manière relativement précise, et même en allant plus loin en répondant à d'autres questions connexes. Donc, je vais aller dans une autre direction ici : <i>Comment calculer et afficher le solde total de chaque compte <del>à l'aide des tableaux de hachage</del> en Perl <del>sans l'aide de la fonction d'analyse</del></i> ?

Donc, il me semble que nous avons besoin d'additionner tous les débits (Dr) et tous les crédits (Cr), regroupés par le numéro de compte (NuCo). Cela ressemble plus ou moins à du SQL, alors peut-être une solution SQL serait-elle à propos ?

## Mise en place de DBI

Tout d'abord, nous avons besoin de faire un peu de mise en place. Cette configuration est nettement plus longue que toute autre solution utilisant Text::CSV_XS, mais comme je peux dès lors le copier-coller de projet en projet, ce n'est pas si mauvais. Et c'est la même configuration (pratiquement) que les autres pilotes DBI.

Comme toujours, le filet de sécurité :

```perl
use strict;
use warnings;
```

<p>(Ce qui m'a sauvé pas mal de douleur pendant l'élaboration de ce code.) Et puis la magie :</p>

```perl
use DBI;
```

Notez que nous n'avons pas chargé le pilote CSV, mais seulement [DBI](https://metacpan.org/pod/DBI). En résumé, DBI va charger DBD::CSV pour nous. Ceci est pratique car il y aura un seul endroit où nous devrons préciser quelle base de données dorsale nous utiliserons, ce qui signifie moins de changement s'il advient que nous désirions mettre à jour une base de données à part entière plus tard. Peu probable ici, mais, encore une fois, nous n'essayons pas simplement de calculer le solde d'un compte : nous apprenons DBI et SQL dans le cadre de cet article.

```perl
use File::Basename qw(dirname);
use File::Spec;

my $dbh = DBI->connect('dbi:CSV:', undef, undef,
             {
                 f_dir => File::Spec->rel2abs(dirname($0)),
                 f_ext => '.csv',
                 csv_eol => "\n",
                 RaiseError => 1,
             });
```

Ici, nous chargeons quelques modules qui rendent notre travail un peu plus facile et puis nous disons à DBI d'utiliser un CSV comme source de données dorsale. Comme les fichiers CSV n'ont besoin ni d'utilisateurs ni de mots de passe pour se connecter, nous les configurons à `undef`, mais ensuite nous passons quelques drapeaux supplémentaires. Certains de ces indicateurs vont au pilote CSV, mais `RaiseError` est un paramètre générique de DBI qui, si activé, indique à DBI de mourir de lui-même quand quelque chose va mal. C'est très bien pour le développement, car je ne rate rien. En production, cela peut être moins désirable, mais j'ai aussi lancé des applications en production avec `use warnings FATAL => 'all';`, donc je suis de toute évidence d'accord avec cela.

Les autres paramètres ont besoin d'un peu plus d'explication.

f_dir est le répertoire où DBD::CSV va chercher tous les fichiers CSV. Dans cet exemple, je précise que le répertoire est le même que celui du script. Si ce n'est pas votre cas, vous aurez besoin d'ajuster de manière appropriée. Dans [l'article original](https://perlmaven.com/how-to-calculate-balance-of-bank-accounts-in-csv-file-using-perl), Gabor a juste choisi le répertoire de travail courant, ce qui est aussi une approche valable.

f_ext est l'extension ajoutée au nom d'une table afin de déterminer le nom du fichier lié à cette table. Avec cette extension, essayer <i>SELECT ... FROM foo</i> signifie que DBD::CSV va lire le fichier foo.csv (dans le f_dir spécifié ci-dessus).

csv_eol indique à DBD::CSV quelle chaîne de caractères représente la fin de ligne. Je pense que le défaut est `\r\n`, mais comme je suis sous Linux, ce n'est pas approprié pour moi.

## Trouver le juste SQL

<p>Maintenant, nous pouvons enfin passer à la vraie question :</p>

```perl
my $sth = $dbh->prepare(q[
             SELECT
               NuCo,
               SUM(CASE WHEN Type = ? THEN Montant ELSE 0 - Montant DONE)
             FROM
               banquetran
             GROUP BY
               NuCo]);

$sth->execute('Dr');
my $res = $sth->fetchall_arrayref();

use Data::Dumper;
print Dumper $res;
```

Veuillez remarquer quelques points. La première instruction prépare le SQL que je suis sur le point d'exécuter. Dans des circonstances normales, ceci permet au pilote de la base de données de compiler le code SQL dans une sorte de format interne afin qu'il puisse être exécuté plusieurs fois plus rapidement. Cependant, je ne suis pas sûr si le pilote CSV fait une pré-compilation, mais au moins, il fait une validation. Et nous ne l'exécutons qu'une fois dans cet exemple. En général, cependant, c'est une bonne idée.

Le SQL utilise également une valeur de paramètre fictif. Il s'agit de s'assurer que les valeurs non valides ne passent pas au travers. Dans ce cas particulier, la valeur est aussi codéee en dur, et donc cela ne nous offre pas grand chose d'autre que prise de contact et expérience.

Le SQL lui-même est un peu plus compliqué. Nous disons au moteur SQL que nous voulons obtenir le numéro de compte (<b>NuCo</b>) et le total des <b>Montant</b>s de la table <b>banquetran</b> (dont f_ext ci-dessus indiquera à DBD::CSV de relier cette table avec le fichier banquetran.csv), mais lorsque Type est 'Dr', nous voulons compter <b>Montant</b> comme un montant positif, sinon le considérer comme un montant négatif. À ce stade, je ne suis pas sûr si le zéro est requis ici ou pas, mais d'abord nous allons obtenir quelque chose qui fonctionne, et ensuite nous pourrons l'ajuster. La clause <b>GROUP BY</b> indique au moteur SQL que nous voulons que la somme des montants soit appliquée par NuCo, i.e. chaque NuCo aura une somme indépendante des autres.

Il y a beaucoup plus à apprendre sur le SQL que ce que cet exemple peut montrer, mais comme mentionné précédemment, il y a beaucoup plus d'endroits pour apprendre SQL qu'il y en a pour apprendre Text::CSV_XS. Et vous pouvez utiliser ces ressources pour améliorer vos connaissances en SQL. De plus, étant un novice en SQL, je ne suis sans aucun doute pas la meilleure personne pour l'enseigner.

Après avoir compilé le code SQL, nous appelons ensuite `execute` qui exécute la requête SQL, puis `fetchall_arrayref` qui fait à peu près exactement ce qu'il dit : retourne toutes les lignes comme la seule référence à un tableau. Nous utilisons enfin Data::Dumper pour afficher quel type de données nous avons. donc nous savons quelles sont les étapes à prendre par la suite.

L'exécution de ce code donne le résultat suivant :

```perl
$ perl banquetran.pl
Bad table or column name: '=' has chars not alphanumeric or underscore!
   at /usr/lib64/perl5/vendor_perl/5.12.3/SQL/Statement.pm line 88
DBD::CSV::db prepare failed: Bad table or column name: '='
   has chars not alphanumeric or underscore!
   at /usr/lib64/perl5/vendor_perl/5.12.3/SQL/Statement.pm line 88
 [for Statement "
           SELECT
             NuCo,
             SUM(CASE WHEN Type = ? THEN Montant ELSE 0 - Montant DONE)
           FROM
             banquetran
           GROUP BY
             NuCo"] at banquetran.pl line 32.
DBD::CSV::db prepare failed: Bad table or column name: '='
   has chars not alphanumeric or underscore!
   at /usr/lib64/perl5/vendor_perl/5.12.3/SQL/Statement.pm line 88
 [for Statement "
             SELECT
               NuCo,
               SUM(CASE WHEN Type = ? THEN Montant ELSE 0 - Montant DONE)
             FROM
               banquetran
             GROUP BY
               NuCo"] at banquetran.pl line 32.
```

Oups! Il semble que SQL::Déclaration ne supporte pas la syntaxe <b>CASE</b>, ce que d'autres bases de données peuvent faire. Eh bien, cela signifie que nous devons faire un peu plus de travail en Perl pour compenser. Et si nous voulons passer à une autre base de données à l'avenir, nous pouvons toujours le noter afin que nous puissions y revenir. La solution que nous finirons par utiliser travaillera également avec les autres bases de données, bien sûr, mais peut-être pas aussi "pur" SQL. Et, en général, les autres bases de données ont en fait ce code en C et seront donc en mesure de faire ce que nous allons faire plus rapidement. En outre, en client / serveur de bases de données (où la base de données n'est pas sur la même machine que le code Perl qui demande des données), cela peut également réduire la quantité de trafic réseau. Si ces préoccupations sont de toute importance pour votre projet, bien sûr, cela dépendra de ce que vous avez comme contraintes.

## Nouvelle tentative avec SQL simple

Pour simplifier l'exemple SQL afin que SQL::Déclaration l'accepte, j'ai opté pour que <b>GROUP BY</b> s'applique à la fois à NuCo et à Type. Cela va me permettre de totaliser le champ <b>Montant</b> pour les débits et les crédits, par compte, et d'avoir seulement une soustraction de plus à faire plus tard.

```perl
my $sth = $dbh->prepare(q[
             SELECT
               NuCo,
               Type,
               SUM(Montant)
             FROM
               banquetran
             GROUP BY
               NuCo, Type]);

$sth->execute();
my $res = $sth->fetchall_arrayref({});

use Data::Dumper;
print Dumper($res);
```

Après avoir mis à jour le `prepare` défaillant comme indiqué ci-dessus, je reçois le résultat suivant:

```perl
$ perl banquetran.pl
$VAR1 = [
          {
            'Type' => 'Dr',
            'NuCo' => '5522341',
            'SUM' => 7000
          },
          {
            'Type' => 'Cr',
            'NuCo' => '5131342',
            'SUM' => 5120
          },
          {
            'Type' => 'Cr',
            'NuCo' => '5522341',
            'SUM' => 3000
          },
          {
            'Type' => 'Dr',
            'NuCo' => '5131342',
            'SUM' => 6000
          }
        ];
```

Maintenant, nous allons vers la bonne voie. Le total des débits de 5522341 est de 7000, celui des crédits de 5131342 est de 5120, etc.
Notez qu'il n'y aucun ordre logique dans le résultat. C'est parce que nous n'avons pas demandé au moteur SQL d'utiliser `ORDER BY` sur au moins un champ. Le résultat revient dans un ordre non prédéfini. Il faudrait préciser "ORDER BY NuCo, Type" pour le trier par numéro de compte et puis, au sein de chaque numéro de compte, par type (Cr < Dr, bien sûr).

Pour effectuer l'équivalent SUM(CASE...) de la première tentative, je commence par le remplissage du tableau de hachage avec ce qui précède :

```perl
# additionner débits et crédits
my %totaux;
for my $r (@$res)
{
    $totaux{$r->{NuCo}}{$r->{Type}} = $r->{SUM};
}
```

Les clés de premier niveau sont les numéros de compte et les clés de second niveau des types de transactions. Comme il n'existe, par définition en SQL, qu'une seule ligne pour chacune de ces paires, de part notre façon d'utiliser la clause GROUP BY, je n'ai pas besoin de me soucier d'avoir écrasé accidentellement quoi que ce soit ici.

## La sortie sous forme de tableau

Lors de l'affichage, je procède à la soustraction. Dans ce cas, je n'ai aucune idée de ce que le demandeur d'origine voulait vraiment, mais nous avons toutes les informations issues du fichier CSV que nous voulions, donc ce n'est vraiment pas si important que cela. J'ai choisi d'utiliser l'un de mes modules préférés : [Text::Table](https://metacpan.org/pod/Text::Table).

```perl
use Text::Table;
my $tb = Text::Table->new("Numéro\  de\ncompte", "Total\n\n (Rs)");

$tb->load(
          map {
              [ $_, $totaux{$_}{Dr} - $totaux{$_}{Cr} ]
          } sort keys %totaux
         );

print $tb;
```

Nous chargeons Text::Table, puis créons un objet de classe Text::Table. Son constructeur prend les en-têtes de colonnes à utiliser, ce que je fais donc. Le `load` peut être écrit un peu plus lisiblement, mais, encore une fois, le point principal se situe là où nous faisons la soustraction de Dr avec Cr.

Text::Table veut chaque ligne comme une référence de tableau, ce que nous faisons en les créant avec `map`.
Le dernier paramètre de `map` est la liste ordonnée (`sort`) des clés (`keys`) de %totaux (que nous avons obtenu à partir de la base de données sous le champ NuCo). Notez que ceci est, par défaut, un tri alphanumérique. Si vous souhaitez effectuer un tri numérique, vous aurez à l'indiquer à Perl.
Le premier paramètre de `map` permet de créer pour chaque élément de la liste indiquée précédemment un tableau anonyme dont la première colonne est la clé (NuCo) et la deuxième colonne est la soustraction de Dr avec Cr (le total que nous voulions dès le départ).
`map` retourne le tableau de tableaux anonymes (un pour chaque compte).

## La solution au complet

<p>Ainsi, en rassemblant le tout, nous obtenons :</p>

```perl
#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use File::Basename qw(dirname);
use File::Spec;

my $dbh = DBI->connect('dbi:CSV:', undef, undef,
              {
                  f_dir => File::Spec->rel2abs(dirname($0)),
                  f_ext => '.csv',
                  csv_eol => "\n",
                  RaiseError => 1,
              });

my $sth = $dbh->prepare(q[
               SELECT
                 NuCo,
                 Type,
                 SUM(Montant)
               FROM
                 banquetran
               GROUP BY
                 NuCo, Type]);

$sth->execute();
my $res = $sth->fetchall_arrayref();

# additionner débits et crédits
my %totaux;
for my $r (@$res)
{
    $totaux{$r->{NuCo}}{$r->{Type}} = $r->{SUM};
}

use Text::Table;
my $tb = Text::Table->new("Numéro\  de\ncompte", "Total\n\n (Rs)");

$tb->load(
          map {
              [ $_, $totaux{$_}{Dr} - $totaux{$_}{Cr} ]
          } sort keys %totaux
         );

print $tb;
```

<p>Et le résultat final :</p>

```
$ perl banquetran.pl
Numéro Total
  de
compte  (Rs)
5131342  880
5522341 4000
```


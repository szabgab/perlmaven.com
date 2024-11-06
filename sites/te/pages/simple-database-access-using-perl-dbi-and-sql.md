---
title: "Perl DBI మరియు SQL ని ఉపయోగించి డేటాబేస్ని access చెయ్యడం"
timestamp: 2013-05-25T04:04:56
tags:
  - SQL
  - DBI
  - DBD::SQLite
  - SELECT
  - fetchrow_array
  - fetchrow_hashref
published: true
original: simple-database-access-using-perl-dbi-and-sql
books:
  - beginner
author: szabgab
translator: balasatishreddykarri
---


ఈ ఆర్టికల్లో డేటాబేస్ కి ఎలా కనెక్ట్ అవ్వాలి?, డేటాబేస్ టేబుల్ ని create చెయ్యడం,డేటాని ఇన్సర్ట్ చెయ్యడం,అప్డేట్ చెయ్యడం మరియు వివిధ రకాలుగా సెలెక్ట్ చెయ్యడం తెలుసుకుందాం.Perl లో రేషనల్ డేటాబేస్లని access చెయ్యడానికి de-facto standard library
ఐన DBI or <b>Database independent interface for Perl</b> ని ఉపయోగిస్తాము. 


## Architecture
Perl స్క్రిప్ట్స్ DBI ద్వారా దానికి కావలసిన <b>Database Driver</b> కి కనెక్ట్ అవుతుంది . (e.g. [DBD::Oracle](https://metacpan.org/pod/DBD::Oracle)
for [Oracle](http://www.oracle.com/),
[DBD::Pg](https://metacpan.org/pod/DBD::Pg) for [PostgreSQL](http://www.postgresql.org/)
and [DBD::SQLite](https://metacpan.org/pod/DBD::SQLite) to access [SQLite](http://sqlite.org/)).
ఆ డ్రైవర్స్ డేటాబేస్ ఇంజిన్స్ యొక్క C క్లయింట్ లైబ్రరీస్ తో పాటు కంపైల్ అవుతాయి. అన్ని డేటాబేస్ ఇంజిన్స్ Perl అప్లికేషన్ తో ఎంబెడెడ్ చేయబడివుంటాయి.

[DBI](https://metacpan.org/pod/DBI) డాక్యుమెంటేషన్ తో వచ్చే ASCII-art ని ఇంప్రూవ్ చెయ్యడం కష్టం.ఇక్కడ దానిని వాడుకుందాం.

<pre>
             |<- Scope of DBI ->|
                  .-.   .--------------.   .-------------.
  .-------.       | |---| XYZ Driver   |---| XYZ Engine  |
  | Perl  |       | |   `--------------'   `-------------'
  | script|  |A|  |D|   .--------------.   .-------------.
  | using |--|P|--|B|---|Oracle Driver |---|Oracle Engine|
  | DBI   |  |I|  |I|   `--------------'   `-------------'
  | API   |       | |...
  |methods|       | |... Other drivers
  `-------'       | |...
                  `-'
</pre>

## Simple example
క్రింది ఉదాహరణ లో SQLite ని ఉపయోగిద్దాం. దీనిని మీరు మీ కంప్యూటర్ లో కూడా ట్రై చెయ్యొచ్చు. (e.g [DWIM Perl](http://dwimperl.com/) అన్ని వెర్షన్లు కావలసిన modules తో వస్తాయి.)

```perl
#!/usr/bin/perl
use strict;
use warnings;

use DBI;

my $dbfile = "sample.db";

my $dsn      = "dbi:SQLite:dbname=$dbfile";
my $user     = "";
my $password = "";
my $dbh = DBI->connect($dsn, $user, $password, {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
});

# ...

$dbh->disconnect;
```

ఇక్కడ మనము <b>DBI</b> ని లోడ్ చేసాము, కాని డేటాబేస్ డ్రైవర్ ని లోడ్ చెయ్యలేదు. DBI డేటాబేస్ డ్రైవర్ ని లోడ్ చేస్తుంది.

ఇక్కడ <b>DSN (Data Source Name)</b> (in the $dsn variable) డైరెక్ట్ గా వుంటుంది. దీనిలోనే డేటాబేస్ ఏ టైపో వుంటుంది.
దానివలన DBI కి ఏ DBD ని లోడ్ చేసుకోవాలో తెలుస్తుంది. SQLite లో డేటాబేస్ ఫైల్ పాత్ ఇస్తే సరిపోతుంది.

username మరియు password లు ఖాలీగా ఉంచుతాం. ప్రస్తుతం SQLite లో అవసరం లేదు.

కనెక్ట్ కాల్ లో వున్న చివరి పారామీటర్ ని తరువాత వాడుకోవడానికి కొన్ని attributes వున్న hash reference లా సెట్ చేద్దాం అనుకుంటున్నాను.

DBI->connect కాల్ <b>డేటాబేస్ హేండిల్ ఆబ్జెక్ట్ (database handle object)</b> ని రిటర్న్ చేస్తుంది. దానిని `$dbh` variable లో స్టోర్ చేస్తాం.

<b>disconnect</b> ని కాల్ చేయడం ఆప్షనల్, `$dbh` స్కోప్ అయిపోగానే ఇది ఆటోమేటిక్ గా కాల్ అవుతుంది.
దీనిని వాడడం వలన తరువాత ఈ ప్రోగ్రాం ఉపయోగించే వారికి ఇండికేషన్ కింద ఉపయోగించబడుతుంది.

## టేబుల్ని తయారుచేయడం (CREATE TABLE)

డేటాబేస్ కనెక్షన్ ఇస్తే సరిపోదు. మనం డేటాని డేటాబేస్ లో ఇన్సర్ట్ చెయ్యాలి లేదా డేటాబేస్ నుండి తీసుకోవాలి.
మన ఉదాహరణ పనిచెయ్యడానికి మనం డేటాబేస్ లో ఒక టేబుల్ తయారు చేద్దాం.

ఇక్కడ ఒక్క కంమండ్లోనే దీనిని చేద్దాం:

```perl
my $sql = <<'END_SQL';
CREATE TABLE people (
  id       INTEGER PRIMARY KEY,
  fname    VARCHAR(100),
  lname    VARCHAR(100),
  email    VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(20)
)
END_SQL

$dbh->do($sql);
```

మొదటి స్టేట్మెంట్ SQL స్టేట్మెంట్ ఐన CREATE TABLE కి [here document](/here-document) డేటాబేస్ హేండిల్ లో `do` మెథడ్ ని ఉపయోగించి SQL స్టేట్మెంట్ ని డేటాబేస్ లో పంపిస్తాము.

## ఇన్సర్ట్ (INSERT)

ఇప్పడు డేటాని ఎలా ఇన్సర్ట్ చెయ్యాలో చూద్దాం:

```perl
my $fname = 'Foo';
my $lname = 'Bar',
my $email = 'foo@bar.com';
$dbh->do('INSERT INTO people (fname, lname, email) VALUES (?, ?, ?)',
  undef,
  $fname, $lname, $email);
```

row ని ఇన్సర్ట్ చెయ్యడానికి మరలా `$dbh->do` మెథడ్ నే మళ్ళి వాడదాము, కానీ డేటాని డైరెక్ట్ గా పంపించకుండా <b>place-holders</b> కింద question-marks `?` ని వాడాము.

SQL స్టేట్మెంట్ లో `undef` ని వాడాము. hash-reference ప్లేస్ లో `undef` వాడడం వలన ఇది ఆ కాల్ కి parameters ని పంపిస్తుంది.`connect` method దగ్గర పంపించిన విధంగానే వుంటుంది,కాని దీనిని ఈ స్టేట్మెంట్స్ ని చాలా తక్కువ ఉపయోగిస్తాము అనుకుంటున్నాను.

`undef` తరువాత వున్న వాల్యూస్ place-holders లోకి తీసుకోబడతాయి.

పైన చూపిన విధంగా place-holders ని quotes మధ్యలో పెట్టము, అలాగే వాల్యూస్ ని మార్చవలసిన పని లేదు. మనకోసం DBI మొత్తం చేస్తుంది.

దీని వలన మనం [SQL injection](http://en.wikipedia.org/wiki/Sql_injection) దాడులు లేకుండా చెయ్యొచ్చు. [Bobby Tables](http://bobby-tables.com/) ని కూడా పాటిస్తుంది.

## అప్డేట్ (UPDATE)

డేటాని డేటాబేస్ లో అప్డేట్ చేయడానికి కూడా `do` method ని వాడవచ్చు.

```perl
my $password = 'hush hush';
my $id = 1;

$dbh->do('UPDATE people SET password = ? WHERE id = ?',
  undef,
  $password,
  $id);
```

ఇక్కడ కొత్తగా మనకి తెలియంది ఏమి లేదు. place-holders వున్న SQL స్టేట్మెంట్, extra attributes బదులు `undef`, మరియు place-holders ప్లేస్ లో parameters ని పాస్ చేసాము.

## సెలెక్ట్ (SELECT)

ఇది డేటాబేస్ వాడకంలో ఆసక్తికరమైన భాగం. సెలెక్ట్ (SELECT) స్టేట్మెంట్ చాలా రోలని(rows) ఇస్తుంది, ప్రతి రో(row) లో చాలా వాల్యూస్ వుంటాయి. ఇక్కడ `do` method ని వాడలేము.

చాలా రకాలుగా మనము డేటాని తీసుకోవచ్చు. ఇక్కడ మనం రెండింటిని చూద్దాం. రెండింటికి 3 స్టెప్స్ వున్నాయి.
SQL స్టేట్మెంట్ ని `ప్రిపేర్ (prepare)` చెయ్యడం,
డేటా తో స్టేట్మెంట్ ని `ఏక్సక్యూట్ (execute)` చెయ్యడం, మరియు
రోస్ ని `ఫేచ్ (fetch)` చెయ్యడం.

వీటి ద్వారా, `prepare` స్టేట్మెంట్ ఒకటే వ్రాసి వేరు వేరు డేటాని పంపించి వాడుకుంటాము. వాల్యూస్కి బదులుగా SQL స్టేట్మెంట్ లో question marks (`?`) ని వాడతాము.
ఈ కాల్ <b>స్టేట్మెంట్ హేండిల్ ఆబ్జెక్ట్ (statement handle object)</b> ని రిటర్న్ చేసి `$sth` variable లో సేవ్ చేస్తుంది.

తరువాత `execute` method కాల్ చెయ్యడం వలన <b>statement handle</b> ఈ వాల్యూస్ని place-holders ప్లేస్ లోకి పంపిస్తుంది.

3 వ స్టెప్ ఆసక్తికరంగా వుంటుంది. row-by row result ని <b>while loop</b> లో fetch చేసుకుంటాము. దీనికి కూడా మనము చాలా methods వాడవచ్చు:

`fetchrow_array` method result సెట్ లో వున్న తరువాత row వాల్యూస్ ని లిస్టు కింద return చేస్తుంది, దానిని మనం array కి అనుసంధానం చేస్తాము. 
query లో ఫీల్డ్స్ ఏ ఆర్డర్ లో వున్నాయో ఎలిమెంట్స్ కూడా అదే ఆర్డర్ లో వుంటాయి (ఇక్కడ fname, lname లాగ).

`fetchrow_hashref` method hash యొక్క reference ని రిటర్న్ చేస్తుంది. ఇక్కడ keys కింద డేటాబేస్ ఫీల్డ్స్(fields) నేమ్స్ వస్తాయి. 
వేరు వేరు డేటాబేస్లు, ఫీల్డ్స్ ని వేరు వేరు కేసుల్లో రిటర్న్ చేస్తున్నపుడు మనం డేటాబేస్ హాండ్లర్ filed నేమ్ ప్రతిసారి lower case లో ఉండేలాగా కన్ఫిగర్ చేస్తాము.( డేటాబేస్ కి కనెక్ట్ అవుతున్నపుడు పైన చెప్పుకున్న `FetchHashKeyName` parameter ఇదే చేస్తుంది).

```perl
my $sql = 'SELECT fname, lname FROM people WHERE id > ? AND id < ?';
my $sth = $dbh->prepare($sql);
$sth->execute(1, 10);
while (my @row = $sth->fetchrow_array) {
   print "fname: $row[0]  lname: $row[1]\n";
}

$sth->execute(12, 17);
while (my $row = $sth->fetchrow_hashref) {
   print "fname: $row->{fname}  lname: $row->{lname}\n";
}
```


## Exercise

పైన వున్న స్నిప్పెట్ కోడ్ లని తీసుకోండి.టేబుల్ని తయారుచేయడం (CREATE TABLE) కోడ్ ని ఉపయోగించి డేటాబేస్ ని సెటప్ చేసి టేబుల్ ని create చెయ్యండి.
ఇన్సర్ట్ (INSERT) కోడ్ ని ఉపయోగించి పీపుల్ డేటాని టేబుల్ లో ఇన్సర్ట్ చెయ్యండి.

చివరిగా ఆఖరి ఉదాహరణ ఉపయోగించి డేటాని extract చేసి, ప్రింట్ చెయ్యండి.

మీకు ఏమైనా అనుమానాలు వుంటే క్రింద అడగవచ్చు.

## Thanks
DB Access ని చాలా సులభమైన ఆర్టికల్ గా అందించినందుకు [గాబొర్ స్జాబో](https://plus.google.com/102810219707784087582) గారికి కృతజ్ఞతలు (Thanks to Gabor Szabo for providing DB Access article in simple way).


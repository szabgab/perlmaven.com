use strict;
use warnings;
use Data::Dumper qw(Dumper);
use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=:memory:");
$dbh->do("CREATE TABLE words (
   id     INTEGER PRIMARY KEY,
   word   VARCHAR(255)
)");

for my $word ("abc", "def") {
    $dbh->do("INSERT INTO words (word) VALUES (?)", undef, $word);
}

my $sth = $dbh->prepare("SELECT * from words");
$sth->execute;
while (my $h = $sth->fetchrow_hashref) {
    print Dumper $h;
}


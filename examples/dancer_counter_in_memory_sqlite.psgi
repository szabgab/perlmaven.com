#!/usr/bin/env perl
use Dancer2;
use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=:memory:");
$dbh->do("CREATE TABLE counter (
   cnt   INTEGER DEFAULT 0
)");
$dbh->do("INSERT INTO counter (cnt) VALUES (?)", undef, 0);

get '/' => sub {
    my $sth = $dbh->prepare("SELECT * from counter");
    $sth->execute;
    my ($counter) = $sth->fetchrow_array();
    $counter++;
    $dbh->do("UPDATE counter SET cnt=?", undef, $counter);

    return $counter;
};


dance;

use strict;
use warnings;
use DBI;

my $hostname = '127.0.0.1';
my $port = 3306;
my $database = 'test_db';
my $user = 'test_user';
my $password = 'test_password';
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
my $dbh = DBI->connect($dsn, $user, $password, {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
});

my $sql = q{
CREATE TABLE people (
   id   INTEGER PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(20)
);
};

$dbh->do($sql);
$dbh->do("INSERT INTO people (name) VALUES(?)", undef, "Foo");
$dbh->do("INSERT INTO people (name) VALUES(?)", undef, "Bar");

my $sth = $dbh->prepare("SELECT * FROM people");
$sth->execute;
while (my @row = $sth->fetchrow_array) {
   print "id: $row[0]  name: $row[1]\n";
}



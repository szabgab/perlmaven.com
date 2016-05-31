use strict;
use warnings;
use DBIx::Simple;
use Data::Dumper qw(Dumper);

my $dbfile = 'my.db';
unlink $dbfile;
my $db = DBIx::Simple->connect("dbi:SQLite:dbname=$dbfile", '', '', {
    RaiseError => 1,
    PrintError => 0,
    AutoCommit => 1,
});

$db->query(q{
    CREATE TABLE people (
        id       INTEGER  PRIMARY KEY,
        fname    VARCHAR(50),
        lname    VARCHAR(50)
    )
});

$db->query('INSERT INTO people (fname, lname) VALUES(?, ?)', 'Thomas', 'Edison');
$db->query('INSERT INTO people (fname, lname) VALUES(?, ?)', 'Samuel', 'Morse');
$db->query('INSERT INTO people (fname, lname) VALUES(?, ?)', 'James', 'Watt');

my @people = $db->query('SELECT * FROM people')->hashes;
print Dumper \@people;

=head1 output

$VAR1 = [
          {
            'fname' => 'Thomas',
            'lname' => 'Edison',
            'id' => 1
          },
          {
            'lname' => 'Morse',
            'fname' => 'Samuel',
            'id' => 2
          },
          {
            'fname' => 'James',
            'lname' => 'Watt',
            'id' => 3
          }
        ];

=cut


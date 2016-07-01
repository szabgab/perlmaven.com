use strict;
use warnings;
use Data::Dumper qw(Dumper);
use List::Util qw(first);

our $people;
do 'people.pl';


#print Dumper $people;
my $id = shift or die "Usage: $0 ID\n";

my ($p) = first { $id == $_->{id} } @$people;
print Dumper $p;


use strict;
use warnings;
use Data::Dumper;

my @names = ('foo', 'bar', "moo\nand\nmoose");
my $names_ref = \@names;

print Dumper $names_ref;

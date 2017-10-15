use strict;
use warnings;
use Data::Dumper;

my @names = ('foo', 'bar', "moo\nand\nmoose");

print Dumper \@names;

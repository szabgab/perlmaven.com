use strict;
use warnings;
use Data::Dumper qw(Dumper);

my @keys = ('one', 'two', 'three');
my @values = ('uno', 'dos', 'tres');

my %hash;

@hash{@keys} = @values;

print Dumper \%hash;



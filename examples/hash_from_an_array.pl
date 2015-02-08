use strict;
use warnings;
use Data::Dumper qw(Dumper);

my @fruits = qw(apple red orange orange grape purple);

my %color_of = @fruits;


print Dumper \@fruits;
print Dumper \%color_of;

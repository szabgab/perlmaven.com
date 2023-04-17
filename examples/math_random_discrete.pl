use strict;
use warnings;
use 5.010;

use Math::Random::Discrete;

my @items = qw(low mid high);
my @weights = (10, 100, 1000);

my $thing = Math::Random::Discrete->new(
    \@weights,
    \@items,
);
 
say $thing->rand;


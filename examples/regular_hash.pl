use strict;
use warnings;
use 5.010;

my %people = (first => 1, second => 2, third => 3);
$people{fourth} = 4;
$people{another} = 5;

for my $k (keys %people) {
    say $k;
}


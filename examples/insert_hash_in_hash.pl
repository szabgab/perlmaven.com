use strict;
use warnings;
use 5.010;
use Data::Dumper;

my %team_a = (
    Foo => 3,
    Bar => 7,
    Baz => 9,
);

my %team_b = (
    Moo => 10,
    Boo => 20,
    Foo => 30,
);


my %team_x = (%team_a, %team_b);

print Dumper \%team_x;




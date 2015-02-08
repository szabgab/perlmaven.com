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


$team_b{other} = \%team_a;

say Dumper \%team_b;
say Dumper \%team_a;
say '-------------';

$team_b{other}{Bar} = 700;

say Dumper \%team_b;
say Dumper \%team_a;

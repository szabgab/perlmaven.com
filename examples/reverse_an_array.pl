use strict;
use warnings;
use 5.010;

my @words = qw(Foo Bar Moo);
say join ' ', @words;

my @sdrow = reverse @words;
say join ' ', @sdrow;

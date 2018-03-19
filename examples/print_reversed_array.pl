use strict;
use warnings;
use 5.010;

my @words = qw(Foo Bar Moo);
for my $item (reverse @words) {
    say $item;
}


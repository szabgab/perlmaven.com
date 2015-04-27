use strict;
use warnings;
use 5.010;

use List::Util qw(unpairs);

my @pairs = (['foo', 3], ['bar', 5], ['moo', 7]);

my @data = unpairs @pairs;
foreach my $d (@data) {
    say $d;
}

use strict;
use warnings;
use 5.010;

my @words = qw(Foo Bar Moo);

my $i = @words - 1;
while ($i >= 0) {
    say $words[$i];
    $i--;
}



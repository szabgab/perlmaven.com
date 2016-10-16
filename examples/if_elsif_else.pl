use strict;
use warnings;
use 5.010;

my $num = rand();

if ($num > 0.7) {
    say "$num is larger than 0.7";
} elsif ($num > 0.4) {
    say "$num is larger than 0.4";
} else {
    say "$num is something else";
}


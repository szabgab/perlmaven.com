use strict;
use warnings;
use 5.010;

sub factorial {
    my ($n) = @_;
    return factorial($n-1)*$n;
    return 1 if $n == 0;
}

say factorial(6);


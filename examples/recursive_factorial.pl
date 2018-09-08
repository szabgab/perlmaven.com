use strict;
use warnings;
use 5.010;

sub factorial {
    my ($n) = @_;
    print("$n!\n");
    return 1 if $n == 0;
    return factorial($n-1)*$n;
}

say factorial(6);


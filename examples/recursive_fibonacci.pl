use strict;
use warnings;
use 5.010;

sub fibonacci {
    my ($n) = @_;
    print("f($n)\n");
    return 0 if $n == 0;
    return 1 if $n == 1;
    return fibonacci($n-1) + fibonacci($n-2);
}

say fibonacci(6);

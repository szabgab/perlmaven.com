use 5.010;
use strict;
use warnings;

sub fibonacci {
    my ($n) = @_;
    say "fibonacci($n)";
    return if $n == 1 or $n == 2;
    return fibonacci($n-1) + fibonacci($n-2);
}

say fibonacci(6);

use 5.010;
use strict;
use warnings;

sub fibonacci {
    my ($n) = @_;

    state %cache;
    say "fibonacci($n)";
    if (not exists $cache{$n}) {
        if ($n == 1 or $n == 2) {
            $cache{$n} = 1;
        } else {
            $cache{$n} = fibonacci($n-1) + fibonacci($n-2);
        }
    }
    return $cache{$n};
}

say fibonacci(6);

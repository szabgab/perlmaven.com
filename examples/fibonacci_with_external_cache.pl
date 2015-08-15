use 5.010;
use strict;
use warnings;

sub fibonacci {
    my ($n) = @_;

    state %cache;
    if (not exists $cache{$n}) {
        $cache{$n} = _fibonacci($n);
    }
    return $cache{$n};
}

sub _fibonacci {
    my ($n) = @_;
    say "fibonacci($n)";
    return 1 if $n == 1 or $n == 2;
    return fibonacci($n-1) + fibonacci($n-2);
}

say fibonacci(6);

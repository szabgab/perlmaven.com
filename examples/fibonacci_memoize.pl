use 5.010;
use strict;
use warnings;

use Memoize qw(memoize);

sub fibonacci {
    my ($n) = @_;
    say "fibonacci($n)";
    return 1 if $n == 1 or $n == 2;
    return fibonacci($n-1) + fibonacci($n-2);
}

memoize('fibonacci');

say fibonacci(6);

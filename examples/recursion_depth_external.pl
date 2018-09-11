use strict;
use warnings;
use 5.010;

sub fib {
    my ($n) = @_;

    say "$n ", depth();

    return 1 if $n == 1 or $n == 2;
    return fib($n-1) + fib($n-2);
}

sub depth {
    my $sub = (caller(1))[3];
    my $i = 1;
    while (1) {
       my $upper_sub = (caller($i))[3];
       last if not defined $upper_sub;
       last if $upper_sub ne $sub;
       $i++;
    }
    return $i-1;
}

say fib(6);

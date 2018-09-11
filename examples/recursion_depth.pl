use strict;
use warnings;
use 5.010;

sub fib {
    my ($n) = @_;

    my $i = 0;
    my $sub = (caller(0))[3];
    while (1) {
       my $upper_sub = (caller($i))[3];
       last if not defined $upper_sub;
       last if $upper_sub ne $sub;
       $i++;
    }
    say "$n $i";

    return 1 if $n == 1 or $n == 2;
    return fib($n-1) + fib($n-2);
}

say fib(6);

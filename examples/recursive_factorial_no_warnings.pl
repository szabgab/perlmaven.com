use strict;
use warnings;
no warnings 'recursion';
use 5.010;

sub factorial {
    my ($n) = @_;
    return 1 if $n == 0;
    return factorial($n-1)*$n;
}

say factorial(100);

my $c;
say $c;


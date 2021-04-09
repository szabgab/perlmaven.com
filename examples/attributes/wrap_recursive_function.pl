use strict;
use warnings;
use 5.010;
use base 'MyWrapper';

sub fibonacci :Wrap {
    my $n = shift;
    die 'Negative' if $n < 0;
    die 'Only whole numbers' if $n != int($n);
    return 1 if $n == 0 or $n == 1;
    return fibonacci($n-1) + fibonacci($n-2);
}

say fibonacci(4);


use strict;
use warnings;
use 5.010;
use base 'MyWrapper';

sub sum :Wrap {
    my $sum = 0;
    $sum += $_ for @_;
    return $sum;
}

say sum(2, 3);
say sum(-1, 1, 7);

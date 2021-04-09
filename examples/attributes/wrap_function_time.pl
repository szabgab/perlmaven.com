use strict;
use warnings;
use 5.010;
use Time::HiRes qw(time);
use base 'MyTimer';

sub sum :Timer {
    my $sum = 0;
    $sum += $_ for @_;
    return $sum;
}
say sum(2, 3);

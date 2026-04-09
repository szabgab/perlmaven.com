package MyMath;
use strict;
use warnings;

sub average {
    @_ or die "Missing parameters";
    #die "Missing parameters" if not @_;
    #if (0 == scalar @_) {
    #    die "Missing parameters";
    #}

    my $sum = 0;
    for my $val (@_) {
        $sum += $val;
    }
    return $sum / scalar @_;
}

1;


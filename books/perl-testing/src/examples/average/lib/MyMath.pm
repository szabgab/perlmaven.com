package MyMath;
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

sub average {
    #@_ or die "Missing parameters";
    #die "Missing parameters" if not @_;
    #if (0 == scalar @_) {
    #    die "Missing parameters";
    #}

    my $sum = 0;
    for my $val (@_) {
        #die "We can only average numbers. Found '$val'" if not looks_like_number($val);
        $sum += $val;
    }
    return $sum / scalar @_;
}

1;


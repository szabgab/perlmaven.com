package MyMod;
use strict;
use warnings;
use warnings::register;

sub f {
    my ($x, $y) = @_;

    if (@_ != 2) {
        if (warnings::enabled()) {
            warnings::warn("Function f() must be called with 2 parameters! Calleed");
        }
    }
    return 42;
}

1;


package MyModule;
use strict;
use warnings;

sub add {
    if (@_ < 2) {
       warn "Too few parameters";
       return;
    }
    if (@_ > 2) {
       warn "Too many parameters";
       return;
    }
    return $_[0] + $_[1];
}

sub other {
    warn "Some new warning" if $] >= 5.022000;
    return 42;
}

1;


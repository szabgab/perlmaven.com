use strict;
use warnings;

sub f {
    my ($txt) = @_;
    if ($txt = ~/(\d+)/) {
        print $1;
    }
}

f("abc def");
f("abc 123 def");


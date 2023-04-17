use strict;
use warnings;

sub f {
    my ($txt) = @_;
    if ($txt = ~/(\d+)/) {
        print $1;
    }
}

g();
f("abc def");
f("abc 123 def");


sub g {
    $_ = 'hello 42 world';
}

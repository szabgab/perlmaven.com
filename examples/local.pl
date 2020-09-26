use strict;
use warnings;
use 5.010;

our $x = 1;
my $y = 1;

say "x $x";
say "y $y";

{
    local $x = 2;
    my $y = 2;

    say "x $x";
    say "y $y";

    show_vars();
}

say "x $x";
say "y $y";

exit();

sub show_vars {
    say "x $x in show_vars";
    say "y $y in show_vars";
}



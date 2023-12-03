use strict;
use warnings;
use feature 'say';


sub function {
    my ($x, $y) = @_;

    if ($x < $y) {
        my $total = $x + $y;
    }
}

{
    my $res = function(2, 3);
    say defined $res ? "defined" : "undef";
    say $res eq "" ? "empty string" : "NOT the empty string";
    say $res;
    say "-------------------";
}
{
    my $res = function(3, 2);
    say defined $res;
    say $res eq "" ? "empty string" : "NOT the empty string";
    say $res;
    say "-------------------";
}

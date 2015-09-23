use 5.010;
use strict;
use warnings;

sub div {
    my ($x, $y) = @_;

    if ($y !=0 ) {
        return $x/$y;
    }
    return;
}

my $x = div(6, 2);
if (defined $x) {
    say "Success! The results is $x";
} else {
    say "Failure! We received undef";
}

my $y = div(42, 0);
if (defined $y) {
    say "Success! The results is $y";
} else {
    say "Failure! We received undef";
}


my @x_results = div(6, 2);
if (@x_results) {
    say "Success! We can divide 6 by 2";
} else {
    say "Failure!";
}

my @y_results = div(42, 0);
if (@y_results) {
    say "Success! We can divide 42 by 0";
} else {
    say "Failure!";
}



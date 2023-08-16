use strict;
use warnings;
use feature 'say';

function_without_warning();
function_with_warning();

my $q;
my $r;

say $q + $r;

sub function_without_warning {
    my $x = 2;
    my $y = 3;

    say $x + $y;
}

sub function_with_warning {
    my $x = 2;
    my $y;

    my $x = 3;
    say $x + $y;

}


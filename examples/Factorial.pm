package Factorial;
use strict;
use warnings;

$DB::single = 1;
print("Doing some stuff here\n");

sub factorial {
    my ($n) = @_;
    my $fact = 1;
    $fact *= $_ for 1..$n;
    return $fact;
}

print("Doing some other stuff here\n");

1;




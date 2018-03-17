use 5.010;
use strict;
use warnings;
use List::Util qw(min);

say min( 10, 3, -8, 21 ); # -8

my @prices = (17.2, 23.6, 5.50, 74, '10.3');

say min(@prices); # 5.5


# Argument "2x" isn't numeric in subroutine entry at examples/min.pl line 14.
say min( 10, 3, '2x',  21 ); # 2


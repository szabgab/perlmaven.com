use 5.010;
use strict;
use warnings;
use List::Util qw(sum0);

say sum0( 10, 3, -8, 21 ); # 26

my @prices = (17.2, 23.6, '1.1');

say sum0(@prices);  # 41.9

my @empty;
say sum0(@empty); # 0


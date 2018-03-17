use 5.010;
use strict;
use warnings;
use List::Util qw(sum);

say sum( 10, 3, -8, 21 ); # 26

my @prices = (17.2, 23.6, '1.1');

say sum(@prices);  # 41.9

my @empty;
# Use of uninitialized value in say at examples/sum.pl line 14.
say sum(@empty); # (prints nothing)

use strict;
use warnings;
use 5.010;

use List::Util qw(all any notall);

my @numbers = ( 1, 2, 3, 5, 3 );

say notall { $_ > 1 } @numbers;    # 1
say any { $_ <= 1 } @numbers;      # 1
say not all { $_ > 1 } @numbers;   # 1

say notall { $_ > 0 } @numbers;    #
say any { $_ <= 0 } @numbers;      #
say not all { $_ > 0 } @numbers;   #


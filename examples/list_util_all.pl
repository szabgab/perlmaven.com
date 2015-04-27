use strict;
use warnings;
use 5.010;

use List::Util qw(all);

my @numbers = ( 1, 2, 3, 5, 3 );

say all { $_ > 0 } @numbers;       # 1
say all { $_ > 1 } @numbers;       #

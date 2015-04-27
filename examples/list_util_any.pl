use strict;
use warnings;
use 5.010;

use List::Util qw(any);

my @numbers = ( 1, 2, 3, 5, 3 );

say any { $_ < 2 } @numbers;       # 1
say any { $_ < 1 } @numbers;       # 

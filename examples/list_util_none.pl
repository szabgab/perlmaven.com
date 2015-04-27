use strict;
use warnings;
use 5.010;

use List::Util qw(all none any);

my @numbers = ( 1, 2, 3, 5, 3 );

say none { $_ < 0 } @numbers;      # 1
say all { $_ >= 0 } @numbers;      # 1
say not any { $_ < 0 } @numbers;   # 1

say none { $_ < 2 } @numbers;      #
say all { $_ >= 2 } @numbers;      #
say not any { $_ < 2 } @numbers;   #

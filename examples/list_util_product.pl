use strict;
use warnings;
use 5.010;

use List::Util qw(product reduce);

my @empty;
my @numbers = (2, 3, 4);

say product @numbers;                  # 24
say product @empty;                    # 1

say reduce { $a * $b } (1, @numbers);  # 24
say reduce { $a * $b } (1, @empty);    # 1

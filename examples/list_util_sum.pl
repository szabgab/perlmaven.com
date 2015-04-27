use strict;
use warnings;
use 5.010;

use List::Util qw(sum sum0 reduce);

my @empty;
my @numbers = (2, 3, 4);

say sum @numbers;     # 9
say sum @empty;       # Use of uninitialized value in say at ..
say sum0 @numbers;    # 9
say sum0 @empty;      # 0

say reduce { $a + $b } (0, @numbers);  # 9
say reduce { $a + $b } (0, @empty);    # 0

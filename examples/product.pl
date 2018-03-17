use 5.010;
use strict;
use warnings;
use List::Util qw(product);

my @interest = (1.2, 2.6, 4, '1.3');

say product(@interest); # 16.224

my @empty;
say product(@empty); # 1


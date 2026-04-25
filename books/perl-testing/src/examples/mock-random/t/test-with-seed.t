use strict;
use warnings;

use Test::More;
use MyRandomApp qw(dice);

srand(1);
is dice(10), 1;

srand(2);
is dice(10), 10;

srand(3);
is dice(10), 8;

srand(4);
is dice(10), 7;
is dice(10), 6;
is dice(10), 1;
is dice(10), 8;

done_testing;

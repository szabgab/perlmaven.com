use strict;
use warnings;

use Test::More;
use Test::IsAny qw(is_any);

use MyRandomApp qw(dice);


is_any dice(10), [1..10];
is_any dice(10), [1..10];

done_testing;

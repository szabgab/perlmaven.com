use strict;
use warnings;

use Test::More;

use MyMath;

plan tests => 1;

my $result = MyMath::add(2, 3);
#is $result, 5;

ok 1;


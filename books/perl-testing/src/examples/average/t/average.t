use strict;
use warnings;

use lib 'lib';
use MyMath;

use Test::More;
use Test::Exception;

is MyMath::average(1, 1), 1;
is MyMath::average(1, 2, 3), 2;

throws_ok { MyMath::average() } qr/Illegal division by zero/, 'missing parameter';
#throws_ok { MyMath::average() } qr/Missing parameters/, 'missing parameter';

#is MyMath::average("abc", "def"), 0;
#We might want the average function to rais an exception when strings were given.
#or we might decide to treat them as 0
#or as hexadecimal values
#or ....

#throws_ok { MyMath::average(23, "def") } qr/We can only average numbers. Found 'def'/;

done_testing;

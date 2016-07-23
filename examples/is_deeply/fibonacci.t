use strict;
use warnings;

use Test::More tests => 5;

use MyTools;

is_deeply fibonacci(1), [1],              'fibonacci 1';
is_deeply fibonacci(2), [1, 1],           'fibonacci 2';
is_deeply fibonacci(3), [1, 1, 2],        'fibonacci 3';
is_deeply fibonacci(4), [1, 1, 2, 3],     'fibonacci 4';
is_deeply fibonacci(5), [1, 1, 2, 3, 5],  'fibonacci 5';

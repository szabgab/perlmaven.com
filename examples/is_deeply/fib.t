use strict;
use warnings;

use Test::More tests => 5;

use MyTools;

is fibo(1), 1, 'fib 1';
is fibo(2), 1, 'fib 2';
is fibo(3), 2, 'fib 3';
is fibo(4), 3, 'fib 4';
is fibo(5), 5, 'fib 5';

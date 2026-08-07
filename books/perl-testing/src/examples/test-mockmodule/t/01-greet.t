use strict;
use warnings;

use Test::More;

use MyGreeting;

is(
    MyGreeting->greet('Gabor'),
    'Hello Gabor',
    'real provider returns the default prefix',
);

is(
    MyGreeting::greet('Unused', 'Gabor'),
    'Hello Gabor',
    'real provider returns the default prefix',
);


done_testing;

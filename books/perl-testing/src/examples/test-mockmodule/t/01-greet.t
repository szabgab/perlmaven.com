use strict;
use warnings;

use Test::More;
use Test::MockModule;

use MyGreeting;

is(
    MyGreeting->greet('Gabor'),
    'Hello Gabor',
    'real provider returns the default prefix',
);

my $provider = Test::MockModule->new('MyGreeting::Provider');
$provider->redefine(
    get_greeting_prefix => sub {
        return 'Good morning';
    }
);

is(
    MyGreeting->greet('Gabor'),
    'Good morning Gabor',
    'mocked provider changes the greeting',
);

done_testing;

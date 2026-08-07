use strict;
use warnings;

use Test::More;
use Test::MockModule;

use MyGreeting;

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

is(
    MyGreeting::greet('unused', 'Gabor'),
    'Good morning Gabor',
    'mocked provider changes the greeting',
);


done_testing;

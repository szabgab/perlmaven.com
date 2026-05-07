package MyGreeting::Provider;
use strict;
use warnings;

sub get_greeting_prefix {
    # pretend that it takes time maybe because it is an external call.
    sleep(3);
    return 'Hello';
}

1;

package MyGreeting;
use strict;
use warnings;

use MyGreeting::Provider ();

our $VERSION = '0.01';

sub greet {
    my ($class, $name) = @_;

    my $prefix = MyGreeting::Provider::get_greeting_prefix();
    return "$prefix $name";
}

1;

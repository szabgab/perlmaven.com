use warnings;
use strict;
use 5.010;

my @names = qw(Foo Bar);
say $names[0];

sub f {
    my @prevCommands = @{ $_[0] };
}


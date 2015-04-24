package Greeting;
use strict;
use warnings;
use 5.010;
use Data::Dumper;

sub new {
    my ($class) = @_;

    return bless {}, $class;
}

sub AUTOLOAD {
    our $AUTOLOAD;
    say $AUTOLOAD;
    say Dumper \@_;
}

1;


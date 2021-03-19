package MyZorg;
use strict;
use warnings;

sub new {
    my ($class) = @_;
    print "Inside new for $class\n";
    return bless {}, $class;
}

DESTROY {
    my ($self) = @_;
    print "DESTROY for: $self\n";
}

1;

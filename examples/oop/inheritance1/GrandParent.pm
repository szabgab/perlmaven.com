package GrandParent;
use strict;
use warnings;

sub new {
    my ($class) = @_;
    return bless {}, $class;
}
 
sub say_hi {
    my ($self) = @_;
    print "Hi from GrandParent\n";
    return;
}

1;

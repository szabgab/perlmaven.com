package MyParent;
use strict;
use warnings;

sub new {
    my ($class) = @_;
    return bless {}, $class;
}
 
sub say_hi {
    my ($self) = @_;
    print "Hi from MyParent\n";
    return;
}

1;

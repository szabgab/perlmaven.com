package MyFruit;
use strict;
use warnings;

sub new {
    my ($class) = @_;

    print "Inside new for $class\n";
    my $self = {};

    print "Self is still only a reference $self\n";
    bless $self, $class;

    print "Self is now associated with the class: $self\n";

    return $self;
}

1;

use strict;
use warnings;
use MyZorg;

print "Before calling new\n";

{
    my $zorg = MyZorg->new;
    print "Instance of: $zorg\n";
    print "Before leaving scope\n";
}

print "After leaving scope\n";

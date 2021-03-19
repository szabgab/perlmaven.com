use strict;
use warnings;
use MyZorg;

print "Before calling new\n";

my $zorg = MyZorg->new;
print "Instance of: $zorg\n";
print "Before changing variable\n";

$zorg = 'something else';

print "After changing variable\n";

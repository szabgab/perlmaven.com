use strict;
use warnings;
use 5.010;

print "How old are you? ";
my $age = <STDIN>;
if ($age < 13) {
    print "You are too young for this\n";
    exit;
}

print "Doing some stuff ...\n";


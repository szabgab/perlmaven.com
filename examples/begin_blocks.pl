use strict;
use warnings;

print "Start\n";

BEGIN {
    print "First BEGIN\n";
}

print "Between the two\n";

BEGIN {
    print "Second BEGIN\n";
}

print "Goodbye\n";

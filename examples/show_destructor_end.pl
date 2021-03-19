use strict;
use warnings;
use MyZorg;

print "Before calling new\n";

END {
    print "END\n";
}

my $zorg = MyZorg->new;
print "Instance of: $zorg\n";


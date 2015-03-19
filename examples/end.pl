use strict;
use warnings;

print "hello world\n";

my $x = 42;
my $y = 0;
my $z = $x / $y;

print "The result is $z\n";

END {
   print "in the END block\n";
}


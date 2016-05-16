use 5.010;
use strict;
use warnings;

print "First number: ";
my $x = <STDIN>;

print "Second number: ";
my $y = <STDIN>;

print "Operator [+-*/]: ";
my $op = <STDIN>;

my $z = eval "$x $op $y";

say $z;

use strict;
use warnings;

my $autoflush = shift;

if (defined $autoflush) {
    $| = $autoflush;
}

print "STDOUT First ";
print STDERR "STDERR First ";
print "STDOUT Second ";
print STDERR "STDERR Second ";
print "\n";

use strict;
use warnings;
use 5.010;

my $dir = shift // '.';

opendir my $dh, $dir or die "Could not open '$dir' for reading '$!'\n";
my @things = readdir $dh;
foreach my $thing (@things) {
    if ($thing eq '.' or $thing eq '..') {
        next;
    }
    say $thing;
}
closedir $dh;


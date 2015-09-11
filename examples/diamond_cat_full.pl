use strict;
use warnings;

while (my $line = <>) {
    print "$ARGV $. $line";
}


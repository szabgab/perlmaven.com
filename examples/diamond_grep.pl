use strict;
use warnings;

while (my $line = <>) {
    if ( $line =~ /perl/) {
        print $line;
    }
}


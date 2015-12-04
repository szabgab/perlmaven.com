use strict;
use warnings;
use 5.010;

use version;

my @versions = ( 'v5.11', '5.011', '5.012', '5.1.1', '5.1.2', '5.10',  '5.10_01');


my @sorted = sort { version->parse( $a ) <=> version->parse( $b ) } @versions;
for my $s (@sorted) {
    say $s;
}


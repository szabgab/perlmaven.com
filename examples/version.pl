use strict;
use warnings;
use 5.010;

use version;

my @cases = (
    [ 'v5.11', '5.011' ],
    [ 'v5.11', '5.012' ],
    [ '5.1.1', '5.1.2' ],
    [ '5.10',  '5.10_01'],
    [ '5.10',  'v5.10'],
    [ '5.10',  'v5.11'],
);

foreach my $c (@cases) {
    say '----';
    say $c->[0];
    say $c->[1];
    say version->parse( $c->[0] ) < version->parse( $c->[1] );
    say version->parse( $c->[0] ) == version->parse( $c->[1] );
}



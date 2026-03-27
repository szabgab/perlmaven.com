use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use MySimpleCalc qw(sum);

my @tests = (
    [ 1,  1,  2    ],
    [ 2,  2,  4    ],
    [ 3,  3,  6    ],
    [-1, -1, -2    ],
    [ 1, -1,  0    ],
);

use Test::More;
plan tests => scalar @tests;
#use Test::More 'no_plan';
#use Test::More;

foreach my $t (@tests) {
    my $expected = pop @$t;
    my $real     = sum(@$t);
    my $name     = join " + ", @$t;

    ok( $real == $expected, $name );
    #exit if $expected == 6;
    #last if $expected == 6;
}

done_testing();


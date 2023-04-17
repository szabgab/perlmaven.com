use 5.010;
use strict;
use warnings;

my %h = ( abc => 23, def => 19 );

while (my ($k, $v) = each %h) {
    say "$k  => $v";
    if ($k eq 'abc') {
        $h{answer} = 42;
    }
}

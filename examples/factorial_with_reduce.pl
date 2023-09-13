use strict;
use warnings;
use 5.010;

use List::Util qw(reduce);

my $n = shift // die "Usage: $0 N\n";

{
    my $fact = reduce { $a * $b } 1 .. $n;
    say $fact;
}

{
    # handles 0! = 1 as well
    my $fact = $n == 0 ? 1 : reduce { $a * $b } 1 .. $n;
    say $fact;
}

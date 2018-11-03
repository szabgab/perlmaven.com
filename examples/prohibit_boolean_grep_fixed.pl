use strict;
use warnings;

use List::MoreUtils qw(any);

my @names = qw(Foo Bar Baz);

if (any { $_ eq 'Bar'} @names) {
    print "Found\n";
}

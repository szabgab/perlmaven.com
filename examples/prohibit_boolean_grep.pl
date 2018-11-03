use strict;
use warnings;


my @names = qw(Foo Bar Baz);

if (grep { $_ eq 'Bar'} @names) {
    print "Found\n";
}

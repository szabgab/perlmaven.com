use strict;
use warnings;
use 5.010;

my $n = shift // die "Usage: $0 N\n";

my $f = 1;
my $i = 1;
$f *= ++$i while $i < $n;
say $f;


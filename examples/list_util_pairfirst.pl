use strict;
use warnings;
use 5.010;

use List::Util qw(pairfirst);

my @things = (2, 3, 6, 5, 7, 7, 9, 8);

my @data = pairfirst { $a > $b } @things;
use Data::Dumper;
print Dumper \@data;


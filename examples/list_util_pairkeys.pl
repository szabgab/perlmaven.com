use strict;
use warnings;
use 5.010;

use List::Util qw(pairkeys);

my @things = ('foo', 3, 'bar', 5, 'moo', 7, 'zorg');

my @data = pairkeys @things;
use Data::Dumper;
print Dumper \@data;

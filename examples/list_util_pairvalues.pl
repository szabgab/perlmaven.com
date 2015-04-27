use strict;
use warnings;
use 5.010;

use List::Util qw(pairvalues);

my @things = ('foo', 3, 'bar', 5, 'moo', 7, 'zorg');

my @data = pairvalues @things;
use Data::Dumper;
print Dumper \@data;


use strict;
use warnings;

use Data::Dumper qw(Dumper);

my @counter;
print Dumper \@counter;
$counter[1] = 20;
$counter[3]++;
print Dumper \@counter;


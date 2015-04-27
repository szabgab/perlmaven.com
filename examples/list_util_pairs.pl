use strict;
use warnings;
use 5.010;

use List::Util qw(pairs);

my @things = ('foo', 3, 'bar', 5, 'moo', 7);

my @pairs = pairs @things;
foreach my $t (@pairs) {
   say "0: $t->[0]";
   say "1: $t->[1]";
}

say '';

foreach my $t (@pairs) {
   say "key:   " . $t->key;
   say "value: " . $t->value;
}

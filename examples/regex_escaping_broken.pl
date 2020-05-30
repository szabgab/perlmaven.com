use 5.010;
use strict;
use warnings;

my $pat = '(\\)';
say '\\' =~ /^$pat/ ? "OK" : "NO MATCH!\n";   # Unmatched ( in regex

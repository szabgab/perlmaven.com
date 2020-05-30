use 5.010;
use strict;
use warnings;

my $pat = qr'(\\)';
say '\\' =~ /^$pat/ ? "OK" : "NO MATCH!\n";   # OK

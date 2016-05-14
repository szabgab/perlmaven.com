use strict;
use warnings;

use Data::Dumper qw(Dumper);

my $str = "abc 23 def";
my @pieces = split /(\d+)/, $str;

print Dumper \@pieces;
 

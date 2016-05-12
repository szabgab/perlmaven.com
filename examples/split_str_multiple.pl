use strict;
use warnings;

use Data::Dumper qw(Dumper);

my $str = "abc 2=3 def ";
my @pieces = split /(\d+)=(\d+)/, $str;

print Dumper \@pieces;
 

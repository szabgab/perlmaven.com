use strict;
use warnings;

use Path::Tiny qw(path);
use Data::Dumper qw(Dumper);

my $data = path('counter.txt')->slurp_utf8;
my @pieces = split /(\d+)/, $data;
print Dumper \@pieces;

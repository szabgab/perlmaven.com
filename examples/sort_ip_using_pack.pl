use strict;
use warnings;
use Data::Dumper qw(Dumper);

my @ips = (
    '100.1.2.3',
    '99.1.2.3',
    '100.2.2.3',
    '10.0.0.1',
);

my @sorted = sort {
     pack('C*', split /\./, $a)
     cmp
     pack('C*', split /\./, $b)
} @ips;

print Dumper \@sorted;
# todo: use SChwartzian Transform


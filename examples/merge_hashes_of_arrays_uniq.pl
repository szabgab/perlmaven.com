use 5.010;
use strict;
use warnings;
use Data::Dump qw(dump);
use List::MoreUtils qw(uniq);

my %semesterOne = (
    Jack    => [1, 1, 2, 7],
    Antonie => [2, 1],
);

my %semesterTwo = (
    Jack    => [1, 3],
    Antonie => [2, 4],
    Alex    => [2, 3, 4],
);

my %merged;
for my $hash (\%semesterOne, \%semesterTwo) {
    for my $k (keys %$hash) {
        @{ $merged{$k} } = uniq ( @{ $merged{$k} }, @{ $hash->{$k} } );
    }
}

say dump \%merged;


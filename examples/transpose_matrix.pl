use 5.010;
use strict;
use warnings;
use Data::Dump qw(dump);

my @matrix = (
    [ 'name11', 'name12', 'name13', 'name14' ],
    [ 'name21', 'name22', 'name23', 'name24' ],
    [ 'name31', 'name32', 'name33', 'name34' ],
);

say dump \@matrix;
my @tr;
for my $row (0..@matrix-1) {
    for my $col (0..@{$matrix[$row]}-1) {
        $tr[$col][$row] = $matrix[$row][$col];
    }
}
say dump \@tr;

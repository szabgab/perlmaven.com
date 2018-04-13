use strict;
use warnings;

my %hash_of_hash_of_arrays = (
    'test' => {
        'A_width' => [
            '1',
            '2',
            '3',
        ],
        'B_width' => [
            '4',
            '5',
            '6',
            'x',
        ],
    },
    'prod' => {
        'C_width' => [
            '7',
            '8',
            '9',
            'y',
        ],
        'D_width' => [
            '10',
            '11',
            '12',
        ],
    },
);

for my $module (reverse sort keys %hash_of_hash_of_arrays) {
    my @entries;
    for my $field (sort keys %{ $hash_of_hash_of_arrays{$module} }) {
        for my $i (0 .. @{ $hash_of_hash_of_arrays{$module}{$field} } - 1) {
            push @{ $entries[$i] }, "$field : $hash_of_hash_of_arrays{$module}{$field}[$i]\n";
        }
    }

    for my $entry (@entries) {
        print "module : $module\n";
        print @$entry;
        print "\n";
    }
}

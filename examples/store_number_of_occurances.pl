use strict;
use warnings;

my @strings = ('hello', 'world', 'hello', 'Perl');

my %count;

foreach my $str (@strings) {
    $count{$str}++;
}

foreach my $str (sort keys %count) {
    printf "%-31s %s\n", $str, $count{$str};
}


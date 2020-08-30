use strict;
use warnings;

my @cases = (
    "abcde",
    "12345",
);

for my $case (@cases) {
    print "$case\n";
    $case =~ /([a-z])/;
    print "$1\n";
}

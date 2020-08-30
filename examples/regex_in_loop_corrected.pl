use strict;
use warnings;

my @cases = (
    "abcde",
    "12345",
);

for my $case (@cases) {
    print "$case\n";
    if ($case =~ /([a-z])/) {
        print("match\n");
        print "$1\n";
    }
}

use strict;
use warnings;

my $file = 'counter.txt';
my $count = 0;


if (open my $fh, '+<', $file) {
    $count = <$fh>;
    close $fh;
}

$count++;
print "$count\n";

if (open my $fh, '>', $file) {
    print $fh $count;
    close $fh;
}


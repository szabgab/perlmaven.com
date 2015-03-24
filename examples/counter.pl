use strict;
use warnings;

my $file = 'counter.txt';
my $count = 0;

if (-e $file) {
    open my $fh, '<', $file or die "Could not open '$file' for reading. $!";
    $count = <$fh>;
    close $fh;
}

$count++;
print "$count\n";

open my $fh, '>', $file or die "Could not open '$file' for writing. $!";
print $fh $count;
close $fh;


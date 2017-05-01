use strict;
use warnings;

my ($infile, $outfile) = @ARGV;
die "USAGE: $0 INFILE OUTFILE\n" if not $outfile;

open my $in,  '<', $infile  or die "Could not open '$infile': $!";
open my $out, '>', $outfile or die "Could not open '$outfile': $!";

my @seen;
while (my $line = <$in>) {
    my $chr = substr $line, 0, 1;
    my $ascii = ord $chr;
    if ($seen[$ascii]) {
        next;
    }
    $seen[$ascii] = 1;
    print $out $line;
}

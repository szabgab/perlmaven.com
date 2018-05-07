use strict;
use warnings;

my ($infile, $outfile) = @ARGV;
die "Usage: $0 INFILE OUTFILE\n" if not $outfile;

open my $in, '<', $infile or die;
my @entries;
while (my $line = <$in>) {
    chomp $line;
    push @entries, split /,/, $line;
}
close $in;

open my $out, '>', $outfile or die;
for my $entry (@entries) {
    print $out "$entry\n";
}
close $out;

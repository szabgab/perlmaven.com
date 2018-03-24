use 5.010;
use strict;
use warnings;

my ($infile, $outfile) = @ARGV;
die "Usage: $0 INFILE OUTFILE\n" if not $outfile;

open my $in, '<', $infile or die;
binmode $in;

my $cont = '';

while (1) {
    my $success = read $in, $cont, 100, length($cont);
    die $! if not defined $success;
    last if not $success;
}
close $in;

open my $out, '>', $outfile or die;
print $out $cont;
close $out;

say length($cont);
say -s $infile;
say -s $outfile;


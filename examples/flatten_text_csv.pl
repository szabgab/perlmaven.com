use strict;
use warnings;
use Text::CSV;

my ($infile, $outfile) = @ARGV;
die "Usage: $0 INFILE OUTFILE\n" if not $outfile;

my $csv = Text::CSV->new ({
    binary    => 1,
    auto_diag => 1,
});
 

open my $in, '<:encoding(utf8)', $infile or die;
my @entries;
while (my $fields = $csv->getline( $in )) {
  push @entries, @$fields;
}
close $in;

open my $out, '>', $outfile or die;
for my $entry (@entries) {
    print $out "$entry\n";
}
close $out;


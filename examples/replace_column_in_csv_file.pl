use strict;
use warnings;
use Text::CSV;

my ($infile, $outfile) = @ARGV;
die "Usage: $0 IN_CSV_FILE OUT_CSV_FILE\n" if not $outfile or not -e $infile;

my $csv = Text::CSV->new ({
  binary    => 1,
  auto_diag => 1,
});

open(my $in,  '<:encoding(utf8)', $infile)  or die "Could not open '$infile' $!\n";
open(my $out, '>:encoding(utf8)', $outfile) or die "Could not open '$outfile' $!\n";
 
while (my $fields = $csv->getline( $in )) {
    $fields->[3] = 'CIF';
    $csv->print($out, $fields);
    print $out "\n";
}
close $in;
close $out;
 

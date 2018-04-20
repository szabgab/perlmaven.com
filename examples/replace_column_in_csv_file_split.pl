use strict;
use warnings;

my ($infile, $outfile) = @ARGV;
die "Usage: $0 IN_CSV_FILE OUT_CSV_FILE\n" if not $outfile or not -e $infile;

open(my $in,  '<:encoding(utf8)', $infile)  or die "Could not open '$infile' $!\n";
open(my $out, '>:encoding(utf8)', $outfile) or die "Could not open '$outfile' $!\n";
 
while (my $line = <$in>) {
    chomp $line;
    my @fields = split /,/, $line;
    $fields[3] = 'CIF';
    print $out join ',', @fields;
    print $out "\n";
}
close $in;
close $out;
 


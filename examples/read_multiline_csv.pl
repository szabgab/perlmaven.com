#!/usr/bin/perl
use strict;
use warnings;

use Text::CSV;

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $csv = Text::CSV->new ({
  binary    => 1,
  auto_diag => 1,
  sep_char  => ','    # not really needed as this is the default
});

my $sum = 0;
open(my $data, '<:encoding(utf8)', $file) or die "Could not open '$file' $!\n";
while (my $fields = $csv->getline( $data )) {
  $sum += $fields->[2];
}
if (not $csv->eof) {
  $csv->error_diag();
}
close $data;
print "$sum\n";


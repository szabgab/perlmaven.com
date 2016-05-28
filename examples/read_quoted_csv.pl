#!/usr/bin/perl
use strict;
use warnings;

use Text::CSV;
my $csv = Text::CSV->new({ sep_char => ',' });

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $sum = 0;
open(my $data, '<', $file) or die "Could not open '$file' $!\n";
while (my $line = <$data>) {
  chomp $line;

  if ($csv->parse($line)) {

      my @fields = $csv->fields();
      $sum += $fields[2];

  } else {
      warn "Line could not be parsed: $line\n";
  }
}
print "$sum\n";

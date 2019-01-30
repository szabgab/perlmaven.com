#!/usr/bin/perl
use strict;
use warnings;
use Text::CSV;

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $csv = Text::CSV->new ({ binary    => 1, auto_diag => 1, sep_char  => ',', quote_char => q{'} });
open(my $data, '<:encoding(utf8)', $file) or die "Could not open '$file' $!\n";

while (my $fields = $csv->getline( $data )) {
}


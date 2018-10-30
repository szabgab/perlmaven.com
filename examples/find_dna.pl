#!/usr/bin/perl
use strict;
use warnings;

my $file = shift or die "Usage: $0 FILENAME\n";

open my $fh, '<', $file or die;

my $interesting_dna;
while (my $line = <$fh>) {
    chomp $line;

    my ($dna) = $line =~ /^DNA:(.*)/;
    if (not $dna) {
        next; #skip rows without DNA: at the beginning
    }
    print "Checking $dna\n";

    if ($dna =~ /([ACTG]{3}).*\1/) {
        $interesting_dna = $dna;
        last; # got to the end of the loop, skip rest of the file
    }
}

if ($interesting_dna) {
    print "First interesting DNA: $interesting_dna\n";
}



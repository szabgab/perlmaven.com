#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Spreadsheet::Read qw(ReadData);

my $book = ReadData('simple.xlsx');

say 'A1: ' . $book->[1]{A1}; 

my @row = Spreadsheet::Read::row($book->[1], 1);
for my $i (0 .. $#row) {
    say 'A' . ($i+1) . ' ' . ($row[$i] // '');
}

my @rows = Spreadsheet::Read::rows($book->[1]);
foreach my $i (1 .. scalar @rows) {
    foreach my $j (1 .. scalar @{$rows[$i-1]}) {
        say chr(64+$i) . " $j " . ($rows[$i-1][$j-1] // '');
    }
}


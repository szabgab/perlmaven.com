#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Spreadsheet::Read qw(ReadData);

# May require installing Spreadsheet::XLSX.
my $book = ReadData('simple.xlsx');

say 'A1: ' . $book->[1]{A1}; 

my @row = Spreadsheet::Read::row($book->[1], 1);
say "";
say "row 1:";
for my $i (0 .. $#row) {
    say $row[$i] // '';
}

my @rows = Spreadsheet::Read::rows($book->[1]);
say "";
foreach my $i (0 .. $#rows) {
    foreach my $j (0 .. $#{$rows[$i]}) {
        say chr(ord('A')+$j) . ($i+1) . ": " . ($rows[$i][$j] // '');
    }
}

# Or just dump the data:
use Data::Dumper;
say "";
say Dumper \@rows;

# Output:
# $VAR1 = [
#           [
#             'A1',
#             'B1',
#             'C1'
#           ],
#           [
#             'A2',
#             'B2',
#             'C2'
#           ],
#           [
#             'A3',
#             'B3',
#             'C3'
#           ]
#         ];

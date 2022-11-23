#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

my $file = shift or die "Usage: $0 FILENAME\n";

use Spreadsheet::Read qw(ReadData);

my $book = ReadData($file);

say 'A1: ' . $book->[1]{A1};
say 'A2: ' . $book->[1]{A2};
say 'A3: ' . $book->[1]{A3};
say 'A4: ' . $book->[1]{A4};


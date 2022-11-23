#!/usr/bin/perl
use strict;
use warnings;
use 5.010;
use Spreadsheet::ParseExcel;
use DateTime;

my $file = shift or die "Usage: $0 FILENAME\n";

my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($file);
if ( not defined $workbook ) {
    die $parser->error(), ".\n";
}

my @worksheets = $workbook->worksheets();
say 'A1: ' . $worksheets[0]->get_cell( 0, 0 )->value;
say 'A2: ' . $worksheets[0]->get_cell( 1, 0 )->value;
say 'A3: ' . $worksheets[0]->get_cell( 2, 0 )->value;
say 'A4: ' . $worksheets[0]->get_cell( 3, 0 )->value;
say '';

say 'A1: ' . $worksheets[0]->get_cell( 0, 0 )->unformatted;
say 'A2: ' . $worksheets[0]->get_cell( 1, 0 )->unformatted;
say 'A3: ' . $worksheets[0]->get_cell( 2, 0 )->unformatted;
say 'A4: ' . $worksheets[0]->get_cell( 3, 0 )->unformatted;

say '';

# December 31, 1899
my $start_date = DateTime->new(
    year       => 1899,
    month      => 12,
    day        => 30,
    hour       => 0,
    minute     => 0,
    second     => 0,
);

say "--- Use the date from a cell ---";
say $start_date->ymd;
my $date = $start_date->clone->add( days => $worksheets[0]->get_cell( 0, 0 )->unformatted );
say $date->ymd;

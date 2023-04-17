#!/usr/bin/perl
use strict;
use warnings;

use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( 'simple.xlsx' );
my $worksheet = $workbook->add_worksheet();

my @data_for_row = (1, 2, 3);
my @table = (
    [4, 5],
    [6, 7],
);
my @data_for_column = (10, 11, 12);


$worksheet->write( "A1", "Hi Excel!" );
$worksheet->write( "A2", "second row" );

$worksheet->write( "A3", \@data_for_row );
$worksheet->write( 4, 0, \@table );
$worksheet->write( 0, 4, [ \@data_for_column ] );

$workbook->close;


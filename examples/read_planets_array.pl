#!/usr/bin/perl
use strict;
use warnings;

use Text::CSV;
use Data::Dumper qw(Dumper);

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

read_as_array($file);

sub read_as_array {
    my ($filename) = @_;

    my $csv = Text::CSV->new ({
        binary    => 1,
        auto_diag => 1,
        sep_char  => ','    # not really needed as this is the default
    });

    open(my $data, '<:encoding(utf8)', $filename) or die "Could not open '$filename' $!\n";
    while (my $row = $csv->getline($data)) {
        print(Dumper $row);
    }
    close $data;
}


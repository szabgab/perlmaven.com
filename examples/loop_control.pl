#!/usr/bin/perl
use strict;
use warnings;

my $file = shift or die "Usage: $0 FILENAME\n";

open my $fh, '<', $file or die;

my $counter = 0;
my $empty = 0;
my $nonempty = 0;
while (my $line = <$fh>) {
    $counter++;
    chomp $line;
    if ($line eq "__END__") {
        last;     # end processing file
    }

    if ($line eq "") {
        $empty++;
        next;     # don't process empty rows, go to next line
    }

    print "Process '$line'\n";
    $nonempty++;
                                    ### next jumps here ###
}
                                    ### last jumps here ###
print "Number of empty rows $empty and non empty rows: $nonempty out of a total of $counter\n"



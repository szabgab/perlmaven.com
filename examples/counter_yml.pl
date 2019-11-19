use strict;
use warnings;
use 5.010;

use YAML qw(LoadFile DumpFile);

my $name = shift or die "Usage: $0 NAME\n";

my $filename = 'counter.yml';

my $data = {};
if (-e $filename) {
    $data = LoadFile($filename);
}

$data->{$name}++;
say $data->{$name};

DumpFile($filename, $data);

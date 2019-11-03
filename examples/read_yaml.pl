use strict;
use warnings;
use YAML qw(LoadFile);
use Data::Dumper qw(Dumper);

my $filename = shift or die "Usage: $0 YAML-FILE\n";

my $data = LoadFile($filename);

print Dumper $data;

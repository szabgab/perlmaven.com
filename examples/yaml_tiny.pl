use 5.010;
use strict;
use warnings;

use Data::Dumper qw(Dumper);
use YAML::Tiny;

my $file = shift or die "Usage: $0 YAML_FILE\n";

say $YAML::Tiny::VERSION;
my $x = YAML::Tiny::LoadFile($file);
say Dumper $x; 


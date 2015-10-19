use 5.010;
use strict;
use warnings;

use Data::Dumper qw(Dumper);
use YAML;

my $file = shift or die "Usage: $0 YAML_FILE\n";

say $YAML::VERSION;
my $x = YAML::LoadFile($file);
say Dumper $x; 


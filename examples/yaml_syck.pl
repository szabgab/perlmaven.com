use 5.010;
use strict;
use warnings;

use Data::Dumper qw(Dumper);
use YAML::Syck;

my $file = shift or die "Usage: $0 YAML_FILE\n";

say $YAML::Syck::VERSION;
my $x = YAML::Syck::LoadFile($file);
say Dumper $x; 


use 5.010;
use strict;
use warnings;

use Data::Dumper qw(Dumper);
use YAML::XS;

my $file = shift or die "Usage: $0 YAML_FILE\n";

say $YAML::XS::VERSION;
my $x = YAML::XS::LoadFile($file);
say Dumper $x; 


use strict;
use warnings;
use 5.010;

use Config::Tiny;
use Data::Dumper qw(Dumper);

my $filename = shift or die "Usage: $0 FILENAME\n";

my $config = Config::Tiny->read( $filename, 'utf8' );

say $config->{digital_ocean}{api};     # seaworld

say $config->{openweathermap}{api};    # asdahkaky131

say $config->{aws}{api_key};           # myaws7980
say $config->{aws}{api_code};          # qkhdkadyday


print Dumper $config;


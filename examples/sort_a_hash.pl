use strict;
use warnings;
use 5.010;

my %planets = (
   Mercury => 0.4,
   Venus   => 0.7,
   Earth   => 1,
   Mars    => 1.5,
   Ceres   => 2.77,
   Jupiter => 5.2,
   Saturn  => 9.5,
   Uranus  => 19.6,
   Neptune => 30,
   Pluto   => 39,
   Charon  => 39,
);

foreach my $name (keys %planets) {
    printf "%-8s %s\n", $name, $planets{$name};
}


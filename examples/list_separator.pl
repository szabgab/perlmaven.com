use strict;
use warnings;

my @planets = qw(
   Mercury
   Venus
   Earth
   Mars
   Jupiter
   Saturn
   Uranus
   Neptune
);

print "@planets\n";  # Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune

$" = '-';
print "@planets\n"; # Mercury-Venus-Earth-Mars-Jupiter-Saturn-Uranus-Neptune

{
    local $" = '-^-';
    print "@planets\n"; # Mercury-^-Venus-^-Earth-^-Mars-^-Jupiter-^-Saturn-^-Uranus-^-Neptune
}

print "@planets\n"; # Mercury-Venus-Earth-Mars-Jupiter-Saturn-Uranus-Neptune

$" = '';
print "@planets\n"; # MercuryVenusEarthMarsJupiterSaturnUranusNeptune


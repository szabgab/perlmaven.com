use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);

say Dumper [split /;/, ";a;b;c"];
say Dumper [split /;/, ";a;b;c;"];
say Dumper [split /;/, ";a;b;c;;"];

say Dumper [split/;/, ";a;b;c;;", -1];

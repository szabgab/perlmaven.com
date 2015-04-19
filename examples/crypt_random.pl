use strict;
use warnings;
use 5.010;

use Crypt::Random qw( makerandom ); 

my $r = makerandom ( Size => 3, Strength => 1, Uniform => 1 );
say $r;


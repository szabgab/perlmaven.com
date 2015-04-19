
use strict;
use warnings;
use 5.010;

use Crypt::Random qw( makerandom_itv ); 

my $N = 10;
my $r = makerandom_itv ( Size => $N, Strength => 1, Uniform => 1, Lower => 1, Upper => 7 );
say $r;

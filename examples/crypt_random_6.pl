use strict;
use warnings;
use 5.010;

use Crypt::Random qw( makerandom ); 

my $N = 10;
my $r = makerandom ( Size => $N, Strength => 1, Uniform => 1 );
my $dice = int (6 * $r / (2**$N));
say $dice;

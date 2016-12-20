use 5.010;
use strict;
use warnings;
use Data::Dumper qw(Dumper);

my $ar = ['apple', 'banana', 'peach'];

say $ar;

say Dumper $ar;

my @a = @$ar;

say $a[0];

say $ar->[0]; # "arrow notation" recommended

say $$ar[0];


use strict;
use warnings FATAL => "all";
use 5.010;

use Scalar::Util qw(looks_like_number);

my $z = 3;
say $z;
my $y = "3.14";

if (looks_like_number($z) and looks_like_number($y)) {
  say $z + $y;
}

say $z . $y;

if (defined $y) {
  say "defined";
} else {
  say "NOT";
}


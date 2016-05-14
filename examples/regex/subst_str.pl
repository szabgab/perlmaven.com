use 5.010;
use strict;
use warnings;

my $yyxx = 42;

sub f {
   my $c = shift;
   return $c . $c;
}

my $str = "xy";
$str =~ s/(\w)(\w)/ '$' .  f($2) . f($1) /;
say $str;  #  ' .  f(y) . f(x)

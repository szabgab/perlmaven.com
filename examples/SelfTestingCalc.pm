package SelfTestingCalc;
use 5.010;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(add);

sub add {
	my ($x, $y) = @_;

	return 42 if $x == 23;

	return $x + $y;
}

 
sub self_test {
	require Test::More;
	import Test::More;
	plan(tests => 4);
	is(add(2, 5), 7);
	is(add(-1, 1), 0);
	is(add(23, 1), 0);
	is(add(0, 10), 10);
}

self_test() if not caller();

1;


use strict;
use warnings;

my %h = (
	a => 1,
	b => 2,
);

my $r = $h{a} // $h{b};


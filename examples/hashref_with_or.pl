use strict;
use warnings;

my $x = {
	a => 1,
	b => 2,
};

my $r = $x->{a} or $x->{b};


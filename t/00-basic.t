use strict;
use warnings;

use YAML;
use Test::More;

plan tests => 2;

my $sites = 'sites.yml';

ok -e $sites;
eval {
	YAML::LoadFile($sites);
};
ok !$@, "Loading $sites" or diag $@;


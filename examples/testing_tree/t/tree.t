use strict;
use warnings;

use Test::More;
use Test::Deep;

use MyTree;

my @good_cases = MyTree::good_cases();
my @bad_cases = MyTree::bad_cases();

plan tests => scalar @good_cases + scalar @bad_cases;

my %end_node = (
	id      => re('^\d+$'),
	payload => re('^\w+$'),
);

my %mid_node = %end_node;

$mid_node{subtree} = array_each( any( \%mid_node, \%end_node ));
my $tree = array_each( any( \%mid_node, \%end_node ));

foreach my $c (@good_cases, @bad_cases) {
	cmp_deeply $c, $tree;
}



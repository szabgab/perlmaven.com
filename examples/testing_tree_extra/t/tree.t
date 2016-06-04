use strict;
use warnings;

use Data::Dumper;
use MyTree;

use Test::More;
use Test::Deep;

plan tests => 2;

my $NUMBER = re('^\d+$');
my $WORD = re('^\w+$');

my %node = (
    id => $NUMBER,
    payload => {
        fname => $WORD,
        lname => $WORD,
    }
);

$node{subtree} = array_each( subhashof( \%node ) );

my $expected_tree = array_each ( subhashof (\%node) );

my $flat_tree = MyTree::get_tree(0, 3);
cmp_deeply $flat_tree, $expected_tree;

my $tree = MyTree::get_tree(0.5, 3);
cmp_deeply $tree, $expected_tree;


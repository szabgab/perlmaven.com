package MyTree;
use strict;
use warnings;

use Text::Lorem;

sub create_payload {
	return {
		fname => Text::Lorem->new()->words(1),
		lname => Text::Lorem->new()->words(1),
	}
}

sub get_tree {
	my ($rand, $n) = @_;

	my $id = 1;

	my @tree;
	foreach (1 .. $n) {
		my %node = (id => $id++, payload => create_payload() );
		if (rand() < $rand and $n > 1) {
			$node{subtree} = get_tree($rand, $n-1);
		}
		push @tree, \%node;
	}
	return \@tree;
	

}

1;

__END__

<include file="examples/testing_tree/lib/MyTree.pm">


The <hl>get_tree</hl> function accepts two numbers and returns a tree. The generation of this
sample data is not very important for our task, but let me explain it anyway.
The tree is generated randomly. The first number represents how likely it is for any node to have a
subtree. The second number is the number of nodes at the current level. The function is called recurcively
to create the subtrees. In order to make sure the recursion will end, at ever level we reduce the second number.

If we pass 0 as the first number then there is no chance to have a subtree, so calling <hl>get_tree(0, 3)</hl>
will generate a flat tree of 3 nodes.
Calling <hl>get_tree(0.5, 3)</hl> means at the first level there are going to be 3 nodes and each node has 50% chance
to have a subtree. Each such subtree will have 2 nodes. Each such node will have 50% chance to have a subtree, but those
subtrees will only have 1 node. So the depth of the tree is also controlled by the second parameter.

The payload is just a hash with two keys and each key has a <a href="/pro/generate-random-text-with-perl">random value generated</a>.

For example running <hl>MyTree::get_tree(0.5, 3)</hl> might generated this tree.

<code>
$VAR1 = [
          {
            'id' => 1,
            'payload' => {
                           'lname' => 'quasi',
                           'fname' => 'omnis'
                         }
          },
          {
            'subtree' => [
                           {
                             'subtree' => [
                                            {
                                              'id' => 1,
                                              'payload' => {
                                                             'lname' => 'quae',
                                                             'fname' => 'quos'
                                                           }
                                            }
                                          ],
                             'id' => 1,
                             'payload' => {
                                            'fname' => 'dolore',
                                            'lname' => 'consequatur'
                                          }
                           },
                           {
                             'payload' => {
                                            'fname' => 'maxime',
                                            'lname' => 'aut'
                                          },
                             'id' => 2,
                             'subtree' => [
                                            {
                                              'payload' => {
                                                             'fname' => 'itaque',
                                                             'lname' => 'enim'
                                                           },
                                              'id' => 1
                                            }
                                          ]
                           }
                         ],
            'payload' => {
                           'lname' => 'est',
                           'fname' => 'minus'
                         },
            'id' => 2
          },
          {
            'id' => 3,
            'payload' => {
                           'lname' => 'et',
                           'fname' => 'ut'
                         }
          }
];
</code>

<h2>The testing code</h2>

<include file="examples/testing_tree/t/tree.t">

First we used the <hl>re</hl> function provided by Test::Deep to create two regular expressions
that will be used in the tests. One matcing a number, the other one mathching a word. This is only
needed to test the content of the payload itself.

Then we create a hash called <hl>%node</hl> that will match a node that does not have a subtree.
In our examples this is expected to have a numeirc id and the payload. The data that is really interesting
for the application.


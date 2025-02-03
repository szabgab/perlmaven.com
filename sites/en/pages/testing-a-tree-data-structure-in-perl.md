---
title: "Testing a tree data structure in Perl"
timestamp: 2017-11-12T19:30:01
tags:
  - Test::Deep
  - array_each
  - any
  - re
published: true
books:
  - testing
author: szabgab
archive: true
---


[Test::More](https://metacpan.org/pod/Test::More) has a function called `is_deeply`
that allows us to
[compare and test any complex data structure](/comparing-complex-data-structures-with-is-deeply),
but it can only do exact comparisons.

[Test::Deep](https://metacpan.org/pod/Test::Deep) on the other hand provides us tools to test arbitrary data structures
in a very flexible way.


## Tree data structure

For example what if we have a tree-like data structure like this one. Every level is an array of nodes. Every node is a hash
containing and id, a payload, which is in itself a hash, and optionally it contains a key called 'subtree' where the value
is another array containing nodes. The depth and the width of the tree can be anything.

```
[
     {
         id      =>   ID_NUMBER,
         payload => DATA_STRUCTURE,
         subtree =>  [ ... ]
     },
     {
         id =>,
         payload =>
     },
     {
         id =>,
         payload =>
         subtree =>  [ ... ]
     }
]
```

How can we test that on various calls the data returns in the expected format?

In order to demonstrate, I've created a list of 2 test cases that are expected to pass
and a list of 7 cases where there is some problem. Either there is extra data or missing data
or the structure was not correct. Then in our test code we go through the test cases.

We expect the good ones to pass and the bad ones to fail. If you save the files as
`lib/MyTree.pm` and `t/tree.t` then you can run the tests as

```
$ perl -Ilib t/testing_tree.t
```

or as

```
$ prove -l
```

## The test code

{% include file="examples/testing_tree/t/tree.t" %}

First we created a hash called `%end_node` that is expected to match
a node without a subtree in it. We used the `re` function provided by
Test::Deep to create a regex that should match.

Then we created another hash called `%mid_node` that is expected to
match a node with a subtree in it. It is the same as the previous hash
with an additional key called `subtree` that has a value which is an array
of elements. Each element is expected to be either another `%mid_tree` or an `%end_tree`.

The whole tree then can also be expressed as an array where each element is either a mid_node or an end_node.

This wasn't too hard, and it seems to be correct as well.

## Source of the data

{% include file="examples/testing_tree/lib/MyTree.pm" %}




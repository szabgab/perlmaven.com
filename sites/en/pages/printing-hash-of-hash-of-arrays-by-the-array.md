---
title: "Printing hash of hashes of arrays by the array"
timestamp: 2020-08-30T09:30:01
tags:
  - hash
  - array
published: true
author: szabgab
archive: true
---


What if you have a hash of some hashes of some arrays and you'd like to print the content grouped, mostly based on the contents
of the arrays? You cannot simply traverse the data structure and print as the grouping must be done based on some internal
part of the data structure.

You first will have to go throughout all the data, built a new data structure and then you can go over that data structure and
print it.

This new data structure can contain the original data in some other hierarchy, or it can contain some already partially formatted
data.

The former will probably allow for more reuse - in case that is needed. The latter will be probably simpler to write
and easer to understand.


## The data structure

This is the original data structure:

{% include file="examples/hash_of_hash_of_array.pl" %}

## Expected output

This is how we would like to format it.

{% include file="examples/hash_of_hash_of_array.txt" %}

## The solution

{% include file="examples/hash_of_hash_of_array_print.pl" %}

This solution uses only a temporary array and tries to make it as simple as possible without any plan of reuse.

First we go over all the keys of the main hash. We have a slight problem here regarding the ordering.
As we are talking about a hash there is no order among the keys internally. When we call `keys`
we get the module names in random order. If we would like to have our output in a certain order we
have to make sure to go over the keys in that order.
Even if we "only" want stability in the order of the output we need to [sort](/how-to-sort-a-hash-in-perl) the keys.
In this solution I've sorted the keys and then used [reverse](/reverse) to get them in reversed order.

A rather arbitrary choice for the show.

For each "module" we are creating an array called `@entries` that will go out of scope at the end of the iteration and will be created again on the next iteration, for the next "module".

Then we go over all the "fields" inside each "module". As this is a hash too, we have to have some kind of a sorting here too for
stable output. (That is so that order won't change from run to run.) 

`$hash_of_hash_of_arrays{$module}` is a reference to a hash, `%{ $hash_of_hash_of_arrays{$module} }` de-references it so we can treat it as a hash.

For each "module" - "field" pair we go over the values. More precisely we go over the index of the values. The reason we need the indexes here is because in the end result we need to group together values from different "fields" based on their index. So knowing the index will allow us to inject the "field" - "value" pair in the right place of the `@entries` array.


After going over the whole data structure of a single "module" we print it as it was expected. First the name of the module and then
the "field : value" pairs.

If you are interested the temporary data structure we created you can use Data::Dumper in the code. For example adding this to line 40
between the two loops.

```perl
use Data::Dumper qw(Dumper);

print Dumper \@entries;
```



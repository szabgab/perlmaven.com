---
title: "Memory use of sparse arrays in Perl"
timestamp: 2018-09-15T11:30:01
tags:
  - Devel::Size
published: true
author: szabgab
archive: true
---


A few days ago, one of the Perl Maven readers asked me about indexing in arrays in Perl, and then he was wondering if arrays
that only have elements in some high index are sparse arrays? In other words if we have an array with a single value at index
1,000,000 does Perl allocate space for all the preceding 1,000,000 elements, or is does it take up place for the single element in
the array.

In yet other words, how much memory does this use?

```perl
my @a;
$a[1_000_000] = 1;
```


We could read the documentation and probably find the answer somewhere, or we could do a little experiment.

In another article we have already used [Devel::Size](https://metacpan.org/pod/Devel::Size) to check the [memory use of Perl variables](/how-much-memory-do-perl-variables-use),
let's use the same tool to check the arrays:

{% include file="examples/memory_of_sparse_arrays.pl" %}

As you can see the memory usage of the array growth as the index of the single element in the array growth. So the arrays in Perl don't have any special
memory-saving algorithm for sparse arrays.

If we need to hold a few values in a data structure with various random large indexes, we can use a hash instead.
The size of the hash only growth as the length of the key. So the key 1,000,000 that has 7 characters in it will take up 6 bytes more than the key 0
which has 1 character in it.

{% include file="examples/memory_of_sparse_hash.pl" %}

The drawback of using hash is that we can't use [array-operations on it such as push, pop](/manipulating-perl-arrays), etc.
and that the values are not sorted. We can fetch the `keys` of the hash, but they will return in random order.

We can of course use the [spaceship operator](/sorting-arrays-in-perl) to [sort the keys numerically](/beginner-perl-maven-sort):

{% include file="examples/sparse_hash.pl" %}

The result is this:

```
42
23
1000
1000000

23
42
1000
1000000
```

You might also use a [sorted hash in Perl using Tie::IxHash](/sorted-hash-tie-ixhash), though I don't remember ever really needing it.

## Comments

Thanks Gabor - not the result I expected but good to know.

<hr>

"In other words if we have an array with a single value at index 1,000,000 does Perl allocate space for all the preceding 1,000,000 elements, or is does it take up place for the single element in the array."

And the answer, not actually mentioned in the article, is: *neither*. The code listed makes space for one array head, *one* scalar, and one million pointers. So it uses more space than an array with a single element at offset zero, and less space than an array with a million elements.



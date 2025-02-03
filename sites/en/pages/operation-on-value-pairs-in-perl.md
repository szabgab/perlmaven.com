---
title: "Operations on value-pairs in Perl"
timestamp: 2016-01-19T22:30:01
tags:
  - List::Util
  - pairs
  - unpairs
  - pairkeys
  - pairvalues
  - pairgrep
  - pairmap
  - pairfirst
published: true
author: szabgab
archive: true
---


Recent versions of [List::Util](https://metacpan.org/pod/List::Util) have introduced a number of functions
dealing with data in pairs without creating little hashes.


## pairs

Given a list of values, e.g

```perl
my @things = ('foo', 3, 'bar', 5, 'moo', 7);
```

The `pairs` function will return a list of pairs:

```perl
(
   [ 'foo', 3 ],
   [ 'bar', 5 ],
   [ 'moo', 7 ],
)
```

actually the elements of the returned list are not just plain [array references](/array-references-in-perl),
but they are also objects of the `List::Util::_Pair` class. Besides de-referencing them as we could do with any
array reference we can also use the `key` and `value` methods to fetch the two elements of the small array.

{% include file="examples/list_util_pairs.pl" %}

The result is the following:

```
0: foo
1: 3
0: bar
1: 5
0: moo
1: 7

key:   foo
value: 3
key:   bar
value: 5
key:   moo
value: 7
```

If the last element in the list does not have a pair because the number of elements is odd,
we get a `Odd number of elements in pairs` warning and `undef` is used instead of the last, missing value.


## unpairs

`unpairs` is the opposite function. Given a list of pairs, it will flatten them into a single list:

{% include file="examples/list_util_unpairs.pl" %}

The output is:

```
foo
3
bar
5
moo
7
```

The small arrays are expected to have 2 values. If they have more, the additional elements are disregarded.
If there are less than 2 elements, the missing elements are filled with [undef](/undef-and-defined-in-perl).
See the following example:

{% include file="examples/list_util_unpairs_not_exact.pl" %}

The resulting output looks like this:

```
foo
3
bar
5
moo
Use of uninitialized value $d in say at list_util_unpairs_not_exact.pl line 11.

```

## pairkeys

This function takes an even list, just as `pairs` did, but instead of a list of little array refs, it returns a list of values
built from the odd elements of the original, the value that would become the "keys" in the `pairs`.


If the number of elements in the original list is odd, the last element is considered as a key, without a value.
This will generated an `Odd number of elements in pairkeys` warning, but as the missing values is not
actually needed to the returned list, that will be the only warning we see.

This code:

{% include file="examples/list_util_pairkeys.pl" %}

will generate this output:

```
Odd number of elements in pairkeys at list_util_pairkeys.pl line 9.
$VAR1 = [
          'foo',
          'bar',
          'moo',
          'zorg'
        ];
```

## pairvalues

Similar to `pairkeys` but this will return the even elements of the original list, the elements that would become
the values if we used the `pairs` function.

If the supplied list has odd number of elements we'll get a warning `Odd number of elements in pairvalues ...`
and the last element of the resulting list will be also `undef`

This code

{% include file="examples/list_util_pairvalues.pl" %}

will generate this output:

```
Odd number of elements in pairvalues at list_util_pairvalues.pl line 9.
$VAR1 = [
          3,
          5,
          7,
          undef
        ];
```


## pairgrep

Similar to the built-in [grep](/filtering-values-with-perl-grep) but works on pairs.

It goes over the given list pair-wise, assigning the odd values to `$a` and the even values to `$b`.
Then the block is executed an the value-pair that generates a true value will pass the filter.

For example this code:

{% include file="examples/list_util_pairgrep.pl" %}

will execute the block 4 times and will generate this output:

```
$VAR1 = [
          6,
          5,
          9,
          8
        ];
```

## pairfirst

The combination of the `first`  and the `pairgrep` functions.
Goes over the given list pair-wise, assigning the odd values to `$a` and the even values to `$b`.
Then the block is executed an the <b>first</b> value-pair that generates a true value will pass the filter.

For example this code:

{% include file="examples/list_util_pairfirst.pl" %}

will execute the block twice and will generate this output:

```
$VAR1 = [
          6,
          5
        ];
```

## pairmap

Similar to the built-in [map](/transforming-a-perl-array-using-map) but works on pairs

For example this code:

{% include file="examples/list_util_pairmap.pl" %}

will add every pair and generate the following output:

```
$VAR1 = [
          5,
          11,
          14,
          17
        ];
```



